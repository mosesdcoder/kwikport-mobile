import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/home/dashboard/dashboard.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

class LoginSuccessfulScreen extends StatefulWidget {
  const LoginSuccessfulScreen({super.key});

  @override
  State<LoginSuccessfulScreen> createState() => _LoginSuccessfulScreenState();
}

class _LoginSuccessfulScreenState extends State<LoginSuccessfulScreen> {
  @override
  void initState() {
    Timer(
      Duration(seconds: 2),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorCodes.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/icons/success_login.png',
              height: 96,
              width: 113,
            ),
            SizedBox(height: 40),
            Text(
              'Login Successfully!',
              style: kwikTextStlye(24.0, FontWeight.w600, colorCodes.black),
            ),
          ],
        ),
      ),
    );
  }
}
