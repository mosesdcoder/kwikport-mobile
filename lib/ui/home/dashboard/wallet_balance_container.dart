import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

Widget walletBalanceContainer(visibilityFunc) {
  return Container(
    height: 160,
    width: 190,
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: colorCodes.azureBlue,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              "assets/images/icons/wallet_Icon.png",
              height: 40,
              width: 40,
            ),
            InkWell(
              onTap: visibilityFunc,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  'assets/images/icons/eye.png',
                  color: colorCodes.white,
                  width: 19,
                  height: 19,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Text(
          "Gross Earning",
          style: kwikTextStlye(14.0, FontWeight.w300, colorCodes.whiteSmoke),
        ),
        Text(
          "\$24,580.00",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: colorCodes.whiteSmoke,
          ),
        ),
        SizedBox(height: 12),
        Text(
          "View Wallet",
          style: kwikTextStlye(12.0, FontWeight.w300, HexColor("#D6E7FF")),
        ),
      ],
    ),
  );
}

Widget activityProgressContainer(img, title, progress) {
  return Container(
    height: 77,
    width: 185,
    padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 12.0),
    decoration: BoxDecoration(
      border: Border.all(width: 1.2, color: HexColor("#EFEFEF")),
      borderRadius: BorderRadius.circular(8),
      color: colorCodes.white,
    ),
    child: Row(
      children: [
        Image.asset(img, height: 40, width: 40),
        SizedBox(width: 7),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title,
              style: kwikTextStlye(
                12.0,
                FontWeight.w300,
                colorCodes.graniteGrey,
              ),
            ),
            SizedBox(height: 3),
            Text(
              progress,
              style: kwikTextStlye(20.0, FontWeight.w600, colorCodes.black),
            ),
          ],
        ),
      ],
    ),
  );
}
