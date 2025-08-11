import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';

Widget emailFieldColumn(errorText, controller, {title}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title ?? 'Email',
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
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'user@gmail.com',
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

          fillColor: colorCodes.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              width: 1.3,
              color:
                  (errorText != '')
                      ? colorCodes.portlandOrange
                      : colorCodes.azureBlue,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              width: 1.3,
              color:
                  (errorText != '')
                      ? colorCodes.portlandOrange
                      : colorCodes.azureBlue,
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
            // errorBorder:  OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(8),
            //   borderSide: BorderSide(width: 1.3, color: colorCodes.portlandOrange),
          ),
        ),
      ),
    ],
  );
}
