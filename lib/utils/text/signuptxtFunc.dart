import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';

Widget signuptxtFunc(richtext, loginsignuptxt, loginsignupfunc) {
  return RichText(
    text: TextSpan(
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: colorCodes.black,
      ),
      children: [
        TextSpan(text: richtext),
        TextSpan(
          recognizer:
              TapGestureRecognizer()
                ..onTap = () {
                  loginsignupfunc();
                },
          text: loginsignuptxt,
          style: TextStyle(color: colorCodes.azureBlue),
        ),
      ],
    ),
  );
}
