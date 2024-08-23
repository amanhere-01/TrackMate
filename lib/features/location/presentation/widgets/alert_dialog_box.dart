import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_mate/core/theme/color_palette.dart';

import '../../../../core/models/user_model.dart';
import '../../bloc/location_bloc.dart';
import '../pages/home_page.dart';

class AlertDialogBox extends StatelessWidget {
  final UserModel user;
  const AlertDialogBox({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Stop Sharing?',
        style: TextStyle(
            fontWeight: FontWeight.w600
        ),
      ),
      content: const Text("Are you sure ?",
        style: TextStyle(
          color: ColorPalette.text,
          fontSize: 16
        ),
      ),
      actions: [
        TextButton(
            onPressed: (){
                context.read<LocationBloc>().add(LocationStopTracking());
                // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => HomePage(user: user)), (route) => false);
            },
          child: const Text('Yes',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red
            ),
          )
        ),
        TextButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          child: const Text('No',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue
            ),
          )
        )
      ],
    );
  }
}
