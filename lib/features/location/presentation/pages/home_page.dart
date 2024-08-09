import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:track_mate/core/models/user_model.dart';
import 'package:track_mate/core/theme/color_palette.dart';
import 'package:track_mate/features/location/presentation/pages/location_share_page.dart';
import 'package:track_mate/features/location/presentation/pages/location_track_page.dart';
import 'package:track_mate/features/location/presentation/widgets/share_location_page_map.dart';

class HomePage extends StatefulWidget {
  final UserModel user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const CameraPosition initial = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
        // appBar: AppBar(),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.user.name),
                ElevatedButton.icon(
                  icon: const Icon(Icons.share_location),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const LocationSharePage()));
                  },
                  label: Text(
                      'Share Location',
                    style: TextStyle(
                      color: ColorPalette.green2
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPalette.green1,
                    elevation: 10,
                    iconColor:ColorPalette.green2,
                    shadowColor: Colors.green
                  ),
                ),
                const SizedBox(height: 20,),
                ElevatedButton.icon(
                  icon: const Icon(Icons.track_changes),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const LocationTrackPage()));
                  },
                  label: const Text(
                    'Track Location',
                    style: TextStyle(
                        color: Colors.cyan
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette.cyan1,
                      elevation: 10,
                      iconColor:Colors.cyan,
                    shadowColor: Colors.cyan
                  ),
                )
              ],
            ),
          )
        ),
    );
  }
}
