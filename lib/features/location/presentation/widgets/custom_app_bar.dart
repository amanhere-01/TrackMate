import 'package:flutter/material.dart';

import '../../../../core/theme/color_palette.dart';

AppBar customAppBar({required Color topColor, required Color bottomColor, required String text}){
  return AppBar(
    flexibleSpace: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            topColor,
            bottomColor,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    ),
    title: Text(text),
    centerTitle: true,
  );
}