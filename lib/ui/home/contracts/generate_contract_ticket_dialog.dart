import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/api/model/dashboard_model.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/main.dart';
import 'package:kwik_port/ui/home/contracts/kwikticket_created_successfully.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:kwik_port/utils/textFields/goods_volume_field.dart';

class GenerateContractTicketDialog extends StatefulWidget {
  final ContractModel contract;
  final generateFunc;
  const GenerateContractTicketDialog({
    super.key,
    required this.contract,
    required this.generateFunc,
  });

  @override
  State<GenerateContractTicketDialog> createState() =>
      _GenerateContractTicketDialogState();
}

class _GenerateContractTicketDialogState
    extends State<GenerateContractTicketDialog> {
  late TextEditingController volumeController;

  void validateVolume() {
    if (volumeController.text.isEmpty) {
      setState(() {
        colorCodes.white.withOpacity(0.5);
      });
    } else {
      setState(() {
        Colors.transparent;
      });
    }
  }

  @override
  void initState() {
    volumeController = TextEditingController(
      text: "${widget.contract.totalQuantity}",
    );
    volumeController.addListener(validateVolume);
    super.initState();
  }

  @override
  void dispose() {
    volumeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 390,
      child: Dialog(
        // child: SingleChildScrollView(
        // child: Padding(
        // padding: EdgeInsets.only(
        //   bottom: MediaQuery.of(context).viewInsets.bottom,
        //   left: 16,
        //   right: 16,
        //   top: 16,
        // ),
        child: Container(
          height: 550,
          // height: double.infinity,
          // width: double.infinity,
          // width: MediaQuery.of(context).size.width - 50,
          width: 390,
          decoration: BoxDecoration(
            color: colorCodes.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorCodes.antiFlashWhite, width: 1.2),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: ListView(
            children: [
              Column(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Generate kwikticket",
                        style: kwikTextStlye(
                          20.0,
                          FontWeight.w600,
                          colorCodes.black,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                          "assets/images/icons/close-circle.png",
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Image.asset("assets/images/cocoa.png", height: 52, width: 52),
                  SizedBox(height: 8),
                  Text(
                    "Agricultural Commodity ",
                    style: kwikTextStlye(
                      12.0,
                      FontWeight.w300,
                      colorCodes.graniteGrey,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Cocoa bean",
                    style: kwikTextStlye(
                      20.0,
                      FontWeight.w600,
                      colorCodes.black,
                    ),
                  ),
                  SizedBox(height: 16),
                  goodsVolumnFieldColumn(
                    "",
                    volumeController,
                    suffixIcon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            if (volumeController.text.isNotEmpty) {
                              setState(() {
                                volumeController.text =
                                    (double.parse(volumeController.text) + 1.0)
                                        .toString();
                                print(volumeController.text);
                              });
                            }
                          },
                          child: Image.asset(
                            "assets/images/icons/arrow-up.png",
                            height: 12,
                            width: 12,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (volumeController.text.isNotEmpty) {
                              final volume = double.parse(
                                volumeController.text,
                              );
                              if (volume == 1.0) {
                              } else {
                                setState(() {
                                  2 - 1;
                                  volumeController.text =
                                      (double.parse(volumeController.text) -
                                              1.0)
                                          .toString();
                                });
                              }
                            }
                          },
                          child: Image.asset(
                            "assets/images/icons/arrow-down.png",
                            height: 12,
                            width: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: "",
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: colorCodes.mediumSeaGreen,
                        ),
                        children: [
                          TextSpan(text: " Available: "),
                          TextSpan(
                            text: "${widget.contract.fulfilledQuantity} tons",
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  marketRateContainer(
                    "${widget.contract.buyerSpecification?.buyerPricePerUnit}",
                    "Total Cost (${volumeController.text} tons)",
                    "₦${widget.contract.totalAmountSpent}",
                    volumeController.text,
                  ),
                  SizedBox(height: 24),
                  kwikbutton("Generate Ticket", (widget.generateFunc)),
                  SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
        // ),
        // ),
      ),
    );
  }
}

Widget marketRateContainer(pricePerTon, totalCost, totalCostPrice, volume) {
  return Container(
    height: volume == "" ? 92 : 130,
    width: 352,
    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 16),
    decoration: BoxDecoration(
      color: colorCodes.whiteSmoke,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Image.asset(
              "assets/images/icons/Trending up.png",
              height: 16,
              width: 16,
            ),
            SizedBox(width: 5),
            Text(
              "Current Market Rate",
              style: kwikTextStlye(14.0, FontWeight.w500, colorCodes.black),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Price per ton",
              style: kwikTextStlye(
                12.0,
                FontWeight.w300,
                colorCodes.graniteGrey,
              ),
            ),
            Text(
              pricePerTon,
              style: kwikTextStlye(
                14.0,
                FontWeight.w600,
                colorCodes.textBlack,
                fontFamily: "",
              ),
            ),
          ],
        ),
        volume == "" ? SizedBox() : SizedBox(height: 16),
        volume == ""
            ? SizedBox()
            : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  totalCost,
                  style: kwikTextStlye(
                    12.0,
                    FontWeight.w300,
                    colorCodes.textBlack,
                  ),
                ),
                Text(
                  totalCostPrice,
                  style: kwikTextStlye(
                    14.0,
                    FontWeight.w600,
                    colorCodes.textBlack,
                    fontFamily: "",
                  ),
                ),
              ],
            ),
      ],
    ),
  );
}
