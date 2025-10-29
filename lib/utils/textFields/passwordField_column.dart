import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';

bool visibilty = false;

Column passwordtextFieldColumn(
  errorText,
  textController,
  // hintText,
  _isvisible,
  onPressedVisibility,
  context, {
  title,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title ?? 'Password',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: colorCodes.black,
        ),
      ),
      const SizedBox(height: 8),
      TextField(
        controller: textController,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: colorCodes.black,
        ),
        //autofocus: true,
        keyboardType: TextInputType.visiblePassword,
        obscureText: !_isvisible,
        decoration: InputDecoration(
          fillColor: colorCodes.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color:
                  (errorText != '')
                      ? colorCodes.portlandOrange
                      : colorCodes.azureBlue,
            ),
          ),
          hintText: '********',
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            color: colorCodes.black,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          suffixIcon: InkWell(
            highlightColor: Color(0xFF),
            onTap: onPressedVisibility,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child:
                  _isvisible == false
                      ? Image.asset(
                        'assets/images/icons/eye-slash.png',
                        width: 24,
                        height: 24,
                        color: colorCodes.graniteGrey,
                      )
                      : Image.asset(
                        'assets/images/icons/eye.png',
                        color: colorCodes.graniteGrey,
                        width: 24,
                        height: 24,
                      ),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14.0,
            vertical: 8,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
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
          ),
        ),
      ),
    ],
  );
}
