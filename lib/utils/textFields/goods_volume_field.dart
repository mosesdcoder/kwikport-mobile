import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/colors/color.dart';

Widget goodsVolumnFieldColumn(
  errorText,
  controller, {
  title,
  hintText,
  suffixIcon,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title ?? 'Volume(tons)',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: colorCodes.black,
        ),
      ),
      SizedBox(height: 8),
      TextField(
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: colorCodes.black,
        ),
        controller: controller,
        autocorrect: true,
        keyboardType: TextInputType.numberWithOptions(),
        decoration: InputDecoration(
          hintText: hintText ?? 'Min: 1 ton',
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            color: colorCodes.graniteGrey,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
          suffixIcon: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: suffixIcon ?? SizedBox(),
          ),
          fillColor: colorCodes.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              width: 1.3,
              color: colorCodes.antiFlashWhite,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              width: 1.3,
              color:
                  (errorText != '')
                      ? colorCodes.portlandOrange
                      : colorCodes.antiFlashWhite,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color:
                  (errorText != '')
                      ? colorCodes.portlandOrange
                      : colorCodes.azureBlue,
            ),
          ),
        ),
      ),
    ],
  );
}
