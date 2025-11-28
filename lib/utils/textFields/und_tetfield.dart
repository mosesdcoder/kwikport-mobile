import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';

Widget fundTextfield(controller, hintText, onChanged) {
  return SizedBox(
    width: 255,
    height: 50,
    child: TextField(
      showCursor: true,
      cursorColor: colorCodes.bluetiful,
      controller: controller,
      maxLines: 1,
      autofocus: true,
      textAlign: TextAlign.center,

      keyboardType: TextInputType.numberWithOptions(),
      //  inputFormatters: ,
      style: TextStyle(
        color: colorCodes.pigmentGreen,
        // fontFamily: 'DM Sans',
        fontSize: 32,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 0.0,
        ),

        hintText: hintText,
        hintStyle: TextStyle(
          color: colorCodes.gainsboro,
          // fontFamily: 'DM Sans',
          fontSize: 32,
          fontWeight: FontWeight.w500,
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colorCodes.graniteGrey),
        ),

        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colorCodes.graniteGrey),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colorCodes.graniteGrey),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: colorCodes.graniteGrey),
        ),
      ),
      onChanged: onChanged,
    ),
  );
}
