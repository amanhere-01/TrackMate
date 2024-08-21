import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sharing location'),
        backgroundColor: ColorPalette.lightGreen1 ,
      ),
      body: BlocConsumer<LocationBloc, LocationState>(
        listener: (context, state) {
          if (state is LocationError) {
            showSnackbar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is LocationLoading) {
            return const Loader(color: Colors.black);
          }
          if (state is LocationLoaded) {
            Position currentPosition = state.position;
            return _buildLocationUI(currentPosition.longitude, currentPosition.latitude);
          }
          if (state is LocationSharing) {
            return _buildLocationUI(state.longitude, state.latitude);
          }
          return const Center(child: Text('Unexpected Error!'));
        },
      ),
    );
  }

  Widget _buildLocationUI(double longitude, double latitude) {
    return Stack(
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
            color: ColorPalette.primary,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              child: RichText(
                text: TextSpan(
                  text: 'Your sharing code is: ',
                  style:  TextStyle(
                    fontSize: 18,
                    color: ColorPalette.white7,
                  ),
                  children: [
                    TextSpan(
                      text: code,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                      )
                    )
                  ]
                ),
              ),
            ),
          ),
        )
      ]
    );
  }
}
