import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/home/dashboard/notifcation/notification_container.dart';
import 'package:kwik_port/utils/button/bottom_navigatior_bar.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String numberofexport = "4";
  String transactionNotif = "2";
  String systemNotif = "2";
  int itemCount = 7;
  List textone = [
    "Your selected procurement agency is now responsible for sourcing your goods",
    "MV ATLANTIC STAR has departed Lagos port with your container ",
    "A new journey has started.",
    "₦85,000 has been deducted from your KwikLC wallet for packaging & documentation services.",
    "₦85,000 has been deducted from your KwikLC wallet for packaging & documentation services.",
    "₦85,000 has been deducted from your KwikLC wallet for packaging & documentation services.",
    "Your selected procurement agency is now responsible for sourcing your goods",
  ];
  List notifstatus = [
    "completed",
    "completed",
    "not",
    "not",
    "not",
    "not",
    "completed",
  ];
  List texttwo = ["", "APLU-7834562.", "", "", "", "", "APLU-7834562."];
  List textthree = [
    "",
    "Estimated arrival:",
    "",
    "",
    "",
    "",
    "Estimated arrival:",
  ];
  List textfour = ["", "Dec 28, 2025.", "", "", "", "", "Dec 28, 2025."];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  bool newNotification = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(160.0),
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      'assets/images/icons/button back.png',
                      height: 48,
                      width: 48,
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      "Notifications",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                        color: colorCodes.black,
                      ),
                    ),
                  ),
                  Container(
                    height: 48,
                    width: 48,
                    // alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colorCodes.white,
                      border: Border.all(
                        width: 1.5,
                        color: colorCodes.antiFlashWhite,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/images/icons/notification.png',
                          color: colorCodes.black,
                          height: 24,
                          width: 24,
                        ),
                        newNotification
                            ? Positioned(
                              top: 12,
                              // top: 0,
                              right: 15,
                              child: CircleAvatar(
                                radius: 3.0,
                                backgroundColor: colorCodes.portlandOrange,
                              ),
                            )
                            : Container(),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 17),
              notificationTabBar(
                _tabController,
                numberofexport,
                transactionNotif,
                systemNotif,
                (index) {
                  switch (index) {
                    case 1:
                      setState(() {
                        numberofexport = "";
                      });
                      break;
                    case 2:
                      setState(() {
                        transactionNotif = "";
                      });
                      break;
                    case 3:
                      setState(() {
                        systemNotif = "";
                      });
                      break;
                    default:
                  }
                  // if (index == 2) {
                  //   setState(() {
                  //     numberofexport = "";
                  //   });
                  // }
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: colorCodes.whiteSmoke,
      body: ListView(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 60),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height - 180,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 90 * itemCount.toDouble(),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      Container(
                        height: 90 * itemCount.toDouble(),
                        width: 390,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: colorCodes.white,
                        ),
                        child: ListView.separated(
                          padding: EdgeInsets.only(bottom: 40),
                          physics: NeverScrollableScrollPhysics(),
                          separatorBuilder:
                              (context, index) => SizedBox(height: 15),
                          itemCount: itemCount,
                          itemBuilder: (ctx, index) {
                            return notificationContainer(
                              notifstatus[index],
                              "Export Complete 🎉",
                              "1min",
                              textone[index],
                              texttwo[index],
                              textthree[index],
                              textfour[index],
                            );
                          },
                        ),
                      ),
                      Container(
                        height: 90 * itemCount.toDouble(),
                        width: 390,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: colorCodes.white,
                        ),
                        child: ListView.separated(
                          padding: EdgeInsets.only(bottom: 40),
                          physics: NeverScrollableScrollPhysics(),
                          separatorBuilder:
                              (context, index) => SizedBox(height: 15),
                          itemCount: itemCount,
                          itemBuilder: (ctx, index) {
                            return notificationContainer(
                              notifstatus[index],
                              "Export Complete 🎉",
                              "1min",
                              textone[index],
                              texttwo[index],
                              textthree[index],
                              textfour[index],
                            );
                          },
                        ),
                      ),
                      Container(
                        height: 90 * itemCount.toDouble(),
                        width: 390,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: colorCodes.white,
                        ),
                        child: ListView.separated(
                          padding: EdgeInsets.only(bottom: 40),
                          physics: NeverScrollableScrollPhysics(),
                          separatorBuilder:
                              (context, index) => SizedBox(height: 15),
                          itemCount: itemCount,
                          itemBuilder: (ctx, index) {
                            return notificationContainer(
                              notifstatus[index],
                              "Export Complete 🎉",
                              "1min",
                              textone[index],
                              texttwo[index],
                              textthree[index],
                              textfour[index],
                            );
                          },
                        ),
                      ),
                      Container(
                        height: 90 * itemCount.toDouble(),
                        width: 390,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: colorCodes.white,
                        ),
                        child: ListView.separated(
                          padding: EdgeInsets.only(bottom: 40),
                          physics: NeverScrollableScrollPhysics(),
                          separatorBuilder:
                              (context, index) => SizedBox(height: 15),
                          itemCount: itemCount,
                          itemBuilder: (ctx, index) {
                            return notificationContainer(
                              notifstatus[index],
                              "Export Complete 🎉",
                              "1min",
                              textone[index],
                              texttwo[index],
                              textthree[index],
                              textfour[index],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Bottomnavigationbar(1),
    );
  }

  Widget notificationTabBar(
    _tabController,
    exportNotif,
    transactionNotif,
    systemNotif,
    onTap,
  ) {
    return Container(
      height: 58,
      width: 395,
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),

      decoration: BoxDecoration(
        color: colorCodes.white,
        borderRadius: BorderRadius.circular(100),
      ),

      child: TabBar(
        onTap: onTap,
        padding: EdgeInsets.symmetric(horizontal: 0),
        // indicatorColor: colorCodes.teaGreen,
        labelPadding: const EdgeInsets.symmetric(horizontal: 1),
        indicatorSize: TabBarIndicatorSize.tab,

        labelColor: colorCodes.white,
        labelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
        ),
        unselectedLabelColor: colorCodes.black,
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
          // color: colorCodes
        ),

        indicatorPadding: const EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 5,
        ),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: colorCodes.frenchSkyBlue),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              colorCodes.jordyBlue,
              colorCodes.azureBlue,
              colorCodes.azureBlue,
            ],
          ),
          color: colorCodes.white,
        ),
        controller: _tabController,
        tabs: [
          Tab(
            text: 'All',
            // child: SizedBox(
            //   width: 54,
            //   child: Stack(
            //     clipBehavior: Clip.none, // important! prevents clipping
            //     children: [
            //       Align(alignment: Alignment.center, child: Text("All")),
            //       Positioned(
            //         top: 5,
            //         right: 6,
            //         child: Container(
            //           height: 14,
            //           width: 15,
            //           alignment: Alignment.center,
            //           decoration: BoxDecoration(
            //             color: colorCodes.portlandOrange,
            //             borderRadius: BorderRadius.circular(600),
            //           ),
            //           child: Text(
            //             numberofNotif,
            //             style: kwikTextStlye(
            //               8.0,
            //               FontWeight.w700,
            //               colorCodes.white,
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ),
          Tab(
            child: SizedBox(
              width: 91,
              child: Stack(
                clipBehavior: Clip.none, // important! prevents clipping
                children: [
                  Align(alignment: Alignment.center, child: Text("Exports")),
                  if (exportNotif.isNotEmpty)
                    Positioned(
                      top: 5,
                      right: 6,
                      child: Container(
                        height: 14,
                        width: 15,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colorCodes.portlandOrange,
                          borderRadius: BorderRadius.circular(600),
                        ),
                        child: Text(
                          exportNotif,
                          style: kwikTextStlye(
                            8.0,
                            FontWeight.w700,
                            colorCodes.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Tab(
            child: SizedBox(
              width: 91,
              child: Stack(
                clipBehavior: Clip.none, // important! prevents clipping
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text("Transactions"),
                  ),
                  if (transactionNotif.isNotEmpty)
                    Positioned(
                      top: 5,
                      right: 6,
                      child: Container(
                        height: 14,
                        width: 15,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colorCodes.portlandOrange,
                          borderRadius: BorderRadius.circular(600),
                        ),
                        child: Text(
                          transactionNotif,
                          style: kwikTextStlye(
                            8.0,
                            FontWeight.w700,
                            colorCodes.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Tab(
            child: SizedBox(
              width: 91,
              child: Stack(
                clipBehavior: Clip.none, // important! prevents clipping
                children: [
                  Align(alignment: Alignment.center, child: Text("System")),
                  if (systemNotif.isNotEmpty)
                    Positioned(
                      top: 5,
                      right: 6,
                      child: Container(
                        height: 14,
                        width: 15,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colorCodes.portlandOrange,
                          borderRadius: BorderRadius.circular(600),
                        ),
                        child: Text(
                          systemNotif,
                          style: kwikTextStlye(
                            8.0,
                            FontWeight.w700,
                            colorCodes.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Tab(text: "Exports"),
          // Tab(text: "Transactions"),
          // Tab(text: "System"),
        ],
      ),
    );
  }
}
