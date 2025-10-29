import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:toastification/toastification.dart';

final FToast fToast = FToast();

void showToastContainer(
  String title,
  String message,
  Color color,
  Color borderColor,
  context,
) {
  fToast.init(context);
  Widget toast = DottedBorder(
    options: RoundedRectDottedBorderOptions(
      radius: const Radius.circular(10),
      color: borderColor,
      dashPattern: const [6, 3], // [dash length, space length]
      strokeWidth: 2,
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 93,
        width: 390,
        padding: const EdgeInsets.only(
          left: 10,
          top: 10,
          bottom: 10,
          right: 10,
        ),
        // alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: colorCodes.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: colorCodes.graniteGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: const Duration(seconds: 3),
  );
}

void showToastE({
  required BuildContext context,
  required String message,
  Duration duration = const Duration(seconds: 3),
}) {
  toastification.show(
    context: context,
    title: Text(message),
    autoCloseDuration: duration,
    dragToClose: true,
    style: ToastificationStyle.flatColored,
    type: ToastificationType.error,
  );
}
