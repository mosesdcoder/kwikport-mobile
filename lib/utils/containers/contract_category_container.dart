import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

Widget contractCategoryContainer(categoryIcon, category, count) {
  return Container(
    height: 40,
    // width: 138,
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100),
      color: colorCodes.white,
      border: Border.all(width: 1.2, color: colorCodes.azureBlue),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(categoryIcon, height: 22, width: 14),
        SizedBox(width: 3),
        Text(
          category,
          style: kwikTextStlye(12.0, FontWeight.w300, colorCodes.black),
        ),
        SizedBox(width: 6),
        Container(
          height: 22,
          width: 22,
          // padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colorCodes.antiFlashWhite,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            count,
            style: kwikTextStlye(12.0, FontWeight.w500, colorCodes.jetBlack),
          ),
        ),
      ],
    ),
  );
}
