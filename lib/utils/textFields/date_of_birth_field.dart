import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';

Widget dateofbirthTxtField(hintText, controller, errorText, showdate) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        hintText,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: colorCodes.black,
        ),
      ),
      const SizedBox(height: 5),
      SizedBox(
        height: 52,
        child: TextField(
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w300,
            color: colorCodes.black,
          ),
          controller: controller,
          autocorrect: true,
          enableSuggestions: true,
          keyboardType: TextInputType.none,
          decoration: InputDecoration(
            hintText: '00/00/0000',
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
            ),
          ),
          onTap: showdate,
        ),
      ),
    ],
  );
}
