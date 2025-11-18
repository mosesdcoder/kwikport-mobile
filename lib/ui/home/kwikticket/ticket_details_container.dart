import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

Widget ticketDetailContainer(
  kwikticketId,
  exporterName,
  exportItem,
  contractType,
  selectedCapacity,
  destination,

  commodityCostPrice,

  pricePerTon,
  projectedIncome,
  timeadded,
  kwiticketStatus,
  context,
) {
  return Container(
    width: 390,
    height: 410,
    padding: EdgeInsets.all(18.0),
    decoration: BoxDecoration(
      color: colorCodes.white,
      border: Border.all(color: colorCodes.antiFlashWhite, width: 1.0),
      borderRadius: BorderRadius.circular(16.0),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  "assets/images/icons/dashboard/Frame 1000006029 (3).png",
                  height: 20,
                  width: 20,
                ),
                SizedBox(width: 5),
                Text(
                  "Kwikticket ID",
                  style: kwikTextStlye(
                    12.0,
                    FontWeight.w300,
                    colorCodes.graniteGrey,
                  ),
                ),
              ],
            ),
            Text(
              "Exporter ",
              style: kwikTextStlye(
                12.0,
                FontWeight.w300,
                colorCodes.graniteGrey,
              ),
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              kwikticketId,
              style: kwikTextStlye(14.0, FontWeight.w600, colorCodes.black),
            ),

            Text(
              exporterName,
              style: kwikTextStlye(14.0, FontWeight.w600, colorCodes.black),
            ),
          ],
        ),

        SizedBox(height: 21.0),
        dataDetail("Export Item", "Contract Type", exportItem, contractType),
        SizedBox(height: 21.0),
        dataDetail(
          "Selected Capacity",
          "Destination",
          selectedCapacity,
          destination,
        ),
        SizedBox(height: 20.0),
        Container(
          height: 115,
          width: 352,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: colorCodes.whiteSmoke,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Commodity Cost",
                    style: kwikTextStlye(
                      12.0,
                      FontWeight.w300,
                      colorCodes.graniteGrey,
                    ),
                  ),
                  Text(
                    commodityCostPrice,
                    style: kwikTextStlye(
                      14.0,
                      FontWeight.w600,
                      colorCodes.textBlack,
                      fontFamily: "",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Buyer Price/Ton",
                    style: kwikTextStlye(
                      12.0,
                      FontWeight.w300,
                      colorCodes.graniteGrey,
                    ),
                  ),
                  Text(
                    pricePerTon,
                    style: kwikTextStlye(
                      14.0,
                      FontWeight.w600,
                      colorCodes.textBlack,
                      fontFamily: "",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6),
              SizedBox(
                width: 310,
                child: Divider(thickness: 1.0, color: colorCodes.aluminium),
              ),
              SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Gross Earning",
                    style: kwikTextStlye(
                      12.0,
                      FontWeight.w300,
                      colorCodes.graniteGrey,
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/icons/Trending up.png",
                        height: 16,
                        width: 16,
                      ),
                      SizedBox(width: 5),
                      Text(
                        projectedIncome,
                        style: kwikTextStlye(
                          14.0,
                          FontWeight.w500,
                          colorCodes.pigmentGreen,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          width: 342,
          child: Divider(thickness: 1.0, color: colorCodes.aluminium),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  "assets/images/icons/calendar.png",
                  height: 15,
                  width: 15,
                ),
                SizedBox(width: 5),
                Text(
                  timeadded,
                  style: kwikTextStlye(
                    12.0,
                    FontWeight.w500,
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
                  color:
                      kwiticketStatus == 1
                          ? colorCodes.bluetiful
                          : kwiticketStatus == 2
                          ? HexColor("#FFAA33")
                          : kwiticketStatus == 5
                          ? colorCodes.pigmentGreen
                          : HexColor("#FFAA33"),
                ),
                borderRadius: BorderRadius.circular(22),
                color:
                    kwiticketStatus == 1
                        ? colorCodes.bluetiful
                        : kwiticketStatus == 2
                        ? HexColor("#FFAA33")
                        : kwiticketStatus == 5
                        ? colorCodes.pigmentGreen
                        : HexColor("#FFAA33"),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image.asset(
                  //   "assets/images/icons/tick-circle.png",
                  //   height: 16,
                  //   width: 16,
                  // ),
                  Text(
                    kwiticketStatus == 1
                        ? "Active"
                        : kwiticketStatus == 2
                        ? "Awaiting"
                        : kwiticketStatus == 5
                        ? "Fulfilled"
                        : "Cancelled",
                    style: kwikTextStlye(
                      10.0,
                      FontWeight.w500,
                      colorCodes.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget exporttDetailContainer(
  contractID,
  // exporterName,
  exportItem,
  contractType,
  selectedCapacity,
  destination,

  commodityCostPrice,

  buyer,
  projectedIncome,
  completionDate,
  kwiticketStatus,
  viewexportFunc,
  context,
) {
  return Container(
    width: 390,
    height: 410,
    padding: EdgeInsets.all(18.0),
    decoration: BoxDecoration(
      color: colorCodes.white,
      border: Border.all(color: colorCodes.antiFlashWhite, width: 1.0),
      borderRadius: BorderRadius.circular(16.0),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  "assets/images/icons/dashboard/Frame 1000006029 (3).png",
                  height: 20,
                  width: 20,
                ),
                SizedBox(width: 5),
                Text(
                  "Contract ID",
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
                  color:
                      kwiticketStatus == true
                          ? colorCodes.bluetiful
                          : colorCodes.pigmentGreen,
                ),
                borderRadius: BorderRadius.circular(22),
                color:
                    kwiticketStatus == true
                        ? colorCodes.bluetiful
                        : colorCodes.pigmentGreen,
              ),
              child: Text(
                kwiticketStatus == true ? "Active" : "Completed",
                style: kwikTextStlye(10.0, FontWeight.w500, colorCodes.white),
              ),
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              contractID,
              style: kwikTextStlye(14.0, FontWeight.w600, colorCodes.black),
            ),
          ],
        ),

        SizedBox(height: 21.0),
        dataDetail("Export Item", "Contract Type", exportItem, contractType),
        SizedBox(height: 21.0),
        dataDetail(
          "Selected Capacity",
          "Destination",
          selectedCapacity,
          destination,
        ),
        SizedBox(height: 20.0),
        Container(
          height: 105,
          width: 352,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: colorCodes.whiteSmoke,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       "Commodity Cost",
              //       style: kwikTextStlye(
              //         12.0,
              //         FontWeight.w300,
              //         colorCodes.graniteGrey,
              //       ),
              //     ),
              //     Text(
              //       commodityCostPrice,
              //       style: kwikTextStlye(
              //         14.0,
              //         FontWeight.w600,
              //         colorCodes.textBlack,
              //         fontFamily: "",
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Buyer",
                    style: kwikTextStlye(
                      12.0,
                      FontWeight.w300,
                      colorCodes.graniteGrey,
                    ),
                  ),
                  Text(
                    buyer,
                    style: kwikTextStlye(
                      14.0,
                      FontWeight.w600,
                      colorCodes.textBlack,
                      fontFamily: "",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6),
              SizedBox(
                width: 310,
                child: Divider(thickness: 1.0, color: colorCodes.aluminium),
              ),
              SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Contract Value",
                    style: kwikTextStlye(
                      12.0,
                      FontWeight.w300,
                      colorCodes.graniteGrey,
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/icons/Trending up.png",
                        height: 16,
                        width: 16,
                      ),
                      SizedBox(width: 5),
                      Text(
                        projectedIncome,
                        style: kwikTextStlye(
                          14.0,
                          FontWeight.w500,
                          colorCodes.pigmentGreen,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          width: 342,
          child: Divider(thickness: 1.0, color: colorCodes.aluminium),
        ),
        // _overallProgress()
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  "assets/images/icons/calendar.png",
                  height: 15,
                  width: 15,
                ),
                SizedBox(width: 5),
                Text(
                  "Est. completion: $completionDate",
                  style: kwikTextStlye(
                    12.0,
                    FontWeight.w500,
                    colorCodes.graniteGrey,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
              width: 80,
              child: kwikbutton("View Export", viewexportFunc, fontSize: 10.0),
            ),
            // Container(
            //   height: 24,
            //   width: 64,
            //   alignment: Alignment.center,
            //   decoration: BoxDecoration(
            //     border: Border.all(
            //       width: 1.2,
            //       color:
            //           kwiticketStatus == 1
            //               ? colorCodes.bluetiful
            //               : kwiticketStatus == 2
            //               ? HexColor("#FFAA33")
            //               : kwiticketStatus == 5
            //               ? colorCodes.pigmentGreen
            //               : HexColor("#FFAA33"),
            //     ),
            //     borderRadius: BorderRadius.circular(22),
            //     color:
            //         kwiticketStatus == 1
            //             ? colorCodes.bluetiful
            //             : kwiticketStatus == 2
            //             ? HexColor("#FFAA33")
            //             : kwiticketStatus == 5
            //             ? colorCodes.pigmentGreen
            //             : HexColor("#FFAA33"),
            //   ),
            //   child: Text(
            //     kwiticketStatus == 1
            //         ? "Active"
            //         : kwiticketStatus == 2
            //         ? "Awaiting"
            //         : kwiticketStatus == 5
            //         ? "Fulfilled"
            //         : "Cancelled",
            //     style: kwikTextStlye(10.0, FontWeight.w500, colorCodes.white),
            //   ),
            // ),
          ],
        ),
      ],
    ),
  );
}

dataDetail(title1, title2, detail1, detail2) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title1,
            style: kwikTextStlye(12.0, FontWeight.w300, colorCodes.graniteGrey),
          ),
          Text(
            title2,
            style: kwikTextStlye(12.0, FontWeight.w300, colorCodes.graniteGrey),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            detail1,
            style: kwikTextStlye(14.0, FontWeight.w600, colorCodes.black),
          ),

          Text(
            detail2,
            style: kwikTextStlye(14.0, FontWeight.w600, colorCodes.black),
          ),
        ],
      ),
    ],
  );
}
