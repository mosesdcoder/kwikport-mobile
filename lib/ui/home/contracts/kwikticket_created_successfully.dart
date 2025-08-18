import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/contract_detail_heading_and_subtitle.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

class KwikticketCreatedSuccessfully extends StatefulWidget {
  final kwikticketID,
      exporterName,
      exportItem,
      contractType,
      stakedVolume,
      capitalCost,
      destination;
  const KwikticketCreatedSuccessfully({
    super.key,
    required this.kwikticketID,
    required this.exporterName,
    required this.exportItem,
    required this.contractType,
    required this.stakedVolume,
    required this.capitalCost,
    required this.destination,
  });

  @override
  State<KwikticketCreatedSuccessfully> createState() =>
      _KwikticketCreatedSuccessfullyState();
}

class _KwikticketCreatedSuccessfullyState
    extends State<KwikticketCreatedSuccessfully> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorCodes.whiteSmoke,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Image.asset(
                'assets/images/icons/ticket_generate_success.png',
                height: 96,
                width: 113,
              ),
              SizedBox(height: 40),
              Text(
                "Kwikticket generated successfully",
                style: kwikTextStlye(24.0, FontWeight.w600, colorCodes.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 21),
              Container(
                height: 395,
                width: 390,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.2,
                    color: colorCodes.antiFlashWhite,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  color: colorCodes.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    contractDetailHeadingAndSubtitle(
                      "Kwikticket ID",
                      "Exporter Name",
                      widget.kwikticketID,
                      widget.exporterName,
                      // "#Kwk-8989-09",
                      // "John  Gbenga",
                    ),
                    SizedBox(height: 20),
                    contractDetailHeadingAndSubtitle(
                      "Export Item",
                      "Contract type",
                      widget.exportItem,
                      widget.contractType,

                      // "Cocoa bean",
                      // "Agricultural Commodity",
                    ),
                    SizedBox(height: 20),
                    contractDetailHeadingAndSubtitle(
                      "Staked volume",
                      "Capital cost",
                      widget.stakedVolume,
                      widget.capitalCost,
                      // "20.5 tons",
                      // "₦246,000,000",
                      fontFamily: "",
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total contract value",
                          style: kwikTextStlye(
                            12.0,
                            FontWeight.w300,
                            colorCodes.graniteGrey,
                          ),
                        ),
                        Text(
                          "Projected Return",
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
                          "\$12,500",
                          style: kwikTextStlye(
                            14.0,
                            FontWeight.w600,
                            colorCodes.black,
                          ),
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/icons/Trending up.png",
                              height: 16,
                              width: 16,
                            ),
                            Text(
                              "15.5%",
                              style: kwikTextStlye(
                                14.0,
                                FontWeight.w600,
                                colorCodes.pigmentGreen,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Destination",
                          style: kwikTextStlye(
                            12.0,
                            FontWeight.w300,
                            colorCodes.graniteGrey,
                          ),
                        ),
                        Text(
                          "Status",
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
                          widget.destination,
                          style: kwikTextStlye(
                            14.0,
                            FontWeight.w600,
                            colorCodes.black,
                          ),
                        ),
                        Container(
                          height: 24,
                          width: 64,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.2,
                              color: HexColor("#FFAA33"),
                            ),
                            borderRadius: BorderRadius.circular(22),
                            color: HexColor("#FFAA33"),
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
                                "Awaiting",
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
                    SizedBox(height: 20),
                    contractDetailHeadingAndSubtitle(
                      "Duration ",
                      "Time",
                      "12 AUG 2025",
                      "12.00 AM",
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              kwikbutton("View Kwickticket", () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => ()),
                // );
              }),
              SizedBox(height: 10),
              kwikbutton(
                'Back to Home',
                () {
                  Navigator.pop(context);
                },
                textColor: colorCodes.textBlack,
                backgroundcolor: colorCodes.white,
                borderColor: colorCodes.antiFlashWhite,
                buttonChild: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Share",
                      style: kwikTextStlye(
                        16.0,
                        FontWeight.w500,
                        colorCodes.black,
                      ),
                    ),
                    Image.asset(
                      "assets/images/icons/direct-send.png",
                      height: 18,
                      width: 18,
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
}
