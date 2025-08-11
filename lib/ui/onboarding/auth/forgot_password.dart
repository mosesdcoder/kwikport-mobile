import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/onboarding/auth/Reset_password_screen.dart';
import 'package:kwik_port/ui/onboarding/auth/confirm_otp_screen.dart';
import 'package:kwik_port/utils/button/backNav_button.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/header_subtitle_text.dart';
import 'package:kwik_port/utils/textFields/emailField_column.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  String emailVal = '';

  bool validateEmailBool(String email) {
    // Regular exchangion pattern for email validation
    final pattern = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  void validateEmail() {
    String emailValidator = emailController.text;
    bool isValid = validateEmailBool(emailValidator);

    if (isValid || emailValidator == "") {
      setState(() {
        emailVal = '';
      });
    } else {
      setState(() {
        emailVal = 'Email address invalid';
      });
    }
  }

  String? firstName = '';
  @override
  void initState() {
    super.initState();

    emailController.addListener(validateEmail);
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
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
                  children: [
                    backnavButton(context),
                    SizedBox(height: 27),
                    headerSubtitleDescription(
                      'Forgot Password?',
                      'Enter your email . A password reset link will be sent.',
                    ),
                    SizedBox(height: 32),
                    emailFieldColumn(emailVal, emailController),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: kwikbutton(
                    'Confirm Code',
                    () {
                      if (emailController.text.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ConfirmOtpScreen(
                                  screen: ResetPasswordScreen(),

                                  email: emailController.text,
                                ),
                          ),
                        );
                      }
                      // else {}
                    },

                    enabled: emailController.text.isNotEmpty ? true : false,
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
