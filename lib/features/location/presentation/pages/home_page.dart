import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:track_mate/core/theme/color_palette.dart';
import 'package:track_mate/features/location/presentation/widgets/home_page_map.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
          child: Column(
            children: [
              const Expanded(child: HomePageMap()),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.share_location),
                      onPressed: (){},
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
                    ElevatedButton.icon(
                      icon: const Icon(Icons.track_changes),
                      onPressed: (){},
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
                    ),
                  ],
                ),
              )
            ],
          )
        ),
    );
  }
}
