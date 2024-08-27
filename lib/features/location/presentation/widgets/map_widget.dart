import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatelessWidget {
  final double longitude;
  final double latitude;


  const MapWidget({super.key, required this.longitude, required this.latitude});

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 15,
      ),
      markers: {
        Marker(
          markerId: const MarkerId('currentPosition'),
          icon: BitmapDescriptor.defaultMarker,
          position: LatLng(
            latitude,
            longitude,
          ),
        ),
      },
    );
  }
}
