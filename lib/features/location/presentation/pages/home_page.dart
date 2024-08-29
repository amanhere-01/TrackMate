import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:track_mate/core/models/user_model.dart';
import 'package:track_mate/core/theme/color_palette.dart';
import 'package:track_mate/features/location/presentation/pages/location_share_page.dart';
import 'package:track_mate/features/location/presentation/pages/location_track_page.dart';
import 'package:track_mate/features/location/presentation/widgets/alert_dialog_box.dart';
import 'package:track_mate/features/location/presentation/widgets/custom_app_bar.dart';

class HomePage extends StatefulWidget {
  final UserModel user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
        appBar: customAppBar(topColor: ColorPalette.peach, bottomColor: ColorPalette.peach1, text: 'T R A C K  M A T E',),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // TextButton(onPressed: () {
                //   Navigator.push(context, MaterialPageRoute(builder: (_)=> AlertDialogBox(user: widget.user, actionText: 'actionText')));
                // },
                // child: Text('dsdsdsdsdsd'),),
                ElevatedButton.icon(
                  icon: const Icon(Icons.share_location),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_) => LocationSharePage(user: widget.user,)));
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
                    Navigator.push(context, MaterialPageRoute(builder: (_) => LocationTrackPage(user: widget.user,)));
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
