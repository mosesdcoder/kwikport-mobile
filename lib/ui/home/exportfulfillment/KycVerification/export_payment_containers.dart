import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

Widget detailRow(
  title,
  description, {
  fontSize,
  fontWeight,
  color,
  fontsizetwo,
  fontWeighttwo,
  colortwo,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Image.asset(
            "assets/images/icons/dashboard/Frame 1000006018.png",
            height: 25,
            width: 25,
          ),
          SizedBox(width: 9),
          Text(
            title,
            style: kwikTextStlye(
              fontSize ?? 12.0,
              fontWeight ?? FontWeight.w300,
              color ?? colorCodes.graniteGrey,
            ),
          ),
        ],
      ),
      Text(
        description,
        style: TextStyle(
          fontFamily: "",
          fontSize: fontsizetwo ?? 12.0,
          fontWeight: fontWeighttwo ?? FontWeight.w600,
          color: colortwo ?? colorCodes.graniteGrey,
        ),
      ),
    ],
  );
}

Widget paymentContainer(
  method,
  subtitle,

  selected,
  paymentFunc, {
  subtitlefontweight,
  subtitlecolor,
}) {
  return InkWell(
    onTap: paymentFunc,
    child: Container(
      height: 71,
      width: 390,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color:
            selected == true
                ? HexColor("#EFF6FF").withOpacity(0.5)
                : colorCodes.white,
        border: Border.all(
          color:
              selected == true
                  ? colorCodes.azureBlue
                  : colorCodes.antiFlashWhite,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                selected == true
                    ? "assets/images/icons/dashboard/payment_wallet_selected.png"
                    : "assets/images/icons/dashboard/payment_wallet_unselected.png",
                height: 34,
                width: 34,
              ),
              SizedBox(width: 9),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method,
                    style: kwikTextStlye(
                      14.0,
                      FontWeight.w600,
                      colorCodes.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: kwikTextStlye(
                      12.0,
                      subtitlefontweight ?? FontWeight.w500,
                      subtitlecolor ?? colorCodes.graniteGrey,
                      fontFamily: "",
                    ),
                  ),
                ],
              ),
            ],
          ),
          Image.asset(
            selected == true
                ? "assets/images/icons/Radio Button_selected.png"
                : "assets/images/icons/Radio Button_unselected.png",
            height: 20,
            width: 20,
          ),
        ],
      ),
    ),
  );
}

Widget bankDetailColumn(title, detail, func, {suffix}) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: kwikTextStlye(
                  12.0,
                  FontWeight.w300,
                  colorCodes.graniteGrey,
                ),
              ),
              SizedBox(height: 5),
              Text(
                detail,
                style: kwikTextStlye(
                  fontFamily: "",
                  12.0,
                  FontWeight.w600,
                  colorCodes.graniteGrey,
                ),
              ),
            ],
          ),
          suffix ??
              InkWell(
                onTap: func,
                child: Image.asset(
                  "assets/images/icons/copy_black.png",
                  height: 15,
                  width: 15,
                ),
              ),
        ],
      ),
      SizedBox(height: 8),
      SizedBox(
        width: 323,
        child: Divider(color: HexColor("#E0E0E0"), thickness: 1.2),
      ),
    ],
  );
}
