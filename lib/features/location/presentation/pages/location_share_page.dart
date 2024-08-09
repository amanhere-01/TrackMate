import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:track_mate/core/theme/color_palette.dart';
import 'package:track_mate/core/utils/show_snackbar.dart';
import 'package:track_mate/features/location/bloc/location_bloc.dart';
import 'package:track_mate/features/location/presentation/widgets/share_location_page_map.dart';

import '../../../../core/widgets/loader.dart';

class LocationSharePage extends StatefulWidget {
  const LocationSharePage({super.key});

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

  String generateCode(){
    Random random = Random();
    int min = 100000;
    int max = 999999;
    int code = min + random.nextInt(max-min+1);
    return code.toString();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sharing location'),
      ),
      body: BlocConsumer<LocationBloc, LocationState>(
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
            return Column(
                children: [
                  Expanded(
                      // height: MediaQuery.of(context).size.height/2,
                      child: ShareLocationPageMap(currentPosition: currentPosition,)
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: ColorPalette.white3
                    ),
                    child:  Column(
                      children: [
                        Text('Share code',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: ColorPalette.white7
                          ),
                        ),
                        Text(code,
                          style: const TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: !_isSharing
                              ? ElevatedButton(
                                  onPressed: (){
                                    _toggleButton();
                                    final p = context.read<LocationBloc>().add(GetCurrentLocation());
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorPalette.purple1,
                                    minimumSize: const Size(double.infinity, 50),
                                    foregroundColor: ColorPalette.purple2,
                                    elevation: 10
                                  ),
                                  child: const Text('Start sharing',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                              )
                              : ElevatedButton(
                                  onPressed: (){_toggleButton();},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorPalette.red1,
                                    minimumSize: const Size(double.infinity, 50),
                                    foregroundColor: ColorPalette.red2,
                                    elevation: 10

                                  ),
                                  child: const Text('Stop sharing',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                              ),
                        )
                      ],
                    ),
                  )
                ],
              );
          }
          return const Center(child: Text('Unexpected Error Nigga!'),);
        },
),
    );
  }
}
