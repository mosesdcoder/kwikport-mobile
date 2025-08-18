import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/home/contracts/generate_contract_ticket_dialog.dart';
import 'package:kwik_port/utils/button/back_nav_header.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/contract_detail_heading_and_subtitle.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

class ContractDetailsScreen extends StatefulWidget {
  const ContractDetailsScreen({super.key});

  @override
  State<ContractDetailsScreen> createState() => _ContractDetailsScreenState();
}

class _ContractDetailsScreenState extends State<ContractDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorCodes.whiteSmoke,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              backNavRow(context, "Contract details"),
              SizedBox(height: 31),
              Container(
                height: 576,
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
                    DottedBorder(
                      borderType: BorderType.RRect,
                      radius: Radius.circular(16),
                      color: colorCodes.antiFlashWhite,
                      dashPattern: [8, 8], // [dash length, space length]
                      strokeWidth: 1.2,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        height: 132,
                        width: 342,
                        child: Image.asset(
                          "assets/images/cocoa.png",
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Cocoa Bean",
                        style: kwikTextStlye(
                          16.0,
                          FontWeight.w600,
                          colorCodes.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Allocated",
                      style: kwikTextStlye(
                        12.0,
                        FontWeight.w600,
                        colorCodes.jetBlack,
                      ),
                    ),
                    SizedBox(height: 4),
                    LinearProgressIndicator(
                      backgroundColor: HexColor("#D6E7FF"),
                      minHeight: 8,
                      value: 0.21,
                      borderRadius: BorderRadius.circular(12),
                      color: colorCodes.azureBlue,
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 10.0,
                              fontWeight: FontWeight.w500,
                              color: colorCodes.graniteGrey,
                            ),

                            children: [
                              TextSpan(text: "20 tons"),
                              TextSpan(text: " / "),
                              TextSpan(text: "100 tons"),
                            ],
                          ),
                        ),
                        Text(
                          "20% left",
                          style: kwikTextStlye(
                            12.0,
                            FontWeight.w500,
                            colorCodes.graniteGrey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    SizedBox(
                      width: 358,
                      child: Divider(
                        thickness: 1.2,
                        color: HexColor("#E7E7E7"),
                      ),
                    ),
                    SizedBox(height: 32),

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
                    contractDetailHeadingAndSubtitle(
                      "Total volume",
                      "Minimum Investment",
                      "100 tons",
                      "0.5 ton",
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Contract type",
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
                          "Agricultural Commodity",
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
                                height: 16,
                                width: 16,
                              ),
                              Text(
                                "Open",
                                style: kwikTextStlye(
                                  10.0,
                                  FontWeight.w500,
                                  colorCodes.mediumSeaGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    contractDetailHeadingAndSubtitle(
                      "Destination",
                      "",
                      "Argentina",
                      "",
                    ),
                  ],
                ),
              ),
              SizedBox(height: 27),
              kwikbutton("Generate kwikticket", () {
                showDialog(
                  barrierDismissible: false,
                  context: context,

                  builder: (BuildContext context) {
                    return GenerateContractTicketDialog();
                  },
                );
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
