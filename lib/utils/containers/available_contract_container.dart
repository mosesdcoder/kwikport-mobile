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
  allocatedvolume,
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
      border: Border.all(width: 1.2, color: colorCodes.antiFlashWhite),
      borderRadius: BorderRadius.circular(6),
      color: colorCodes.white,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                Image.network(goodsImg, height: 72, width: 72),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Total volumes - $totalVolume",
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
            Container(
              height: 24,
              width: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.2,
                  color: colorCodes.mediumSeaGreen,
                ),
                borderRadius: BorderRadius.circular(22),
                color: colorCodes.aeroblue,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(contractStatusIcon, height: 16, width: 16),
                  Text(
                    contractStatus,
                    style: kwikTextStlye(
                      10.0,
                      FontWeight.w500,
                      colorCodes.mediumSeaGreen,
                    ),
                  ),
                ],
              ),
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
          value: allocatedvolume,
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
              "$percentageLeft",
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
                    colorCodes.pigmentGreen,
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
              "Profit ratio",
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

Widget avaiableontractContainerUpdated(
  goodsImg,
  goodsName,
  contractStatusIcon,
  contractStatus,
  goodsquality,
  countryFlag,
  country,
  contractValue,

  viewContractFunc,
) {
  return Container(
    height: 179,
    width: 342,
    // padding: EdgeInsets.only(horizontal: 16, vertical: 16),
    decoration: BoxDecoration(
      border: Border.all(width: 1.2, color: colorCodes.antiFlashWhite),
      borderRadius: BorderRadius.circular(16),
      color: colorCodes.white,
      boxShadow: [
        BoxShadow(
          color: const Color(0x1A000000), // #0000001A (black with opacity 0.1)
          offset: const Offset(0, 0), // x,y shadow position
          blurRadius: 20, // blur amount
          spreadRadius: 0, // spread
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: viewContractFunc,
          child: Image.network(goodsImg, height: 86, width: 342),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goodsName,
                        style: kwikTextStlye(
                          18.0,
                          FontWeight.w600,
                          colorCodes.black,
                        ),
                      ),

                      SizedBox(height: 4),
                      Text(
                        "$goodsquality",
                        style: kwikTextStlye(
                          12.0,
                          FontWeight.w300,
                          colorCodes.graniteGrey,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 24,
                    width: 64,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.2,
                        color: colorCodes.mediumSeaGreen,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      color: colorCodes.aeroblue,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(contractStatusIcon, height: 16, width: 16),
                        Text(
                          contractStatus,
                          style: kwikTextStlye(
                            10.0,
                            FontWeight.w500,
                            colorCodes.mediumSeaGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
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
                  Column(
                    children: [
                      Text(
                        contractValue,
                        style: kwikTextStlye(
                          12.0,
                          FontWeight.w600,
                          colorCodes.black,
                        ),
                      ),
                      Text(
                        "Total contract value",
                        style: kwikTextStlye(
                          10.0,
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
        ),
      ],
    ),
  );
}
