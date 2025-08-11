import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';

Container validationtext(errorText) {
  return Container(
    child: Text(
      errorText,
      style: TextStyle(
        fontFamily: 'DM Sans',
        fontSize: 14.0,
        fontWeight: FontWeight.w400,
        color: colorCodes.portlandOrange,
      ),
    ),
  );
}
