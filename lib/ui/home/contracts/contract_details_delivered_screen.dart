import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/main.dart';
import 'package:kwik_port/utils/button/bottom_navigatior_bar.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

class ContractDetailsDeliveredScreen extends StatefulWidget {
  const ContractDetailsDeliveredScreen({super.key});

  @override
  State<ContractDetailsDeliveredScreen> createState() =>
      _ContractDetailsDeliveredScreenState();
}

class _ContractDetailsDeliveredScreenState
    extends State<ContractDetailsDeliveredScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: colorCodes.whiteSmoke,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85.0),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            top: 42.0,
            bottom: 15,
            right: 20.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      currentIndex = 2;
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      'assets/images/icons/button back.png',
                      height: 48,
                      width: 48,
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    children: [
                      FittedBox(
                        child: Text(
                          "Contract details",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: colorCodes.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 2),
                      FittedBox(
                        child: Text(
                          "ID: KWP-2024-001",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: colorCodes.aluminium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Image.asset(
                    "assets/images/icons/dashboard/star_review.png",
                    height: 39,
                    width: 39,
                  ),
                  SizedBox(width: 10),
                  Image.asset(
                    "assets/images/icons/dashboard/telegram_chat.png",
                    height: 39,
                    width: 39,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 55),
        children: [
          Container(
            // height: 2849,
            width: 390,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: colorCodes.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Image.asset(
                      "assets/images/cocoa_square.png",
                      height: 238,
                      width: 342,
                    ),
                    Positioned(
                      top: 23,
                      right: 17,
                      // bottom: 0,
                      // left: 0,
                      child: Image.asset(
                        "assets/images/icons/active_status.png",
                        height: 23,
                        width: 48,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 19),
                Text(
                  "Cocoa Beans",
                  style: kwikTextStlye(24.0, FontWeight.w600, colorCodes.black),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      height: 24,
                      width: 120,
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
                          Image.asset(
                            "assets/images/icons/tick-circle.png",
                            height: 10,
                            width: 10,
                          ),
                          Text(
                            "Grade A Premium",
                            style: kwikTextStlye(
                              10.0,
                              FontWeight.w500,
                              colorCodes.mediumSeaGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
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
                        "Fair Trade",
                        style: kwikTextStlye(
                          10.0,
                          FontWeight.w500,
                          colorCodes.black,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
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
                        "Organic",
                        style: kwikTextStlye(
                          10.0,
                          FontWeight.w500,
                          colorCodes.black,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "Ivory Coast ",
                      style: kwikTextStlye(
                        10.0,
                        FontWeight.w300,
                        colorCodes.graniteGrey,
                      ),
                    ),
                    SizedBox(width: 8),
                    Image.asset(
                      "assets/images/icons/dashboard/arrow-left.png",
                      height: 10,
                      width: 10,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Netherlands",
                      style: kwikTextStlye(
                        10.0,
                        FontWeight.w300,
                        colorCodes.graniteGrey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 44),
                Text(
                  "CONTRACT OVERVIEW",
                  style: kwikTextStlye(20.0, FontWeight.w600, colorCodes.black),
                ),
                overviewRichText(
                  "Commodity",
                  "Cocoa (Premium Grade, fermented & dried)",
                ),
                SizedBox(height: 4),
                overviewRichText(
                  "Contract Type",
                  "International Buyer Agreement — verified & binding",
                ),
                SizedBox(height: 4),
                overviewRichText("Total Volume Requested", "50 tons"),
                SizedBox(height: 4),
                overviewRichText("Price per Ton (₦)", "₦2,500,000"),
                SizedBox(height: 4),
                overviewRichText("Projected Earnings per Ton (USD)", "\$3,200"),
                SizedBox(height: 4),
                overviewRichText(
                  "Contract Duration",
                  "60 days from activation",
                ),
                SizedBox(height: 4),
                overviewRichText("Buyer", "Global Cocoa Imports Ltd."),
                SizedBox(height: 4),
                overviewRichText(
                  "Quick Snapshot",
                  "50 tons | ₦2,500,000/ton | \$3,200 projected earnings",
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Bottomnavigationbar(2),
    );
  }

  Widget overviewRichText(title, description) {
    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        style: TextStyle(
          fontFamily: "",
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: colorCodes.black,
        ),
        children: [
          TextSpan(text: "$title: "),
          TextSpan(
            text: description,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: colorCodes.graniteGrey,
            ),
          ),
        ],
      ),
    );
  }
}
