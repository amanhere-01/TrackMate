import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:track_mate/core/utils/show_snackbar.dart';
import 'package:track_mate/core/widgets/loader.dart';

import '../../bloc/location_bloc.dart';

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

  @override
  void initState() {
    super.initState();
    context.read<LocationBloc>().add(GetCurrentLocation());
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationBloc, LocationState>(
      listener: (context, state) {
        if(state is LocationError){
          showSnackbar(context, state.message);
        }
      },
      builder: (context, state) {
        if(state is LocationLoading){
          return const Loader(color: Colors.black,);
        }
        if(state is LocationLoaded) {
          Position currentPosition = state.position;
          return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(currentPosition.latitude, currentPosition.longitude),
                zoom: 15
              ),
            // initialCameraPosition: initial,
              markers: {
                Marker(
                  markerId: const MarkerId('currentPosition'),
                  icon: BitmapDescriptor.defaultMarker,
                  position: LatLng(
                      currentPosition.latitude, currentPosition.longitude),
                ),
              }
          );
        }
        return GoogleMap(
            initialCameraPosition: initial,
            markers: {
              Marker(
                markerId: const MarkerId('currentPosition'),
                icon: BitmapDescriptor.defaultMarker,
                position: LatLng(
                    initial.target.latitude, initial.target.latitude),
              ),
            }
        );
        // return const Center(child: Text('Unexpected error occursssss!'),);
      },
    );
  }
}
