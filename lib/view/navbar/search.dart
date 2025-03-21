import 'package:easy_learners/_controllers/bottom_nav_controller.dart';
import 'package:easy_learners/_controllers/main_controller.dart';
import 'package:easy_learners/view/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker_google/place_picker_google.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PlacePicker(
          apiKey: AppUrls.apiKey,
          autocompletePlacesSearchRadius: 3000,
          onPlacePicked: (LocationResult result) {
            debugPrint("Place picked: ${result.formattedAddress}");
            BottomNavController.to
                .userLocation(result.formattedAddress.toString());
            Get.back();
          },
          initialLocation: LatLng(
              MainController.to.currentPosition.value?.latitude ?? 0.0,
              MainController.to.currentPosition.value?.longitude ?? 0.0),
          searchInputConfig: const SearchInputConfig(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            autofocus: false,
            textDirection: TextDirection.ltr,
          ),
          searchInputDecorationConfig: const SearchInputDecorationConfig(
            hintText: "Search for a building, street or ...",
          ),
          enableNearbyPlaces: false,
          // myLocationButtonEnabled: true,
          myLocationEnabled: true,
        ),
      ),
    );
  }
}
