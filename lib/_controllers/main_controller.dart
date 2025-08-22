import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_learners/view/utils/common_imports.dart';

class MainController extends GetxController {
  static MainController get to => Get.find<MainController>();
  RxBool serviceEnabled = false.obs;
  RxBool hasLocationPermission = false.obs;
  RxBool isLoading = false.obs;
  RxBool hasInternetConnection = true.obs;
  late LocationPermission permission;
  Rx<Position?> currentPosition = Rx<Position?>(null);
  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();

  // Subscription for internet connectivity changes
  StreamSubscription? connectivitySubscription;

  @override
  void onInit() {
    // Check internet connectivity first
    checkInternetConnection();
    // Setup connectivity listener
    setupConnectivityListener();
    // init Hive
    HiveStorage.init();
    getApiKeys();
    // Try to get user location
    // getUserLocation();
    super.onInit();
  }

  @override
  void onClose() {
    connectivitySubscription?.cancel();
    super.onClose();
  }

  Future<void> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      hasInternetConnection.value =
          result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      hasInternetConnection.value = false;
      Get.snackbar(
        'No Internet Connection',
        'Please check your internet connection and try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void setupConnectivityListener() {
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result == ConnectivityResult.none) {
        hasInternetConnection.value = false;
        Get.snackbar(
          'No Internet Connection',
          'Please check your internet connection.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        hasInternetConnection.value = true;
        // If we regain connection and don't have location yet, try again
        if (currentPosition.value == null) {
          getUserLocation();
        }
      }
    });
  }

  Future<void> getUserLocation() async {
    if (!hasInternetConnection.value) {
      Get.snackbar(
        'No Internet Connection',
        'Cannot get location without internet connection.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Check if location services are enabled
      serviceEnabled.value = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled.value) {
        isLoading.value = false;
        Get.snackbar(
          'Location Services Disabled',
          'Please enable location services in your device settings.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Check location permission
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          isLoading.value = false;
          hasLocationPermission.value = false;
          Get.snackbar(
            'Permission Denied',
            'Location permissions are denied. Some features may not work properly.',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        isLoading.value = false;
        hasLocationPermission.value = false;
        Get.snackbar(
          'Permission Permanently Denied',
          'Location permissions are permanently denied. Please enable them in app settings.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      hasLocationPermission.value = true;

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      );

      currentPosition.value = position;
      printInfo(info: position.toString());

      // Fetch nearby places only if we have position and internet
      if (hasInternetConnection.value) {
        await fetchNearbyPlaces(position.latitude, position.longitude);
      }
    } catch (e) {
      printError(info: 'Error getting location: $e');
      Get.snackbar(
        'Error',
        'Failed to get location: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchNearbyPlaces(double latitude, double longitude) async {
    if (!hasInternetConnection.value) return;

    try {
      final String url = 'https://maps.googleapis.com/maps/api/geocode/json'
          '?latlng=$latitude,$longitude'
          '&key=${AppUrls.apiKey}';

      final response = await http.get(Uri.parse(url)).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Connection timeout. Please try again.');
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          BottomNavController.to
              .userLocation(data['results'][0]['formatted_address']);
        } else {
          printInfo(info: 'No address found for the given coordinates');
        }
      } else {
        printError(info: 'Failed to fetch address: ${response.statusCode}');
      }
    } catch (e) {
      printError(info: 'Error fetching nearby places: $e');
      Get.snackbar(
        'Error',
        'Failed to fetch address information',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Method to manually retry getting location
  void retryGetLocation() {
    getUserLocation();
  }


  Future getApiKeys() async {
    await LocalStorage.readData("geminiApiKey").then((value) {
      if (value!.isEmpty) {
        ServiceController.to.getDataFunction(Queries.getApiKeys, {}).then(
          (value) {
            if (value.data.isNotEmpty) {
              printInfo(info: value.data["data"]['api_keys'][0].toString());
              LocalStorage.writeData(
                  "apiKey", value.data["data"]['api_keys'][0]['apiKey']);
              LocalStorage.writeData("geminiApiKey",
                  value.data["data"]['api_keys'][0]['geminiApiKey']);
            }
          },
        );
      }
    });
  }
}
