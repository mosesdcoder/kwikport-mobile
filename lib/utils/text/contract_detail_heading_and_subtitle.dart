import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

Widget contractDetailHeadingAndSubtitle(
  leftTitle,
  rightTitle,
  leftSubtitle,
  rightSubtitle, {
  fontFamily,
}) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leftTitle,
            style: kwikTextStlye(12.0, FontWeight.w300, colorCodes.graniteGrey),
          ),
          Text(
            rightTitle,
            style: kwikTextStlye(12.0, FontWeight.w300, colorCodes.graniteGrey),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leftSubtitle,
            style: kwikTextStlye(14.0, FontWeight.w600, colorCodes.black),
          ),
          Text(
            rightSubtitle,
            style: kwikTextStlye(
              14.0,
              FontWeight.w600,
              colorCodes.black,
              fontFamily: fontFamily,
            ),
          ),
        ],
      ),
    ],
  );
}
