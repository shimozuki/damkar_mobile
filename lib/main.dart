import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistem Informasi Damkar',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
