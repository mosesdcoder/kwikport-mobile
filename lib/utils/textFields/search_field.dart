import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';

Widget searchFieldColumn(
  title,
  errorText,
  controller,
  hintText, {

  // title,
  suffixIcon,
  maxLines,
  maxLength,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: colorCodes.black,
        ),
      ),
      SizedBox(height: 8),
      TextField(
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w300,
          color: colorCodes.graniteGrey,
        ),
        controller: controller,
        autocorrect: true,
        keyboardType: TextInputType.name,
        maxLines: maxLines,
        maxLength: maxLength,

        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            color: colorCodes.graniteGrey,
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),

          prefixIcon: Container(
            height: 12,
            width: 12,
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 10.0,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 3.0),
            child:
                suffixIcon ??
                Image.asset(
                  "assets/images/icons/search-normal.png",
                  height: 15,
                  width: 15,
                ),
          ),
          fillColor: colorCodes.antiFlashWhite,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              width: 1.3,
              color:
                  (errorText != '')
                      ? colorCodes.portlandOrange
                      : colorCodes.antiFlashWhite,
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
                      : colorCodes.antiFlashWhite,
            ),
            // errorBorder:  OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(8),
            //   borderSide: BorderSide(width: 1.3, color: colorCodes.portlandOrange),
          ),
        ),
      ),
    ],
  );
}
