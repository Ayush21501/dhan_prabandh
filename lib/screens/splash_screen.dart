import 'package:dhan_prabandh/screens/home_screen.dart';
import 'package:dhan_prabandh/screens/login/welcome_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Simulate checking for token, replace this with your actual token check logic

    // Simulate a delay for splash screen
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/splash.jpg'),
            fit:
                BoxFit.cover, // This ensures the image covers the entire screen
          ),
        ),
      ),
    );
  }
}
