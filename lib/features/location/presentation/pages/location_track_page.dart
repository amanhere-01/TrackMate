import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:track_mate/core/models/user_model.dart';
import 'package:track_mate/features/location/bloc/location_bloc.dart';
import 'package:track_mate/features/location/presentation/widgets/share_location_page_map.dart';

import '../../../../core/theme/color_palette.dart';
import '../../../../core/utils/show_snackbar.dart';
import '../../../../core/widgets/loader.dart';
import '../widgets/alert_dialog_box.dart';

class LocationTrackPage extends StatefulWidget {
  final UserModel user;
  const LocationTrackPage({super.key, required this.user});

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
      builder: (context, state){
        if(state is LocationLoading){
          return const Loader(color: Colors.red ,);
        }
        if(state is LocationTracking){
          final double lon = state.locationModel.longitude;
          final double lat = state.locationModel.latitude;
          final String name = state.locationModel.sharedUserName;
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        ShareLocationPageMap(longitude: lon, latitude: lat),
                        Container(
                          alignment: Alignment.topCenter,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)
                            ),
                            color: ColorPalette.cyan1,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                              child: RichText(
                                text: TextSpan(
                                    text: 'Tracking location of ',
                                    style:  const TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                          text: name,
                                          style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: ColorPalette.gradient2
                                          )
                                      )
                                    ]
                                ),
                              ),
                            ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 5),
                    child: SlideAction(
                      height: 65,
                      sliderRotate: false,
                      innerColor: ColorPalette.cyan2,
                      outerColor: ColorPalette.cyan1,
                      elevation: 10,
                      text: 'Stop Tracking',
                      textStyle: const TextStyle(
                          fontSize: 20,
                          color: Colors.black
                      ),
                      submittedIcon: const Icon(Icons.keyboard_double_arrow_right,size: 25),
                      sliderButtonIcon: const Icon(Icons.keyboard_double_arrow_right, size: 25,),
                      onSubmit: (){
                        showDialog(context: context, builder: (context){
                          return AlertDialogBox(user: widget.user, actionText: 'Tracking',);
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            // // appBar: AppBar(),
            // child: Column(
            //   children: [
            //     Expanded(
            //         child: ShareLocationPageMap(longitude: lon, latitude: lat)
            //     ),
            //
            //     SizedBox(
            //       width: double.infinity,
            //       child: ElevatedButton(
            //           onPressed: () {
            //             context.read<LocationBloc>().add(LocationStopTracking());
            //           },
            //           child: const Text('Stop Tracking')
            //       )
            //     )
            //   ],
            // ) ,
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
