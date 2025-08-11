import 'package:flutter/material.dart';
import 'package:kwik_port/ui/onboarding/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kwik Port',
       theme: ThemeData(
            // colorScheme: colorScheme.copyWith(background: Colors.white),
          ),
      home: const MediaQuery(data: MediaQueryData(), child: SplashScreen()),
    );
  }
}
