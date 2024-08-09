import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShareLocationPageMap extends StatelessWidget {
  final Position currentPosition;

  const ShareLocationPageMap({super.key, required this.currentPosition});

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(currentPosition.latitude, currentPosition.longitude),
        zoom: 15,
      ),
      markers: {
        Marker(
          markerId: const MarkerId('currentPosition'),
          icon: BitmapDescriptor.defaultMarker,
          position: LatLng(
            currentPosition.latitude,
            currentPosition.longitude,
          ),
        ),
      },
    );
  }
}
