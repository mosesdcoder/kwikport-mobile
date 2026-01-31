import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:kwik_port/api/controller/authApi/verifyEmailApi.dart';
import 'package:kwik_port/api/utils/loader.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/onboarding/account_create_sucess.dart';
import 'package:kwik_port/ui/onboarding/auth/Reset_password_screen.dart';
import 'package:kwik_port/ui/onboarding/auth/profile_setup_screen.dart';
import 'package:kwik_port/utils/button/backNav_button.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/containers/otp_container.dart';
import 'package:kwik_port/utils/text/header_subtitle_text.dart';
import 'package:kwik_port/utils/toast.dart';
import 'package:provider/provider.dart';

class ConfirmOtpScreen extends StatefulWidget {
  final email, sessionHash;
  final String flowType; // "signup" or "forgotPassword"
  const ConfirmOtpScreen({
    super.key,
    required this.email,
    // required this.screen,
    this.sessionHash,
    required this.flowType,
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
    final verifyEmailProvider = Provider.of<VerifyEmailApi>(context);
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
                    SizedBox(height: 32),
                    kwikbutton(
                      'Confirm Code',
                      () => verifyEmailFunction(verifyEmailProvider),

                      // () {
                      //   if (pinController.text.length == 6) {
                      //     // if (pinController.text != "123456") {
                      //     showToastContainer(
                      //       'Oops! Invalid code .',
                      //       'Please double check and enter it correctly.',
                      //       colorCodes.mistyRose,
                      //       colorCodes.portlandOrange,
                      //       context,
                      //     );
                      //     // } else {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => widget.screen,
                      //       ),
                      //     );
                      //     // }
                      //   } else {}
                      // },
                      enabled: pinController.text.length == 6 ? true : false,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  verifyEmailFunction(VerifyEmailApi verifyEmailProvider) async {
    if (pinController.text.length != 6) {
      setState(() {
        emailOtpVal = 'Please enter all OTP codes';
        defaultBorderColor = colorCodes.portlandOrange;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter all OTP codes'),
          backgroundColor: colorCodes.portlandOrange,
          duration: Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 80,
          ),
        ),
      );
      return;
    }

    showLoader(context: context);

    if (widget.flowType == "signup") {
      // ✅ FLOW 1: Signup email verification
      await verifyEmailProvider.verifyEmail(
        pinController.text,
        widget.email,
        context,
      );
      Loader.hide();

      if (verifyEmailProvider.success) {
        showToastContainer(
          "Email Verification",
          verifyEmailProvider.message,
          colorCodes.pigmentGreen,
          colorCodes.mediumSeaGreen,
          context,
        );

        // Go to profile setup
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => AccountCreateSucess(
                  img: 'assets/images/icons/account_successimg.png',
                  text: 'Account created\nsucessfully!',
                  buttonText: "Continue",
                  buttonFunc: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileSetupScreen(),
                      ),
                    );
                  },
                  subText: "",
                ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(verifyEmailProvider.message),
            backgroundColor: colorCodes.portlandOrange,
            duration: Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 80,
            ),
          ),
        );
      }
    } else if (widget.flowType == "forgotPassword") {
      // ✅ FLOW 2: Forgot password verification
      Loader.hide();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => ResetPasswordScreen(
                email: widget.email,
                sessionHash: widget.sessionHash,
                otp: pinController.text,
              ),
        ),
      );
    }
  }

  //   verifyEmailFunction(VerifyEmailApi verifyEmailProvider) {
  //     if (pinController.text.length != 6) {
  //       setState(() {
  //         emailOtpVal = 'Please enter all OTP codes';
  //         defaultBorderColor = colorCodes.portlandOrange;
  //       });
  //     } else {
  //       setState(() {
  //         emailOtpVal = '';
  //         colorText = colorCodes.jetBlack;
  //       });
  //       showLoader(context: context);
  //       verifyEmailProvider
  //           .verifyEmail(pinController.text, widget.email, context)
  //           .then((_) {
  //             Loader.hide();
  //             // Navigator.pop(context);
  //             verifyEmailProvider.otpcode;
  //             if (verifyEmailProvider.success) {
  //               showToastContainer(
  //                 "Email Verification",
  //                 verifyEmailProvider.message,
  //                 colorCodes.pigmentGreen,
  //                 colorCodes.mediumSeaGreen,
  //                 context,
  //               );
  //               if (widget.screen == "ResetPassword") {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder:
  //                         (context) => ResetPasswordScreen(
  //                           email: widget.email,
  //                           sessionHash: widget.sessionHash,

  //                           otp: pinController.text,
  //                         ),
  //                   ),
  //                 );
  //               } else {
  //                 // Navigator.push(
  //                 //   context,
  //                 //   MaterialPageRoute(
  //                 //     builder: (context) => widget.screen,
  //                 AccountCreateSucess(
  //                   img: 'assets/images/icons/account_successimg.png',
  //                   text: 'Account created\nsucessfully!',
  //                   buttonText: "Continue",
  //                   buttonFunc: () {
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (context) => ProfileSetupScreen(),
  //                       ),
  //                     );
  //                   },
  //                   subText: "",
  //                 );
  //                 // ),
  //                 // (route) => false,
  //                 // );
  //                 // }
  //               }
  //             } else {
  //               showToastContainer(
  //                 "Verification Failed",
  //                 verifyEmailProvider.message,
  //                 colorCodes.mistyRose,
  //                 colorCodes.portlandOrange,
  //                 context,
  //               );
  //             }
  //           });
  //     }
  //   }
}
