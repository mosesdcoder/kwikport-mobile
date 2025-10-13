import 'package:flutter/widgets.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

Widget notificationContainer(
  notifstatus,
  title,
  time,
  textone,
  texttwo,
  textthree,
  textfour,
) {
  return Container(
    // height: ,
    width: 358,
    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
    decoration: BoxDecoration(
      color: colorCodes.whiteSmoke,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  notifstatus == "completed"
                      ? "assets/images/icons/dashboard/notif1.png"
                      : "assets/images/icons/dashboard/notif2.png",
                  height: 28,
                  width: 28,
                ),
                SizedBox(width: 5),
                Text(
                  title,
                  style: kwikTextStlye(12.0, FontWeight.w500, colorCodes.black),
                ),
              ],
            ),

            Row(
              children: [
                Text(
                  "$time ago",
                  style: kwikTextStlye(
                    10.0,
                    FontWeight.w300,
                    colorCodes.textBlack,
                  ),
                ),
                SizedBox(width: 4),
                Container(
                  height: 8,
                  width: 8,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorCodes.azureBlue,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(width: 30),
            SizedBox(
              width: 260,
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: "",
                    fontWeight: FontWeight.w300,
                    fontSize: 10,
                    color: colorCodes.graniteGrey,
                  ),
                  children: [
                    TextSpan(text: "$textone "),
                    TextSpan(
                      text: "$texttwo ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: colorCodes.black,
                      ),
                    ),
                    TextSpan(text: "$textthree "),
                    TextSpan(
                      text: "$textfour",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: colorCodes.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
