import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

Widget contractDetailHeadingAndSubtitle(
  String leftTitle,
  String rightTitle,
  String leftSubtitle,
  String rightSubtitle, {
  fontFamily,
}) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leftTitle,
            style: kwikTextStlye(12.0, FontWeight.w300, colorCodes.graniteGrey),
          ),
          Text(
            rightTitle,
            style: kwikTextStlye(12.0, FontWeight.w300, colorCodes.graniteGrey),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              leftSubtitle,
              style: kwikTextStlye(14.0, FontWeight.w500, colorCodes.black),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            height: 23,
            // width: 130,
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: colorCodes.whiteSmoke,
              border: Border.all(color: colorCodes.antiFlashWhite),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Text(
              rightSubtitle,
              textAlign: TextAlign.end,
              style: kwikTextStlye(
                10.0,
                FontWeight.w500,
                colorCodes.black,
                fontFamily: fontFamily,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ],
  );
}

Widget contractDetailHeadingAndSubtitletwo(
  leftTitle,
  rightTitle,
  leftSubtitle,
  rightSubtitle, {
  fontFamily,
}) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leftTitle,
            style: kwikTextStlye(14.0, FontWeight.w300, colorCodes.black),
          ),
          Text(
            rightTitle,
            style: kwikTextStlye(14.0, FontWeight.w300, colorCodes.black),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              leftSubtitle,
              style: kwikTextStlye(12.0, FontWeight.w500, colorCodes.black),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            // height: 23,
            width: 130,
            // padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            // decoration: BoxDecoration(
            //   color: colorCodes.whiteSmoke,
            //   border: Border.all(color: colorCodes.antiFlashWhite),
            //   borderRadius: BorderRadius.circular(22),
            // ),
            child: Text(
              rightSubtitle,
              textAlign: TextAlign.end,
              style: kwikTextStlye(
                10.0,
                FontWeight.w500,
                colorCodes.black,
                fontFamily: fontFamily,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ],
  );
}
