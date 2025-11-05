import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/api/model/dashboard_model.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/home/dashboard/dashboard.dart';
import 'package:kwik_port/ui/home/dashboard/procurement%20Agency/select_procurement_agency_screen.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:kwik_port/ui/home/exportfulfillment/KycVerification/export_payment_confirmed.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExportPaymentSucessfulDialog extends StatefulWidget {
  final KwikTicketModel kwikticket;
  const ExportPaymentSucessfulDialog({super.key, required this.kwikticket});

  @override
  State<ExportPaymentSucessfulDialog> createState() =>
      _ExportPaymentSucessfulDialogState();
}

class _ExportPaymentSucessfulDialogState
    extends State<ExportPaymentSucessfulDialog> {
  Future<void> _saveKwikTicket(KwikTicketModel kwikticket) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'kwikTicketData',
      jsonEncode(widget.kwikticket.toJson()),
    );
    await prefs.setString('kwikTicketTime', DateTime.now().toIso8601String());
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: colorCodes.white,
      child: Container(
        height: 588,
        // width: double.infinity,
        width: 390,

        decoration: BoxDecoration(
          color: colorCodes.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorCodes.antiFlashWhite, width: 1.2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 24),
                Image.asset(
                  "assets/images/icons/procuement_select_check.png",
                  height: 96,
                  width: 113,
                ),
                InkWell(
                  onTap: () {
                    _saveKwikTicket(widget.kwikticket);
                    debugPrint(
                      "💾 Saving KwikTicket: ${jsonEncode(widget.kwikticket.toJson())}",
                    );

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                Dashboard(kwikticket: widget.kwikticket),
                      ),
                      (route) => false,
                    );
                  },
                  child: Image.asset(
                    "assets/images/icons/close-circle.png",
                    height: 24,
                    width: 24,
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            Text(
              "Congratulations!",

              style: kwikTextStlye(15.0, FontWeight.w600, colorCodes.black),
            ),
            SizedBox(height: 10),
            Text(
              "Your Export Gross Earnings have been credited to your KwikLC dollar wallet. ",
              textAlign: TextAlign.center,
              style: kwikTextStlye(12.0, FontWeight.w500, colorCodes.aluminium),
            ),
            SizedBox(height: 10),
            Container(
              height: 90,
              width: 331,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/images/icons/dashboard/kwikticket_blue.png",
                    height: 25,
                    width: 25,
                  ),
                  SizedBox(width: 4),
                  SizedBox(
                    width: 200,
                    child: Text(
                      "This represents your secured contract value. Agency costs and logistics will be managed automatically as you progress.",
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
              height: 118,
              width: 390,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                color: colorCodes.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  width: 1.2,
                  color: colorCodes.antiFlashWhite,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  confirmeddetailRow(
                    "Gross Earnings:",
                    " ${widget.kwikticket.grossEarning}",
                    fontFamily: "",
                  ),
                  SizedBox(height: 10),
                  confirmeddetailRow(
                    "Commodity:",
                    "${widget.kwikticket.commodity?.name}",
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Contract ID:",
                        style: kwikTextStlye(
                          12.0,
                          FontWeight.w300,
                          colorCodes.graniteGrey,
                        ),
                      ),
                      Container(
                        height: 28,
                        width: 160,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colorCodes.whiteSmoke,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            width: 1.5,
                            color: HexColor("#E7E7E7"),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(
                                "${widget.kwikticket.contract?.contractId}",
                                style: kwikTextStlye(
                                  10.0,
                                  FontWeight.w400,
                                  colorCodes.black,
                                  // textOverflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            // SizedBox(width: 3),
                            InkWell(
                              onTap: () {},
                              child: Image.asset(
                                "assets/images/icons/Frame 1000006191.png",
                                height: 20,
                                width: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            kwikbutton(
              "Select Procurement Agency",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => SelectProcurementAgencyScreen(
                          kwikticket: widget.kwikticket,
                        ),
                  ),
                );
              },
              buttonChild: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_outlined,
                    size: 18,
                    color: colorCodes.whiteSmoke,
                  ),
                  SizedBox(width: 6),
                  Text(
                    "Select Procurement Agency",
                    style: kwikTextStlye(
                      14.0,
                      FontWeight.w500,
                      colorCodes.whiteSmoke,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
