import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/onboarding/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

int currentIndex = 1;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final primaryColor = HexColor("#3385FF");
    final primarySwatch = MaterialColor(primaryColor.value, {
      50: primaryColor.withOpacity(0.1),
      100: primaryColor.withOpacity(0.2),
      200: primaryColor.withOpacity(0.3),
      300: primaryColor.withOpacity(0.4),
      400: primaryColor.withOpacity(0.5),
      500: primaryColor.withOpacity(0.6),
      600: primaryColor.withOpacity(0.7),
      700: primaryColor.withOpacity(0.8),
      800: primaryColor.withOpacity(0.9),
      900: primaryColor.withOpacity(1.0),
    });

    final colorScheme = ColorScheme.fromSwatch(primarySwatch: primarySwatch);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kwik Port',
      theme: ThemeData(
        colorScheme: colorScheme.copyWith(background: colorCodes.whiteSmoke),
      ),
      home: const MediaQuery(data: MediaQueryData(), child: SplashScreen()),
    );
  }
}
