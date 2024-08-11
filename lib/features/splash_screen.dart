import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:track_mate/features/auth/data/auth_remote_data_source.dart';

import '../core/models/user_model.dart';
import 'auth/presentaion/pages/sign_in_page.dart';
import 'location/presentation/pages/home_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<UserModel?> _checkAuthState() async{
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return AuthRemoteDataSourceImpl().getCurrentUserModel();
      } else {
        return null;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _checkAuthState(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasData && snapshot.data != null) {
              final user = snapshot.data!;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomePage(user: snapshot.data!)),
                );
              });
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const SignInPage()),
                );
              });
            }
            return Container(); // Just return an empty container
          }
        },
      ),
    );
  }
}
