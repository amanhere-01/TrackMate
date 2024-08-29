import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pinput/pinput.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:track_mate/core/models/user_model.dart';
import 'package:track_mate/core/theme/theme.dart';
import 'package:track_mate/features/auth/presentaion/widgets/glass_box.dart';
import 'package:track_mate/features/location/bloc/location_bloc.dart';

import '../../../../core/theme/color_palette.dart';
import '../../../../core/utils/show_snackbar.dart';
import '../../../../core/widgets/loader.dart';
import '../widgets/alert_dialog_box.dart';
import '../widgets/map_widget.dart';

class LocationTrackPage extends StatefulWidget {
  final UserModel user;
  const LocationTrackPage({super.key, required this.user});

  @override
  State<LocationTrackPage> createState() => _LocationTrackPageState();
}

class _LocationTrackPageState extends State<LocationTrackPage> {
  late String _code = '0';
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 60,
    textStyle: const TextStyle(
        fontSize: 25,
        color: Colors.white,
        fontWeight: FontWeight.w600
    ),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: ColorPalette.white4
    ),
  );

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
                        MapWidget(longitude: lon, latitude: lat),
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
          );
        }

        return Scaffold(
          backgroundColor: ColorPalette.white2,
          appBar: AppBar(
            title: const Text("Tracking location"),
            backgroundColor: ColorPalette.white2,
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Enter the code',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:40,
                        color: ColorPalette.darkBlue1
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Pinput(
                      length: 6,
                      showCursor: false,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: defaultPinTheme.copyDecorationWith(
                        border: Border.all(color: ColorPalette.darkBlue2.withOpacity(0.5)),
                      ),
                      submittedPinTheme:defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration?.copyWith(
                          color: ColorPalette.darkBlue1
                        ),
                      ),
                      onCompleted: (enteredCode) => _code = enteredCode,
                    ),
                    const SizedBox(height: 20,),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: MediaQuery.of(context).size.width/10),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(MediaQuery.of(context).size.width,60),
                            backgroundColor: ColorPalette.darkBlue2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            elevation: 10,
                            shadowColor: ColorPalette.darkBlue
                          ),
                        onPressed: () {
                          if(_code.length==6){
                            context.read<LocationBloc>().add(LocationTrack(code: _code));
                          }
                          else{
                            showSnackbar(context, 'Please enter the valid code');
                          }
                          _code='0';
                        },
                        child: const Text('Track',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:25,
                              color:Colors.white
                          ),
                        )
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
