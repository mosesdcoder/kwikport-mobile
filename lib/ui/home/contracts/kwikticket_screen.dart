import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/main.dart';
import 'package:kwik_port/ui/home/exportfulfillment/export_fulfillment_screen.dart';
import 'package:kwik_port/utils/button/backNav_button.dart';
import 'package:kwik_port/utils/button/bottom_navigatior_bar.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/contract_detail_heading_and_subtitle.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

class KwikticketScreen extends StatefulWidget {
  final kwikticketID,
      exporterName,
      exportItem,
      contractType,
      stakedVolume,
      capitalCost,
      destination;
  const KwikticketScreen({
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
  State<KwikticketScreen> createState() => _KwikticketScreenState();
}

class _KwikticketScreenState extends State<KwikticketScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: colorCodes.whiteSmoke,
      body: ListView(
        padding: EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 55),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: backnavButton(context),
              ),
              SizedBox(height: 15),
              Image.asset(
                'assets/images/icons/ticket_generate_success.png',
                height: 96,
                width: 113,
              ),
              SizedBox(height: 40),
              Text(
                "Kwikticket ",
                style: kwikTextStlye(24.0, FontWeight.w600, colorCodes.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 21),
              Container(
                height: 45,
                width: 300,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: colorCodes.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    width: 1.5,
                    color: colorCodes.paleCornflowerBlue,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/icons/dashboard/kwikticket_blue.png",
                      height: 25,
                      width: 25,
                    ),
                    SizedBox(width: 6),
                    SizedBox(
                      width: 242,
                      child: Text(
                        "This is your personalised contract offer.",
                        style: kwikTextStlye(
                          12.0,
                          FontWeight.w300,
                          colorCodes.jetBlack,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 436,
                width: 390,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 29),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/images/ticketdetail_bckground.png",
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    contractDetailHeadingAndSubtitletwo(
                      "Kwikticket ID",
                      "Exporter Name",
                      widget.kwikticketID,
                      widget.exporterName,
                      // "#Kwk-8989-09",
                      // "John  Gbenga",
                    ),
                    SizedBox(height: 20),
                    contractDetailHeadingAndSubtitletwo(
                      "Export Item",
                      "Contract type",
                      widget.exportItem,
                      widget.contractType,

                      // "Cocoa bean",
                      // "Agricultural Commodity",
                    ),
                    SizedBox(height: 20),
                    contractDetailHeadingAndSubtitletwo(
                      "Selected Capacity",
                      "Commodity Cost",
                      widget.stakedVolume,
                      widget.capitalCost,
                      // "20.5 tons",
                      // "₦246,000,000",
                      fontFamily: "",
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Buyer Price Per Ton",
                          style: kwikTextStlye(
                            12.0,
                            FontWeight.w300,
                            colorCodes.graniteGrey,
                          ),
                        ),
                        Text(
                          "Export Gross Earning",
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
                                "Non-active",
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
                    SizedBox(height: 31),
                    Container(
                      height: 58,
                      width: 331,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: colorCodes.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          width: 1.5,
                          color: colorCodes.paleCornflowerBlue,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/icons/dashboard/kwikticket_blue.png",
                            height: 25,
                            width: 25,
                          ),
                          SizedBox(width: 6),
                          SizedBox(
                            width: 242,
                            child: Text(
                              "This ticket represents your secured allocation in this export contract.",
                              style: kwikTextStlye(
                                12.0,
                                FontWeight.w300,
                                colorCodes.jetBlack,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              kwikbutton("Fulfill Ticket", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExportFulfillmentScreen(),
                  ),
                );
                currentIndex = 3;
              }),
              SizedBox(height: 40),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Bottomnavigationbar(3),
    );
  }
}
