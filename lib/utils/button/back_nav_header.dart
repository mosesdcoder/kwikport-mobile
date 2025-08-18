import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';

Widget backNavRow(context, description, {suffix, func}) {
  return Row(
    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      InkWell(
        onTap:
            func ??
            () {
              Navigator.pop(context);
            },
        child: Image.asset(
          'assets/images/icons/button back.png',
          height: 48,
          width: 48,
        ),
      ),
      SizedBox(width: 12),
      Text(
        description,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 24.0,
          fontWeight: FontWeight.w600,
          color: colorCodes.black,
        ),
      ),
      // suffix ?? widthsizedBox(30.0),
    ],
  );
}
