import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

Widget dashboardBalanceContainer(
  walletBalance,
  showBalance,
  visibilityFunc,
  context,
) {
  double width = MediaQuery.of(context).size.width / 2;
  return Container(
    height: 160,
    width: width - 20, // 170,
    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
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
                  showBalance == true
                      ? 'assets/images/icons/eye.png'
                      : "assets/images/icons/eye-slash.png",
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
          "Wallet Balance",
          style: kwikTextStlye(14.0, FontWeight.w300, colorCodes.whiteSmoke),
        ),
        Text(
          "$walletBalance",
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

Widget activityProgressContainer(img, title, progress, context, func) {
  double width = MediaQuery.of(context).size.width / 2;
  return InkWell(
    onTap: func,
    child: Container(
      height: 77,
      width: width - 20, //165,
      padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 12.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1.2, color: colorCodes.antiFlashWhite),
        borderRadius: BorderRadius.circular(8),
        color: colorCodes.white,
      ),
      child: Row(
        children: [
          Image.asset(img, height: 30, width: 30),
          SizedBox(width: 7),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: kwikTextStlye(
                  10.0,
                  FontWeight.w300,
                  colorCodes.graniteGrey,
                ),
              ),
              SizedBox(height: 3),
              Text(
                progress,
                style: kwikTextStlye(15.0, FontWeight.w600, colorCodes.black),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget quickActionsContainer(actionImg, title, func, {width}) {
  return InkWell(
    onTap: func,
    child: Container(
      height: 94,
      width: width ?? 150,

      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: BoxDecoration(
        color: colorCodes.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(actionImg, height: 44, width: 44),
          SizedBox(height: 5),
          Text(
            title,
            style: kwikTextStlye(10.0, FontWeight.w500, colorCodes.black),
          ),
        ],
      ),
    ),
  );
}
