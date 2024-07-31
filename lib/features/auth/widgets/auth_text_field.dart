import 'package:flutter/material.dart';
import 'package:track_mate/core/theme/color_palette.dart';

class AuthTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool isObscure;
  final IconData icon;
  const AuthTextField({super.key, required this.hint, required this.controller, required this.isObscure, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hint,
          style: TextStyle(
              fontSize: 18,
              color: ColorPalette.white3
          ),
        ),
        const SizedBox(height: 8,),
        TextFormField(
          controller: controller,
          cursorColor: ColorPalette.white3,
          obscureText: isObscure,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            prefixIconColor: Colors.white
          ),
          validator: (value){
            if(value!.isEmpty){
              return '$hint is empty!';
            }
            return null;
          },     
        )
      ],
    );
  }
}
