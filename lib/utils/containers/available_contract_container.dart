import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/button/elavated_button.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

Widget avaiableontractContainer(
  goodsImg,
  goodsName,
  contractStatusIcon,
  contractStatus,
  totalVolume,
  countryFlag,
  country,
  tonsRemaining,
  tonsAllocated,
  percentageLeft,
  contractValue,
  projectedReturnImg,
  projectedReturn,
  viewContractFunc,
) {
  return Container(
    height: 296,
    width: 390,
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    decoration: BoxDecoration(
      border: Border.all(width: 1.2, color: HexColor("#EFEFEF")),
      borderRadius: BorderRadius.circular(6),
      color: colorCodes.white,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(goodsImg, height: 72, width: 72),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      goodsName,
                      style: kwikTextStlye(
                        16.0,
                        FontWeight.w600,
                        colorCodes.black,
                      ),
                    ),

                    Container(
                      height: 24,
                      width: 64,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.2,
                          color: HexColor("#4FBB75"),
                        ),
                        borderRadius: BorderRadius.circular(22),
                        color: HexColor("#D5EFDE"),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            contractStatusIcon,
                            height: 16,
                            width: 16,
                          ),
                          Text(
                            contractStatus,
                            style: kwikTextStlye(
                              10.0,
                              FontWeight.w500,
                              HexColor("#4FBB75"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  "Total volume - $totalVolume",
                  style: kwikTextStlye(
                    12.0,
                    FontWeight.w400,
                    colorCodes.graniteGrey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Image.asset(countryFlag, height: 16, width: 16),
                    Text(
                      country,
                      style: kwikTextStlye(
                        12.0,
                        FontWeight.w300,
                        colorCodes.graniteGrey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 15),
        Text(
          "Allocated",
          style: kwikTextStlye(12.0, FontWeight.w600, colorCodes.jetBlack),
        ),
        SizedBox(height: 4),
        LinearProgressIndicator(
          backgroundColor: HexColor("#D6E7FF"),
          minHeight: 8,
          value: 0.21,
          borderRadius: BorderRadius.circular(12),
          color: colorCodes.azureBlue,
        ),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10.0,
                  fontWeight: FontWeight.w500,
                  color: colorCodes.graniteGrey,
                ),

                children: [
                  TextSpan(text: tonsRemaining),
                  TextSpan(text: " / "),
                  TextSpan(text: tonsAllocated),
                ],
              ),
            ),
            Text(
              "$percentageLeft left",
              style: kwikTextStlye(
                12.0,
                FontWeight.w500,
                colorCodes.graniteGrey,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        SizedBox(
          width: 358,
          child: Divider(thickness: 1.2, color: HexColor("#E7E7E7")),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              contractValue,
              style: kwikTextStlye(12.0, FontWeight.w600, colorCodes.black),
            ),
            Row(
              children: [
                Image.asset(projectedReturnImg, height: 16, width: 16),
                Text(
                  projectedReturn,
                  style: kwikTextStlye(
                    12.0,
                    FontWeight.w600,
                    HexColor("#2CAD59"),
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total contract value",
              style: kwikTextStlye(
                10.0,
                FontWeight.w300,
                colorCodes.graniteGrey,
              ),
            ),
            Text(
              "Projected Return",
              style: kwikTextStlye(
                10.0,
                FontWeight.w300,
                colorCodes.graniteGrey,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        SizedBox(
          height: 31,
          width: 358,
          child: elevatedbutton(
            "View contract",
            viewContractFunc,
            backgroundcolor: HexColor("#166CEC"),
            borderRadius: 22.0,
          ),
        ),
      ],
    ),
  );
}
