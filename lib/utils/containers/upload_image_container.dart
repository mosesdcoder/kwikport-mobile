import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

Widget uploadImageContainer(title, func) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: kwikTextStlye(12.0, FontWeight.w500, colorCodes.black),
      ),
      SizedBox(height: 3),
      DottedBorder(
        options: RoundedRectDottedBorderOptions(
    radius: const Radius.circular(10),
    color: colorCodes.aluminium,
    dashPattern: const [5, 5], // [dash length, space length]
    strokeWidth: 2,
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 190,
          width: 350,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(
            left: 20,
            top: 20,
            bottom: 20,
            right: 20,
          ),
          // alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: colorCodes.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/icons/dashboard/Frame 1000006095.png",
                height: 35,
                width: 35,
              ),
              SizedBox(height: 10),
              Text(
                "Take or Upload Selfie",
                style: kwikTextStlye(14.0, FontWeight.w500, colorCodes.black),
              ),
              Text(
                "PNG, JPG up to 5MB",
                style: kwikTextStlye(
                  12.0,
                  FontWeight.w300,
                  colorCodes.graniteGrey,
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 38,
                width: 140,
                child: kwikbutton(
                  "Take Photo",
                  func,
                  backgroundcolor: colorCodes.white,
                  textColor: colorCodes.black,
                  borderColor: colorCodes.antiFlashWhite,
                  fontSize: 12.0,
                  buttonChild: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/icons/dashboard/tick-circle-black.png",
                        height: 18,
                        width: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Take Photo",
                        style: kwikTextStlye(
                          12.0,
                          FontWeight.w500,
                          colorCodes.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
  ),
      ),
    ],
  );
}
