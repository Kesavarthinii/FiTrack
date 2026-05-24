import 'package:flutter/material.dart';
import 'splash_screen.dart';   // <-- NEW SCREEN

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "FitRack",
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: SplashScreen(),   // <-- UPDATED
    );
  }
}
