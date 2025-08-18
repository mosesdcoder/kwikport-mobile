import 'package:flutter/material.dart';

TextStyle kwikTextStlye(
  fontSize,
  fontWeight,
  color, {
  decoration,
  fontStyle,
  fontFamily,
}) {
  return TextStyle(
    fontFamily: fontFamily ?? 'Poppins',
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    decoration: decoration,
    decorationColor: color,
    fontStyle: fontStyle ?? FontStyle.normal,
  );
}
