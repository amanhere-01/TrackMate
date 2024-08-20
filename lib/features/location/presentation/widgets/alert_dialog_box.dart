import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_mate/core/theme/color_palette.dart';

import '../../bloc/location_bloc.dart';

class AlertDialogBox extends StatelessWidget {
  final String actionText;

  const AlertDialogBox({super.key, required this.actionText});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Stop $actionText',
        style: const TextStyle(
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
              if(actionText=='Sharing'){
                context.read<LocationBloc>().add(LocationStopSharing());
              } else{
                context.read<LocationBloc>().add(LocationStopTracking());
              }
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
