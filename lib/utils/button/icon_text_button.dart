import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

Widget iconTextButton(
  text,
  iconImg,
  func,
  backgroundcolor,
  borderColor, {
  textColor,
}) {
  return kwikbutton(
    '',
    func,
    textColor: colorCodes.textBlack,
    backgroundcolor: backgroundcolor ?? colorCodes.portlandOrange,
    borderColor: borderColor,
    buttonChild: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(iconImg, height: 18, width: 18),
        SizedBox(width: 8),
        Text(
          text,
          style: kwikTextStlye(
            16.0,
            FontWeight.w500,
            textColor ?? colorCodes.black,
          ),
        ),
      ],
    ),
  );
}
