import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

Widget procurementAgencyContainer(
  agencyLogo,
  agencyName,
  agencyRatings,
  serviceFee,
  serviceFeeConvert,
  deliveryDays,
  deliveryHours,
  reivews,
  viewDetailsFunc,
  selectFunc,
) {
  return Container(
    height: 250,
    width: 390,
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: colorCodes.white,
    ),
    child: Column(
      children: [
        Row(
          children: [
            Image.asset(agencyLogo, height: 40, width: 40),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  agencyName,
                  style: kwikTextStlye(14.0, FontWeight.w600, colorCodes.black),
                ),
                Row(
                  children: [
                    Row(
                      children: List.generate(
                        5,
                        (index) => Image.asset(
                          index < agencyRatings.floor()
                              ? 'assets/images/icons/dashboard/star_filled.png'
                              : 'assets/images/icons/dashboard/star_unfilled.png',
                          height: 14,
                          width: 15,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "($agencyRatings)",
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
        Row(
          children: [
            SizedBox(height: 40, width: 40),
            SizedBox(width: 10),
            Column(
              children: [
                infoRow("Service Fee", serviceFee, serviceFeeConvert),
                SizedBox(height: 5),
                infoRow("Delivery Time", "4 days", "96hours"),
                SizedBox(height: 5),
                infoRow("Reviews", "120 reviews", ""),
              ],
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 31,
              width: 161,
              child: kwikbutton(
                "View Details",
                viewDetailsFunc,
                backgroundcolor: colorCodes.white,
                textColor: colorCodes.black,
                borderColor: colorCodes.antiFlashWhite,
                fontSize: 12.0,
              ),
            ),
            SizedBox(
              height: 31,
              width: 161,
              child: kwikbutton("Select", selectFunc, fontSize: 12.0),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget infoRow(descriptionTitle, detail1, detail2) {
  return SizedBox(
    width: 280,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(
              "assets/images/icons/dashboard/agency_detail_img.png",
              height: 20,
              width: 20,
            ),
            SizedBox(width: 5),
            Text(
              "$descriptionTitle:  ",
              style: kwikTextStlye(
                10.0,
                FontWeight.w300,
                colorCodes.graniteGrey,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              detail1,
              style: TextStyle(
                fontFamily: "",
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorCodes.black,
              ),
            ),
            Text(
              detail2,
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
  );
}
