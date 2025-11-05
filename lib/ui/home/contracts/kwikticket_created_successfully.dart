import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:kwik_port/api/model/dashboard_model.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/main.dart';
import 'package:kwik_port/ui/home/kwikticket/kwikticket_screen.dart';
import 'package:kwik_port/ui/home/dashboard/dashboard.dart';
import 'package:kwik_port/utils/button/backNav_button.dart';
import 'package:kwik_port/utils/button/bottom_navigatior_bar.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/contract_detail_heading_and_subtitle.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class KwikticketCreatedSuccessfully extends StatefulWidget {
  final KwikTicketModel kwikticket;

  // final kwikticketID,
  // exporterName,
  // exportItem,
  // contractType,
  // stakedVolume,
  // capitalCost,
  // destination;
  const KwikticketCreatedSuccessfully({super.key, required this.kwikticket});

  @override
  State<KwikticketCreatedSuccessfully> createState() =>
      _KwikticketCreatedSuccessfullyState();
}

class _KwikticketCreatedSuccessfullyState
    extends State<KwikticketCreatedSuccessfully> {
  Uint8List? bytes;
  final screenshotController = ScreenshotController();

  Future<void> _downloadReceipt(context) async {
    await screenshotController.capture(delay: Duration(milliseconds: 10)).then((
      image,
    ) async {
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath =
            await File('${directory.path}/kwikTicket.png').create();
        await imagePath.writeAsBytes(image);
        // GallerySaver.saveImage(imagePath.path).then((path) {
        //   showToast(
        //       "Receipt downloaded successfully", colorCodes.greenBtn, context);
        // });
        // final bytes = await imagePath.readAsBytes();
        // final result = await ImageGallerySaver.saveImage(
        //   Uint8List.fromList(bytes),
        //   quality: 100,
        //   // name: "your_image_name",
        // );
        // if (result != null && result['isSuccess']) {
        //   showToast(
        //       "Receipt downloaded successfully", colorCodes.greenBtn, context);
        //   ;
        // } else {
        //   showToast("Failed to save image", colorCodes.redAccent, context);
        // }
      }
    });
  }

  Future saveImage(Uint8List bytes) async {
    final appStorage = await getApplicationDocumentsDirectory();
    File file = File('${appStorage.path}/xchangReceipt.png');
    file.writeAsBytes(bytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: colorCodes.whiteSmoke,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: backnavButton(
                  context,
                  func: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Dashboard()),
                    );
                    currentIndex = 1;
                  },
                ),
              ),
              SizedBox(height: 15),
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
              SizedBox(height: 24),
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
                    contractDetailHeadingAndSubtitletwo(
                      "Kwikticket ID",
                      "Exporter Name",
                      widget.kwikticket.uniqueId,
                      widget.kwikticket.exporter?.businessName,
                      // "#Kwk-8989-09",
                      // "John  Gbenga",
                    ),
                    SizedBox(height: 20),
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
                    SizedBox(height: 20),
                    contractDetailHeadingAndSubtitletwo(
                      "Selected Capacity",
                      "Commodity Cost",
                      "${widget.kwikticket.quantityToFulfill} tons",
                      "${widget.kwikticket.kwikTicketAmount}",
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
                          "${widget.kwikticket.contract?.buyerSpecification?.buyerPricePerUnit}",
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
                              "${widget.kwikticket.grossEarning}%",
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
                    SizedBox(height: 20),
                    contractDetailHeadingAndSubtitle(
                      "Duration ",
                      "Time",
                      "${widget.kwikticket.deadline?.day} Days",

                      // "12 AUG 2025",
                      DateFormat('h:mm a').format(widget.kwikticket.deadline!),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              kwikbutton("View Kwickticket", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            KwikticketScreen(kwikticket: widget.kwikticket),
                  ),
                );
                currentIndex = 3;
              }),
              SizedBox(height: 10),
              kwikbutton(
                '', //dud
                () {
                  _downloadReceipt(context);
                },
                textColor: colorCodes.textBlack,
                backgroundcolor: colorCodes.white,
                borderColor: colorCodes.antiFlashWhite,
                buttonChild: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Download",
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
              SizedBox(height: 50),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Bottomnavigationbar(3),
    );
  }
}
