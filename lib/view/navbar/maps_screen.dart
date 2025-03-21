import 'package:easy_learners/_controllers/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
