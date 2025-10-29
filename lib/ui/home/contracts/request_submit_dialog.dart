import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/main.dart';
import 'package:kwik_port/ui/home/dashboard/dashboard.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

class RequestSubmitDialog extends StatefulWidget {
  const RequestSubmitDialog({super.key});

  @override
  State<RequestSubmitDialog> createState() => _RequestSubmitDialogState();
}

class _RequestSubmitDialogState extends State<RequestSubmitDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: colorCodes.white,
      child: Container(
        height: 491,
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
              "Request Submitted Successfully!",
              textAlign: TextAlign.center,
              style: kwikTextStlye(24.0, FontWeight.w600, colorCodes.black),
            ),
            SizedBox(height: 10),

            Container(
              height: 97,
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/icons/dashboard/kwikticket_blue.png",
                    height: 22,
                    width: 22,
                  ),
                  SizedBox(width: 6),
                  SizedBox(
                    width: 230,
                    child: Text(
                      "Your request has been submitted. Our team will review it and notify you by in-app notification or email. If approved, we'll begin sourcing an export contract for your product. If not, we'll also notify you.",
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
            SizedBox(height: 40),
            kwikbutton("Dashboard", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
              );
              currentIndex = 1;
            }),
          ],
        ),
      ),
    );
  }
}
