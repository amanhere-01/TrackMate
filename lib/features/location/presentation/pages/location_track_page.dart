import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:track_mate/features/location/bloc/location_bloc.dart';
import 'package:track_mate/features/location/presentation/widgets/share_location_page_map.dart';

import '../../../../core/utils/show_snackbar.dart';
import '../../../../core/widgets/loader.dart';

class LocationTrackPage extends StatefulWidget {
  const LocationTrackPage({super.key});

  @override
  State<LocationTrackPage> createState() => _LocationTrackPageState();
}

class _LocationTrackPageState extends State<LocationTrackPage> {
  final _codeController = TextEditingController();

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
          return const Loader(color: Colors.white,);
        }
        if(state is LocationTracked){
          final double lon = state.locationModel.longitude;
          final double lat = state.locationModel.latitude;
          return SafeArea(
            // appBar: AppBar(),
            child: Column(
              children: [
                Expanded(
                    child: ShareLocationPageMap(longitude: lon, latitude: lat)
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        context.read<LocationBloc>().add(LocationStopTracking());
                      },
                      child: const Text('Stop Tracking')
                  )
                )
              ],
            ) ,
          );

        }
        return Scaffold(
            appBar: AppBar(
              title: const Text("Tracking location"),
            ),
            body: Center(
              child: Container(
                height: 250,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text('Enter the code'),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 5
                        ),
                        borderRadius: BorderRadius.circular(30)
                      ),
                      child: TextField(
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if(_codeController.text.isNotEmpty && _codeController.text.length==6){
                            context.read<LocationBloc>().add(LocationTrack(code: _codeController.text));
                          }
                          else if(_codeController.text.length<6 || _codeController.text.length>6){
                            showSnackbar(context, 'Pleas enter valid code');
                          }
                          else{
                            showSnackbar(context, 'Please enter the code');
                          }
                        },
                        child: const Text('Track')
                    )
                  ],
                ),
              ),
            )
        );
      },
    );
  }
}
