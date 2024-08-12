import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:track_mate/core/theme/theme.dart';
import 'package:track_mate/features/auth/bloc/auth_bloc.dart';
import 'package:track_mate/features/auth/data/auth_remote_data_source.dart';
import 'package:track_mate/features/location/bloc/location_bloc.dart';
import 'package:track_mate/features/location/data/location_remote_data_source.dart';
import 'package:track_mate/features/splash_screen.dart';
import 'package:track_mate/firebase_options.dart';
import 'package:track_mate/features/location/presentation/pages/home_page.dart';
import 'features/auth/presentaion/pages/sign_in_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(
    MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthBloc(AuthRemoteDataSourceImpl())),
          BlocProvider(create: (context) => LocationBloc(LocationRemoteDataSourceImpl()))
        ],
        child: const MyApp()
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightThemeMode,
      home: const SplashScreen()  ,
    );
  }
}
