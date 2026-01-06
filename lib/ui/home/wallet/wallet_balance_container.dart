import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

Widget walletBalanceContainer(
  balance,
  walletTitle,
  backgroundColor,
  color1,
  color2,
  starimg,
  lastUpdated,
  walletId,
  isVisible,
  visibilityFunc,
) {
  return Container(
    height: 203,
    width: 377,
    padding: EdgeInsets.only(left: 16.0, top: 20.0, bottom: 20.0),
    decoration: BoxDecoration(
      // color: backgroundColor,
      borderRadius: BorderRadius.circular(10),

      // background: linear-gradient(107.35deg,  );
      gradient: LinearGradient(
        colors: [color1, color2],
        stops: [0.19, 0.50],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              walletTitle,
              style: kwikTextStlye(
                16.0,
                FontWeight.w400,
                colorCodes.whiteSmoke,
              ),
            ),
            SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  balance,

                  style: kwikTextStlye(
                    24.0,
                    FontWeight.w600,
                    colorCodes.white,
                    fontFamily: "",
                  ),
                ),
                SizedBox(width: 4),
                InkWell(
                  onTap: visibilityFunc,
                  child: Container(
                    height: 27,
                    width: 27,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: color2,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Image.asset(
                      isVisible == true
                          ? 'assets/images/icons/eye.png'
                          : "assets/images/icons/eye-slash.png",
                      height: 18,
                      width: 18,
                      color: colorCodes.white,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 6),
            Text(
              "Last Updated : $lastUpdated",
              style: kwikTextStlye(12.0, FontWeight.w300, HexColor("#A4A4A4")),
            ),
            SizedBox(height: 20),
            Text(
              walletId,
              style: kwikTextStlye(12.0, FontWeight.w300, colorCodes.white),
            ),
          ],
        ),
        Positioned(
          top: -15,
          right: 0,
          child: Image.asset(starimg, height: 216, width: 216),
        ),
        Positioned(
          top: 80,
          right: 42,
          child: Image.asset(
            "assets/images/icons/dashboard/Frame 19.png",
            height: 63,
            width: 61,
          ),
        ),
        Positioned(
          top: 96,
          right: 55,
          child: Image.asset(
            "assets/images/icons/dashboard/Power-button.png",
            height: 71,
            width: 73,
          ),
        ),
      ],
    ),
  );
}
