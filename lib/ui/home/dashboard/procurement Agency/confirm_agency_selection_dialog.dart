import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/home/dashboard/procurement%20Agency/agency_selection_confirmed_dialog.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

class ConfirmAgencySelectionDialog extends StatefulWidget {
  final serviceFee, totalcostTons, totalCost;
  const ConfirmAgencySelectionDialog({
    super.key,
    required this.serviceFee,
    required this.totalcostTons,
    required this.totalCost,
  });

  @override
  State<ConfirmAgencySelectionDialog> createState() =>
      _ConfirmAgencySelectionDialogState();
}

class _ConfirmAgencySelectionDialogState
    extends State<ConfirmAgencySelectionDialog> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 390,
      child: Dialog(
        child: Container(
          height: 770,

          width: 390,
          decoration: BoxDecoration(
            color: colorCodes.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorCodes.antiFlashWhite, width: 1.2),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
          child: ListView(
            children: [
              Column(
                children: [
                  Image.asset(
                    "assets/images/icons/account_successimg.png",
                    height: 96,
                    width: 113,
                  ),
                  SizedBox(height: 40),
                  Text(
                    "Confirm Agency Selection",
                    style: kwikTextStlye(
                      18.0,
                      FontWeight.w600,
                      colorCodes.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Review your agency selection and confirm to proceed with your export contract.",
                    textAlign: TextAlign.center,
                    style: kwikTextStlye(
                      14.0,
                      FontWeight.w300,
                      colorCodes.graniteGrey,
                    ),
                  ),
                  SizedBox(height: 25),
                  Container(
                    height: 462,

                    width: 342,
                    decoration: BoxDecoration(
                      color: colorCodes.whiteSmoke,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: colorCodes.antiFlashWhite,
                        width: 1.2,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13.0,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/cocoa.png",
                          height: 52,
                          width: 52,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "GreenGate Procurement",
                          style: kwikTextStlye(
                            18.0,
                            FontWeight.w600,
                            colorCodes.black,
                          ),
                        ),
                        SizedBox(height: 24),
                        Container(
                          height: 92,
                          width: 304,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: HexColor("#E7E7E7"),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Service fee:",
                                    textAlign: TextAlign.center,
                                    style: kwikTextStlye(
                                      14.0,
                                      FontWeight.w300,
                                      colorCodes.aluminium,
                                    ),
                                  ),
                                  Text(
                                    widget.serviceFee,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: "",
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: colorCodes.graniteGrey,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total Cost (${widget.totalcostTons} tons)",
                                    textAlign: TextAlign.center,
                                    style: kwikTextStlye(
                                      12.0,
                                      FontWeight.w600,
                                      colorCodes.black,
                                    ),
                                  ),
                                  Text(
                                    widget.totalCost,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: "",
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                      color: colorCodes.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          "This will be automatically deducted from your KwikLC wallet.",
                          textAlign: TextAlign.center,
                          style: kwikTextStlye(
                            12.0,
                            FontWeight.w500,
                            colorCodes.graniteGrey,
                          ),
                        ),
                        SizedBox(height: 20),
                        kwikbutton("Confirm Selection", () {
                          Navigator.pop(context);
                          showDialog(
                            barrierDismissible: false,
                            context: context,

                            builder: (BuildContext context) {
                              return AgencySelectionConfirmedDialog(
                                serviceFee: "\$50",
                                totalcostTons: "20.5",
                                totalCost: "₦246,000,000",
                              );
                            },
                          );
                        }),
                        SizedBox(height: 12),
                        kwikbutton(
                          "Cancel",
                          () {
                            Navigator.pop(context);
                          },
                          backgroundcolor: colorCodes.white,
                          textColor: colorCodes.black,
                          borderColor: colorCodes.antiFlashWhite,
                          fontSize: 12.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
