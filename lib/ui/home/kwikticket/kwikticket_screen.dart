import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/api/model/dashboard_model.dart';
import 'package:kwik_port/api/utils/money_util.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/main.dart';
import 'package:kwik_port/ui/home/exportfulfillment/export_fulfillment_screen.dart';
import 'package:kwik_port/utils/button/backNav_button.dart';
import 'package:kwik_port/utils/button/bottom_navigatior_bar.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/contract_detail_heading_and_subtitle.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

class KwikticketScreen extends StatefulWidget {
  final KwikTicketModel kwikticket;

  // final kwikticketID,
  //     exporterName,
  //     exportItem,
  //     contractType,
  //     stakedVolume,
  //     capitalCost,
  //     destination;
  const KwikticketScreen({super.key, required this.kwikticket});

  @override
  State<KwikticketScreen> createState() => _KwikticketScreenState();
}

class _KwikticketScreenState extends State<KwikticketScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorCodes.whiteSmoke,
      body: ListView(
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 50),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    currentIndex = 0;
                  },
                  child: backnavButton(context),
                ),
              ),
              SizedBox(height: 15),
              Image.asset(
                'assets/images/icons/ticket_generate_success.png',
                height: 96,
                width: 113,
              ),
              SizedBox(height: 30),
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
                          13.0,
                          FontWeight.w500,
                          colorCodes.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 492,
                width: 390,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      "assets/images/ticketdetail_bckground.png",
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    SizedBox(height: 15),
                    contractDetailHeadingAndSubtitletwo(
                      "Kwikticket ID",
                      "Exporter Name",
                      widget.kwikticket.uniqueId,
                      widget.kwikticket.exporter?.businessName,
                      // "#Kwk-8989-09",
                      // "John  Gbenga",
                    ),
                    SizedBox(height: 12),
                    contractDetailHeadingAndSubtitletwo(
                      "Export Item",
                      "Contract type",
                      widget.kwikticket.contract?.commodityName,
                      widget.kwikticket.contract?.contractType == 1
                          ? "International Buyer"
                          : "Local Buyer",

                      // "Cocoa bean",
                      // "Agricultural Commodity",
                    ),
                    SizedBox(height: 15),
                    // contractDetailHeadingAndSubtitletwo(
                    //   "Quantity",
                    //   "Commodity Cost",
                    //   "${widget.kwikticket.quantityToFulfill} Tons",
                    //   "${MoneyUtils.formatMoney(widget.kwikticket.kwikTicketAmount ?? 0)}",
                    //   // "20.5 tons",
                    //   // "₦246,000,000",
                    //   fontFamily: "",
                    // ),
                    //  SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Quantity",
                          style: kwikTextStlye(
                            13.0,
                            FontWeight.w500,
                            colorCodes.black,
                          ),
                        ),
                        Text(
                          "Commodity Cost",
                          style: kwikTextStlye(
                            13.0,
                            FontWeight.w500,
                            colorCodes.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${widget.kwikticket.quantityToFulfill} Tons",
                          style: kwikTextStlye(
                            14.0,
                            FontWeight.w600,
                            fontFamily: "",
                            colorCodes.black,
                          ),
                        ),
                        Row(
                          children: [
                            // Image.asset(
                            //   "assets/images/icons/Trending up.png",
                            //   height: 16,
                            //   width: 16,
                            // ),
                            Text(
                              "${MoneyUtils.formatMoney(widget.kwikticket.kwikTicketAmount ?? 0)}",
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
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Buyer Price Per Ton",
                          style: kwikTextStlye(
                            13.0,
                            FontWeight.w500,
                            colorCodes.black,
                          ),
                        ),
                        Text(
                          "Gross Earning",
                          style: kwikTextStlye(
                            13.0,
                            FontWeight.w500,
                            colorCodes.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${MoneyUtils.formatMoney(widget.kwikticket.contract?.pricePerUnitInUSD ?? 0, symbol: "\$", decimalDigits: 2)}",
                          style: kwikTextStlye(
                            14.0,
                            FontWeight.w600,
                            colorCodes.black,
                          ),
                        ),
                        Row(
                          children: [
                            // Image.asset(
                            //   "assets/images/icons/Trending up.png",
                            //   height: 16,
                            //   width: 16,
                            // ),
                            Text(
                              "${MoneyUtils.formatMoney(widget.kwikticket.projectedIncomeInDollars ?? 0, symbol: "\$", decimalDigits: 2)}",
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

                    SizedBox(height: 18),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Destination",
                          style: kwikTextStlye(
                            13.0,
                            FontWeight.w500,
                            colorCodes.black,
                          ),
                        ),
                        Text(
                          "Ticket Status",
                          style: kwikTextStlye(
                            13.0,
                            FontWeight.w500,
                            colorCodes.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.kwikticket.contract!.destinationCountry,
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
                                widget.kwikticket.isActive == true
                                    ? "Active"
                                    : "Non-active",
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
                    SizedBox(height: 95),
                    Container(
                      height: 87,
                      width: 345,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 3, vertical: 4),
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
                            height: 23,
                            width: 23,
                          ),
                          SizedBox(width: 3),
                          SizedBox(
                            width: 232,
                            child: Text(
                              "This ticket represents your secured allocation in this export contract, please note that this ticket is only valid for 24 hours.",
                              style: kwikTextStlye(
                                12.0,
                                FontWeight.w300,
                                colorCodes.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              SizedBox(height: 20),
              kwikbutton("Activate Ticket", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ExportFulfillmentScreen(
                          kwikticket: widget.kwikticket,
                        ),
                  ),
                );
                currentIndex = 3;
              }),
              SizedBox(height: 10),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Bottomnavigationbar(3),
    );
  }
}
