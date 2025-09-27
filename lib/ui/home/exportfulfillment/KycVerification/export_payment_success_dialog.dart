import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/home/dashboard/procurement%20Agency/select_procurement_agency_screen.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:kwik_port/ui/home/exportfulfillment/KycVerification/export_payment_confirmed.dart';

class ExportPaymentSucessfulDialog extends StatefulWidget {
  const ExportPaymentSucessfulDialog({super.key});

  @override
  State<ExportPaymentSucessfulDialog> createState() =>
      _ExportPaymentSucessfulDialogState();
}

class _ExportPaymentSucessfulDialogState
    extends State<ExportPaymentSucessfulDialog> {
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
            SizedBox(height: 40),
            Text(
              "KYC Submitted Successfully!",
              style: kwikTextStlye(20.0, FontWeight.w600, colorCodes.black),
            ),
            SizedBox(height: 10),
            Text(
              "Your Export Gross Earnings have been credited to your KwikLC dollar wallet. ",
              textAlign: TextAlign.center,
              style: kwikTextStlye(12.0, FontWeight.w500, colorCodes.aluminium),
            ),
            SizedBox(height: 10),
            Container(
              height: 77,
              width: 331,
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
                    " \$4,200",
                    fontFamily: "",
                  ),
                  SizedBox(height: 10),
                  confirmeddetailRow("Commodity:", "Cocoa (10 MT)"),
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
                        width: 102,
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
                            Text(
                              "#KPX92831",
                              style: kwikTextStlye(
                                10.0,
                                FontWeight.w500,
                                colorCodes.black,
                              ),
                            ),
                            SizedBox(width: 10),
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
                    builder: (context) => SelectProcurementAgencyScreen(),
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
                      16.0,
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
