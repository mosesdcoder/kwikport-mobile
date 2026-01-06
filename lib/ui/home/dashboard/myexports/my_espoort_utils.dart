import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

Widget instructionContainer(title, subtitle) {
  return Container(
    height: 109,
    width: 390,
    alignment: Alignment.center,
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
    decoration: BoxDecoration(
      color: colorCodes.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(width: 1.5, color: colorCodes.paleCornflowerBlue),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          "assets/images/icons/dashboard/Frame 1000006029.png",
          height: 20,
          width: 20,
        ),
        SizedBox(width: 4),
        SizedBox(
          width: 292,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: kwikTextStlye(12.0, FontWeight.w600, colorCodes.black),
              ),
              Text(
                subtitle,
                textAlign: TextAlign.start,
                style: kwikTextStlye(12.0, FontWeight.w300, colorCodes.black),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}



