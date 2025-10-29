import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';

Widget overviewRichText(title, description) {
  return RichText(
    textAlign: TextAlign.start,
    text: TextSpan(
      style: TextStyle(
        fontFamily: "",
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: colorCodes.black,
      ),
      children: [
        TextSpan(text: "$title: "),
        TextSpan(
          text: description,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: colorCodes.graniteGrey,
          ),
        ),
      ],
    ),
  );
}
