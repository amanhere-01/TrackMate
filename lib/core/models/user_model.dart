import 'package:firebase_auth/firebase_auth.dart';

class User{
  final String uid;
  final String name;
  final String email;

  User({required this.uid, required this.name, required this.email});

  factory User.fromDatabase(UserCredential user){
    return User(
      uid: user.user!.uid,
      name: '',
      email: '',
    )
  }

}