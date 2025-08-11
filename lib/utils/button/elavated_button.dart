import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

Widget elevatedbutton(
  btntxt,
  btnFunc, {
  textColor,
  backgroundcolor,
  textWidth,
  enabled = true,
  borderRadius,
}) {
  return ElevatedButton(
    onPressed: enabled ? btnFunc : null,
    style: ElevatedButton.styleFrom(
      elevation: 0.0,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      backgroundColor: backgroundcolor ?? colorCodes.azureBlue,
      disabledBackgroundColor: colorCodes.darkGrey.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
      ),
    ),

    child: Text(
      btntxt,
      style: kwikTextStlye(
        10.0,
        FontWeight.w600,
        enabled ? colorCodes.whiteSmoke : colorCodes.aluminium,
      ),
    ),
  );
}
