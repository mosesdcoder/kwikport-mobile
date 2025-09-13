import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/onboarding/account_create_sucess.dart';
import 'package:kwik_port/ui/onboarding/auth/profile_setup_screen.dart';
import 'package:kwik_port/utils/button/backNav_button.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/containers/otp_container.dart';
import 'package:kwik_port/utils/text/header_subtitle_text.dart';
import 'package:kwik_port/utils/toast.dart';

class ConfirmOtpScreen extends StatefulWidget {
  final email, screen;
  const ConfirmOtpScreen({
    super.key,
    required this.email,
    required this.screen,
  });

  @override
  State<ConfirmOtpScreen> createState() => _ConfirmOtpScreenState();
}

class _ConfirmOtpScreenState extends State<ConfirmOtpScreen> {
  TextEditingController pinController = TextEditingController(text: "");
  int endTime = DateTime.now().millisecondsSinceEpoch + 300000; // 5 minutes
  String emailOtpVal = '';
  int pinLength = 6;
  bool hasError = false;
  late String errorMessage;
  Color colorText = colorCodes.jetBlack;
  Color defaultBorderColor = colorCodes.jetBlack;
  @override
  void initState() {
    super.initState();
    pinController.addListener(validateEmail);
  }

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  void validateEmail() {
    if (pinController.text.isEmpty || pinController.text.length < 6) {
      setState(() {
        emailOtpVal = '';
        colorText = colorCodes.black;
        defaultBorderColor = colorCodes.graniteGrey;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorCodes.whiteSmoke,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height - 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    backnavButton(context),
                    SizedBox(height: 27),
                    headerSubtitleDescriptionsmall(
                      'Confirm 6 Digit Code ',
                      'Enter the 6 digit code we have sent to your Email',
                    ),
                    SizedBox(height: 32),
                    otpContainer(
                      context,
                      pinController,
                      colorText,
                      defaultBorderColor,
                      pinLength,

                      (text) {
                        setState(() {
                          hasError = false;
                        });
                      },
                      () {},
                      endTime,
                      () {},
                      emailOtpVal,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: kwikbutton(
                    'Confirm Code',
                    () {
                      if (pinController.text.length == 6) {
                        // if (pinController.text != "123456") {
                        showToast(
                          'Oops! Invalid code .',
                          'Please double check and enter it correctly.',
                          colorCodes.mistyRose,
                          colorCodes.portlandOrange,
                          context,
                        );
                        // } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => widget.screen,
                          ),
                        );
                        // }
                      } else {}
                    },

                    enabled: pinController.text.length == 6 ? true : false,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
