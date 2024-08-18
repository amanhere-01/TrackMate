import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:track_mate/core/theme/color_palette.dart';
import 'package:track_mate/core/utils/show_snackbar.dart';
import 'package:track_mate/features/location/bloc/location_bloc.dart';
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
    return Column(
      children: [
        Expanded(
          child: ShareLocationPageMap(
            longitude: longitude,
            latitude: latitude,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: ColorPalette.white3,
          ),
          child: Column(
            children: [
              Text(
                'Share code',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: ColorPalette.white7,
                ),
              ),
              Text(
                code,
                style: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(
                  onPressed: () {
                    if (!_isSharing) {
                      context.read<LocationBloc>().add(LocationShare(sharingCode: code, uid: widget.user.uid));
                    } else {
                      context.read<LocationBloc>().add(LocationStopTracking());
                    }
                    _toggleButton();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isSharing
                        ? ColorPalette.red1
                        : ColorPalette.purple1,
                    minimumSize: const Size(double.infinity, 50),
                    foregroundColor: _isSharing
                        ? ColorPalette.red2
                        : ColorPalette.purple2,
                    elevation: 10,
                  ),
                  child: Text(
                    _isSharing ? 'Stop sharing' : 'Start sharing',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
