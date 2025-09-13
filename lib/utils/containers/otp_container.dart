import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:kwik_port/utils/text/validationtext.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

Widget otpContainer(
  context,

  pinController,
  colorText,
  defaultBorderColor,
  pinLength,
  onTextChanged,
  resendcodeFunc,

  endTime,
  onEnd,
  errorText,
) {
  return Align(
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // expiryWidget,
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 41,
                height: 75,
                child: PinCodeTextField(
                  length: pinLength,
                  appContext: context,
                  showCursor: true,
                  cursorColor: colorCodes.azureBlue,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),

                    fieldHeight: 62,
                    fieldWidth: 52,
                    activeFillColor: Colors.white,
                    // fieldOuterPadding: const EdgeInsets.all(5),
                    // errorBorderColor: colorText,
                    borderWidth: 1.4,

                    selectedColor: colorText,
                    activeColor: colorText,
                    inactiveColor: colorCodes.graniteGrey.withOpacity(0.4),
                  ),
                  onChanged: onTextChanged,
                  autoFocus: true,
                  controller: pinController,
                  backgroundColor: colorCodes.whiteSmoke,

                  textStyle: TextStyle(
                    fontSize: 32.0,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: colorText,
                  ),
                  // pinTextAnimatedSwitcherTransition:
                  //     ProvidedPinBoxTextAnimation.scalingTransition,
                  //                    pinBoxColor: Colors.green[100],
                  // pinTextAnimatedSwitcherDuration:
                  //     const Duration(milliseconds: 200),
                  //                    highlightAnimation: true,
                  // highlightAnimationBeginColor: Colors.black,
                  // highlightAnimationEndColor: Colors.white12,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.0),

        Row(
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: colorCodes.black,
                ),
                children: [
                  TextSpan(text: "Didn't receive the code? "),
                  TextSpan(
                    recognizer:
                        TapGestureRecognizer()
                          ..onTap = () {
                            resendcodeFunc();
                          },
                    text: 'Resend in',
                    style: TextStyle(color: colorCodes.graniteGrey),
                  ),
                ],
              ),
            ),
            CountdownTimer(
              endTime: endTime,
              endWidget: Center(
                child: Text(
                  ' Expired',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: colorCodes.graniteGrey,
                  ),
                ),
              ),
              textStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: colorCodes.graniteGrey,
              ),
              onEnd: onEnd,
              // () {
              //   setState(() {
              //     timerActive = false;
              //   });
              // },
            ),
          ],
        ),
      ],
    ),
  );
}
