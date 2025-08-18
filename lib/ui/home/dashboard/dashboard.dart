import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/main.dart';
import 'package:kwik_port/ui/home/contracts/contract_details_screen.dart';
import 'package:kwik_port/ui/home/dashboard/name_and_notif_headng.dart';
import 'package:kwik_port/ui/home/dashboard/wallet_balance_container.dart';
import 'package:kwik_port/utils/button/bottom_navigatior_bar.dart';
import 'package:kwik_port/utils/button/elavated_button.dart';
import 'package:kwik_port/utils/containers/available_contract_container.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool notificationExist = false;
  int itemCount = 3;

  @override
  Widget build(BuildContext context) {
    setState(() {
      currentIndex = 1;
    });
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent going back
        return false;
      },
      child: Scaffold(
        extendBody: true,
        backgroundColor: colorCodes.whiteSmoke,
        body: ListView(
          shrinkWrap: true,
          physics: RangeMaintainingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 50.0),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                nameAndNotifHeading(
                  context,
                  notificationExist,
                  notificationFunc,
                ),
                SizedBox(height: 30),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    walletBalanceContainer(() {}),
                    SizedBox(width: 5),
                    Column(
                      children: [
                        activityProgressContainer(
                          "assets/images/icons/kwik_tickets.png",
                          "Active Kwiktickets",
                          "01",
                        ),
                        SizedBox(height: 5),
                        activityProgressContainer(
                          "assets/images/icons/completed_ecport.png",
                          "Completed Exports",
                          "15",
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 18),
                procurementContainer(),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Available Contracts",
                      style: kwikTextStlye(
                        16.0,
                        FontWeight.w500,
                        colorCodes.black,
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        "See All",
                        style: kwikTextStlye(
                          14.0,
                          FontWeight.w500,
                          colorCodes.azureBlue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18),
                // avaiableontractContainer(
                //   "assets/images/cocoa.png",
                //   "Cocoa Bean",
                //   "assets/images/icons/tick-circle.png",
                //   "Open",
                //   "100 tons",
                //   "assets/images/icons/Country.png",
                //   "Argentina",
                //   "20 tons",
                //   "100 tons",
                //   "20%",
                //   "\$12,500",
                //   "assets/images/icons/Trending up.png",
                //   "15.5%",
                //   () {},
                // ),
                SizedBox(
                  height: 320 * itemCount.toDouble(),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(height: 16),
                    itemCount: itemCount,
                    itemBuilder: (ctx, index) {
                      return avaiableontractContainer(
                        "assets/images/cocoa.png",
                        "Cocoa Bean",
                        "assets/images/icons/tick-circle.png",
                        "Open",
                        "100 tons",
                        "assets/images/icons/Country.png",
                        "Argentina",
                        "20 tons",
                        "100 tons",
                        "20%",
                        "\$12,500",
                        "assets/images/icons/Trending up.png",
                        "15.5%",
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ContractDetailsScreen(),
                            ),
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
      ),
    );
  }

  void notificationFunc() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => Notificationscreen(),
    //   ),
    // );
  }
  Widget procurementContainer() {
    return Container(
      height: 70,
      width: 390,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1.2, color: colorCodes.antiFlashWhite),
        borderRadius: BorderRadius.circular(6),
        color: colorCodes.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/clock_awaits.png",
                height: 40,
                width: 40,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Awaiting your action",
                    style: kwikTextStlye(
                      12.0,
                      FontWeight.w300,
                      colorCodes.graniteGrey,
                    ),
                  ),
                  // SizedBox(height: 3),
                  Text(
                    "Select procurement agency",
                    style: kwikTextStlye(
                      12.0,
                      FontWeight.w500,
                      colorCodes.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 23,
            // width: 58,
            child: elevatedbutton(
              "Proceed",
              () {},
              backgroundcolor: colorCodes.portlandOrange,
            ),
          ),
        ],
      ),
    );
  }
}
