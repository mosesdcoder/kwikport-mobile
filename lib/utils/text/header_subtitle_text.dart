import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

Column headerSubtitleDescription(
  title,
  description, {
  subtitlefontSize,
  subtitlefontWeight,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: kwikTextStlye(32.0, FontWeight.w500, colorCodes.black),
      ),
      SizedBox(height: 4),
      Text(
        description,
        style: kwikTextStlye(
          subtitlefontSize ?? 16.0,
          subtitlefontWeight ?? FontWeight.w400,
          colorCodes.jetBlack,
        ),
      ),
    ],
  );
}

Column headerSubtitleDescriptionsmall(title, description) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: kwikTextStlye(24.0, FontWeight.w600, colorCodes.black),
      ),
      SizedBox(height: 4),
      Text(
        description,
        style: kwikTextStlye(14.0, FontWeight.w300, colorCodes.jetBlack),
      ),
    ],
  );
}
