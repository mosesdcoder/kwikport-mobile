import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/home/dashboard/procurement%20Agency/agency_container.dart';
import 'package:kwik_port/ui/home/dashboard/procurement%20Agency/confirm_agency_selection_dialog.dart';
import 'package:kwik_port/utils/button/back_nav_header.dart';
import 'package:kwik_port/utils/button/bottom_navigatior_bar.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

class SelectProcurementAgencyScreen extends StatefulWidget {
  const SelectProcurementAgencyScreen({super.key});

  @override
  State<SelectProcurementAgencyScreen> createState() =>
      _SelectProcurementAgencyScreenState();
}

class _SelectProcurementAgencyScreenState
    extends State<SelectProcurementAgencyScreen> {
  int endTime = DateTime.now().millisecondsSinceEpoch + 86400000; // 24 hours
  int itemCount = 5;
  List agencyName = [
    "AgriSource Hub Ltd.",
    "FarmLink Aggregators",
    "GreenGate Procurement",
    "AgroTrust Services",
    "HarvestPoint Aggregators",
  ];
  // String reviewStar = '4.8';
  // String ratingStr = reviewStar.split('/')[0].replaceAll('(', '').trim();
  double agencyrating = double.tryParse('4.8') ?? 0.0; // Safely parse rating

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: colorCodes.whiteSmoke,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),

        children: [
          Column(
            children: [
              backNavRow(context, "Select Procurement Agency", fontSize: 20.0),
              SizedBox(height: 31),
              Image.asset(
                "assets/images/icons/procuement_select_check.png",
                height: 96,
                width: 113,
              ),
              SizedBox(height: 31),
              Text(
                "Choose a procurement agency\nfor your export contract",
                textAlign: TextAlign.center,
                style: kwikTextStlye(18.0, FontWeight.w600, colorCodes.black),
              ),
              SizedBox(height: 5),
              Text(
                "Your selection will be locked in 24 hours.",
                style: kwikTextStlye(
                  14.0,
                  FontWeight.w300,
                  colorCodes.graniteGrey,
                ),
              ),
              SizedBox(height: 17),
              Container(
                height: 119,
                width: 390,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                  color: HexColor("#D0E1FB").withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    width: 1.5,
                    color: colorCodes.paleCornflowerBlue,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/images/icons/blue_info.png",
                      height: 25,
                      width: 25,
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 302,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Payment Information",
                            style: kwikTextStlye(
                              14.0,
                              FontWeight.w600,
                              colorCodes.bluetiful,
                            ),
                          ),
                          Text(
                            "Agency fees will be automatically deducted in USD from your KwikLC wallet balance. Your gross export earnings are already secured in your wallet.",
                            // textAlign:,
                            style: kwikTextStlye(
                              11.0,
                              FontWeight.w300,
                              colorCodes.bluetiful,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 80,
                width: 390,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                  color: colorCodes.floralWhite,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    width: 1.5,
                    color: colorCodes.yellowOrange,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/images/icons/time_remaining_yellow.png",
                      height: 34,
                      width: 34,
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 290,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Time Remaining",
                            style: kwikTextStlye(
                              14.0,
                              FontWeight.w600,
                              colorCodes.rufous,
                            ),
                          ),
                          CountdownTimer(
                            endTime: endTime,
                            endWidget: Center(
                              child: Text(
                                '00 : 00 : 00',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: colorCodes.rufous,
                                ),
                              ),
                            ),
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: colorCodes.rufous,
                            ),
                            onEnd: () {},
                            // () {
                            //   setState(() {
                            //     timerActive = false;
                            //   });
                            // },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 260 * itemCount.toDouble(),
                child: ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 20),
                  itemCount: itemCount,
                  itemBuilder: (ctx, index) {
                    return procurementAgencyContainer(
                      "assets/images/icons/dashboard/procurement_agency_logo.png",
                      agencyName[index],
                      agencyrating,
                      "\$40",
                      "#62,000",
                      "4 days",
                      "96hours",
                      "120 reviews",
                      () {},
                      () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,

                          builder: (BuildContext context) {
                            return ConfirmAgencySelectionDialog(
                              serviceFee: "\$50",
                              totalcostTons: "20.5",
                              totalCost: "₦246,000,000",
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Bottomnavigationbar(1),
    );
  }
}
