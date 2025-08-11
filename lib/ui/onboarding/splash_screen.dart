import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
      Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorCodes.azureBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/Kwiport.png', height: 68, width: 264),
          ],
        ),
      ),
    );
  }
}
