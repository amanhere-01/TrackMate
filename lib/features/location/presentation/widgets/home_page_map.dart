import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:track_mate/core/widgets/loader.dart';

class HomePageMap extends StatefulWidget {
  const HomePageMap({super.key});

  @override
  State<HomePageMap> createState() => _HomePageMapState();
}

class _HomePageMapState extends State<HomePageMap> {
  static const CameraPosition initial = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getCurrentLocation(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Loader();
        }
        else if (snapshot.hasError) {
          String errorMessage;
          if (snapshot.error == 'Location services are disabled.') {
            errorMessage = 'Please enable location services.';
          } else if (snapshot.error == 'Location permissions are denied') {
            errorMessage = 'Please grant location permissions.';
          } else if (snapshot.error == 'Location permissions are permanently denied, we cannot request permissions.') {
            errorMessage = 'Location permissions are permanently denied.';
          } else {
            errorMessage = 'An unexpected error occurred: ${snapshot.error}';
          }
          return Center(child: Text(errorMessage));
        }
        else if(snapshot.hasData){
          Position currentPosition = snapshot.data;
          CameraPosition initialCameraPosition = CameraPosition(
            target: LatLng(currentPosition.latitude, currentPosition.longitude),
            zoom: 15
          );
          return GoogleMap(
            initialCameraPosition: initialCameraPosition,
            markers: {
              Marker(
                markerId: MarkerId('currentPosition'),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                position:  LatLng(currentPosition.latitude, currentPosition.longitude),
              ),
            }
          );
        }
        return const Center(child: Text('No location data available'));

      },
    );
  }
}
