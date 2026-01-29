import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:kwik_port/api/model/agency_model.dart';
import 'package:kwik_port/api/utils/money_util.dart';

Widget procurementAgencyContainer(
  agencyLogo,
  agencyName,
  agencyRatings,
  serviceFee,
  serviceFeeConvert,
  deliveryDays,
  deliveryHours,
  reivews,
  AgencyModel? agency,
  viewDetailsFunc,
  selectFunc,
) {
  // Use AgencyModel properties if available, otherwise fallback to provided values
  // Prioritize per-ton fees if total fees are 0 or null
  final displayedServiceFee = (agency?.serviceFeePerTonInUSD != null && agency!.serviceFeePerTonInUSD! > 0)
      ? MoneyUtils.formatMoney(agency.serviceFeePerTonInUSD!, symbol: "\$", decimalDigits: 2)
      : (agency?.serviceFeeInUSD != null && agency!.serviceFeeInUSD! > 0)
          ? MoneyUtils.formatMoney(agency.serviceFeeInUSD!, symbol: "\$", decimalDigits: 2)
          : serviceFee;

  final displayedServiceFeeConvert = (agency?.serviceFeePerTon != null && agency!.serviceFeePerTon! > 0)
      ? MoneyUtils.formatMoney(agency.serviceFeePerTon!, symbol: "₦", decimalDigits: 2)
      : (agency?.serviceFee != null && agency!.serviceFee! > 0)
          ? MoneyUtils.formatMoney(agency.serviceFee!, symbol: "₦", decimalDigits: 2)
          : serviceFeeConvert;

  final displayedDeliveryDays = (agency?.numberOfDaysToDeliver != null)
      ? "${agency!.numberOfDaysToDeliver} days"
      : deliveryDays;

  final displayedDeliveryHours = (agency?.numberOfDaysToDeliver != null)
      ? "${agency!.numberOfDaysToDeliver! * 24} hours"
      : deliveryHours;

  final totalCostInUSD = (agency?.totalCostInUSD != null && agency!.totalCostInUSD! > 0)
      ? MoneyUtils.formatMoney(agency.totalCostInUSD!, symbol: "\$", decimalDigits: 0)
      : "00";
  
  // Use rating from AgencyModel if available
  final displayedRating = (agency?.rating != null)
      ? agency!.rating!
      : agencyRatings;
  
  // Use name from AgencyModel if available
  final displayedName = (agency?.name != null && agency!.name!.isNotEmpty)
      ? agency!.name!
      : agencyName;
  return Container(
    height: 250,
    width: 390,
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
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
                  displayedName,
                  style: kwikTextStlye(14.0, FontWeight.w600, colorCodes.black),
                ),
                Row(
                  children: [
                    Row(
                      children: List.generate(
                        5,
                        (index) => Image.asset(
                          index < displayedRating.floor()
                              ? 'assets/images/icons/dashboard/star_filled.png'
                              : 'assets/images/icons/dashboard/star_unfilled.png',
                          height: 14,
                          width: 15,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "($displayedRating)",
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
        Column(
          children: [
            infoRow("Service Fee Per ton", displayedServiceFee, displayedServiceFeeConvert),
            SizedBox(height: 5),
            infoRow("Delivery Time", displayedDeliveryDays, displayedDeliveryHours),
            SizedBox(height: 5),
            infoRow("Reviews", "${displayedRating} reviews", ""),
          ],
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 31,
              width: 140,
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
              width: 140,
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
