import 'package:flutter/material.dart';
import 'package:kwik_port/api/model/dashboard_model.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/home/dashboard/dashboard.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'dart:developer' as developer;

class ExportCompleteScreen extends StatefulWidget {
  final KwikTicketModel? kwikticket;
  const ExportCompleteScreen({super.key, required this.kwikticket});

  @override
  State<ExportCompleteScreen> createState() => _ExportCompleteScreenState();
  
}

class _ExportCompleteScreenState extends State<ExportCompleteScreen> {
  @override
  void initState() {
  super.initState();

  developer.log(
    'Commodity ID: ${widget.kwikticket?.commodity?.id}',
    name: 'ExportCompleteScreen',
  );
}
  Widget build(BuildContext context) {
        debugPrint('ExportCompleteScreen: kwikticket = \\${widget.kwikticket}');
        debugPrint('ExportCompleteScreen: commodity = \\${widget.kwikticket?.commodity}');
        debugPrint('ExportCompleteScreen: commodity name = \\${widget.kwikticket?.commodity?.name}');
      debugPrint('ExportCompleteScreen: commodity name = ' + (widget.kwikticket?.commodity?.name ?? 'null'));
    return Scaffold(
      backgroundColor: colorCodes.azureBlue,
      // extendBody: true,
      body: ListView(
        children: [
          Column(
            children: [
              // Container(
              //   height: 10,
              //   width: MediaQuery.of(context).size.width,
              //   color: colorCodes.white,
              // ),
              Container(
                // height: 700,
                // width: 667,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/images/Ellipse 2050.png"),
                  ),
                  // borderRadius: BorderRadius.only(
                  //   bottomLeft: Radius.circular(150),
                  //   bottomRight: Radius.circular(150),
                  // ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/icons/dashboard/Group 3015999.png",
                        height: 266,
                        width: 214,
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Congratulations!",
                        style: kwikTextStlye(
                          24.0,
                          FontWeight.w600,
                          colorCodes.black,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Export Completed!",
                        textAlign: TextAlign.center,
                        style: kwikTextStlye(
                          42.0,
                          FontWeight.w700,
                          colorCodes.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/Kwiport.png',
                      height: 32,
                      width: 124,
                    ),
                    SizedBox(height: 13),
                    Container(
                      height: 77,
                      width: 346,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: colorCodes.white,
                        borderRadius: BorderRadius.circular(8),
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
                            "assets/images/icons/kwiktickett.png",
                            height: 20,
                            width: 20,
                          ),
                          SizedBox(width: 6),
                          SizedBox(
                            width: 280,
                            child: Text(
                              "Congratulations! Your export journey has been completed successfully. Your earnings have been credited to your KwikBalance.",
                              textAlign: TextAlign.start,
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
                    Container(
                      height: 54,
                      width: 346,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: colorCodes.whiteSmoke,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/icons/dashboard/notif2.png",
                                    height: 31,
                                    width: 31,
                                  ),
                                  SizedBox(width: 5),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Product Exported",
                                        style: kwikTextStlye(
                                          10.0,
                                          FontWeight.w300,
                                          colorCodes.aluminium,
                                        ),
                                      ),
                                      Text(
                                        widget.kwikticket?.commodity?.name ?? //.contract?.commodityName ??
                                            '',
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
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/icons/dashboard/star_filled.png",
                                    height: 15,
                                    width: 15,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    "Premium",
                                    style: kwikTextStlye(
                                      10.0,
                                      FontWeight.w500,
                                      colorCodes.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 95,
                      width: 346,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: colorCodes.whiteSmoke,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/icons/walletIcon.png",
                                    height: 40,
                                    width: 40,
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Your Earnings",
                                        style: kwikTextStlye(
                                          10.0,
                                          FontWeight.w300,
                                          colorCodes.jetBlack,
                                        ),
                                      ),
                                      Text(
                                        "₦${widget.kwikticket?.projectedIncomeInDollars ?? '0.00'}",

                                        style: kwikTextStlye(
                                          fontFamily: "",
                                          16.0,
                                          FontWeight.w600,
                                          colorCodes.black,
                                        ),
                                      ),
                                      Text(
                                        "Credited to KwikBalance",
                                        style: kwikTextStlye(
                                          10.0,
                                          FontWeight.w300,
                                          colorCodes.jetBlack,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/icons/dashboard/star_filled.png",
                                    height: 15,
                                    width: 15,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    "Premium",
                                    style: kwikTextStlye(
                                      10.0,
                                      FontWeight.w500,
                                      colorCodes.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 58,
                      width: 346,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Dashboard(),
                            ),
                          );
                        },

                        style: ElevatedButton.styleFrom(
                          side: BorderSide(
                            color: colorCodes.antiFlashWhite,
                            width: 1.2,
                          ),
                          backgroundColor: colorCodes.azureBlue,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: Text(
                          "Continue",
                          // "Share Milestone",
                          style: kwikTextStlye(
                            14.0,
                            FontWeight.w500,
                            colorCodes.white,
                            fontFamily: "Poppins",
                          ),
                        ),
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
}
