import 'package:flutter/material.dart';
import './home.dart';
import './dsignin.dart';
import './psignin.dart';
import './drawer.dart';
import './admin.dart';
import './ambulance.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,
      title: 'IITB.Hospital',
      home: const DocOrPat(),
      // Register routes
      routes: {
        '/drawer': (BuildContext ctx) => const Prop(),
        '/dsignin': (BuildContext ctx) => const DSignInPage(),
        '/psignin': (BuildContext ctx) => const SignInPage(),
        '/admin': (BuildContext ctx) => const ASignInPage(),
        '/ambulance':(BuildContext ctx) => const AmbulancePage(),
      },
    );
  }
}