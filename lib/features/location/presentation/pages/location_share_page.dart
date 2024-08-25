import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:track_mate/core/theme/color_palette.dart';
import 'package:track_mate/core/utils/show_snackbar.dart';
import 'package:track_mate/features/location/bloc/location_bloc.dart';
import 'package:track_mate/features/location/presentation/pages/home_page.dart';
import 'package:track_mate/features/location/presentation/widgets/alert_dialog_box.dart';
import 'package:track_mate/features/location/presentation/widgets/share_location_page_map.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/widgets/loader.dart';

class LocationSharePage extends StatefulWidget {
  final UserModel user;
  const LocationSharePage({super.key, required this.user});

  @override
  State<LocationSharePage> createState() => _LocationSharePageState();
}

class _LocationSharePageState extends State<LocationSharePage> {
  late String code;

  @override
  void initState() {
    super.initState();
    context.read<LocationBloc>().add(GetCurrentLocation());
    code = generateCode();
  }

  bool _isSharing = false;
  void _toggleButton() {
    setState(() {
      _isSharing = !_isSharing;
    });
  }

  String generateCode() {
    Random random = Random();
    int min = 100000;
    int max = 999999;
    int code = min + random.nextInt(max - min + 1);
    return code.toString();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationBloc, LocationState>(
        listener: (context, state) {
          if (state is LocationError) {
            showSnackbar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is LocationLoading) {
            return const Loader(color: Colors.white);
          }
          if (state is LocationLoaded) {
            Position currentPosition = state.position;
            return _locationLoadedUI(currentPosition.longitude, currentPosition.latitude);
          }
          if (state is LocationSharing) {
            return _locationSharingUI(state.longitude, state.latitude);
          }
          return const Center(child: Text('Unexpected Error!'));
        },
      );
  }

  Widget _locationLoadedUI(double longitude, double latitude){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sharing location'),
        backgroundColor: ColorPalette.lightGreen1 ,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
                children:[
                  ShareLocationPageMap(
                    longitude: longitude,
                    latitude: latitude,
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    margin: const EdgeInsets.all(10),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                      ),
                      color: ColorPalette.lightGreen1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                        child: RichText(
                          text: TextSpan(
                              text: 'Your sharing code is: ',
                              style:  const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                    text: code,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: ColorPalette.green2
                                    )
                                )
                              ]
                          ),
                        ),
                      ),
                    ),
                  ),
                ]
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 5),
            child: SlideAction(
              height: 65,
              sliderRotate: false,
              innerColor: ColorPalette.primary,
              outerColor: ColorPalette.lightGreen1,
              elevation: 10,
              text: 'Start Sharing',
              textStyle: const TextStyle(
                  fontSize: 20,
                  color: Colors.black
              ),
              submittedIcon: const Icon(Icons.keyboard_double_arrow_right,size: 25),
              sliderButtonIcon: const Icon(Icons.keyboard_double_arrow_right, size: 25,),
              onSubmit: (){
                context.read<LocationBloc>().add(LocationShare(sharingCode: code, sharedUserUid: widget.user.uid, sharedUserName: widget.user.name));
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _locationSharingUI(double longitude, double latitude) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children:[
                  ShareLocationPageMap(
                    longitude: longitude,
                    latitude: latitude,
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    margin: const EdgeInsets.all(10),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      ),
                      color: ColorPalette.red1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                        child: RichText(
                          text: TextSpan(
                            text: 'Your sharing code is: ',
                            style:  const TextStyle(
                              fontSize: 18,
                              color:Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: code,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red
                                )
                              )
                            ]
                          ),
                        ),
                      ),
                    ),
                  ),
                ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 5),
              child: SlideAction(
                height: 65,
                innerColor: ColorPalette.red2,
                outerColor: ColorPalette.red1,
                elevation: 10,
                text: 'Stop Sharing',
                textStyle: TextStyle(
                  fontSize: 20,
                  color: ColorPalette.red2,
                  fontWeight: FontWeight.bold
                ),
                submittedIcon: const Icon(Icons.close ,size: 25,),
                sliderButtonIcon: Icon(Icons.close, size: 25, color: ColorPalette.red1,),
                onSubmit: (){
                  showDialog(context: context, builder: (context){
                    return AlertDialogBox(user: widget.user, actionText: 'Sharing',);
                  });
                  // context.read<LocationBloc>().add(LocationStopSharing());
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
