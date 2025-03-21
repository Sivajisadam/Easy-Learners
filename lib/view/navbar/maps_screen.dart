import 'package:easy_learners/view/utils/common_imports.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          mapType: MapType.hybrid,
          initialCameraPosition: CameraPosition(
              target: LatLng(MainController.to.currentPosition.value!.latitude,
                  MainController.to.currentPosition.value!.longitude),
              zoom: 14.4746),
          onMapCreated: (GoogleMapController controller) {
            MainController.to.mapController.complete(controller);
          },
        ),
      ),
    );
  }
}
