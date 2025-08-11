import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/onboarding/account_create_sucess.dart';
import 'package:kwik_port/ui/onboarding/auth/login_screen.dart';
import 'package:kwik_port/utils/button/backNav_button.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/header_subtitle_text.dart';
import 'package:kwik_port/utils/textFields/passwordField_column.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  bool _isVisible = false;
  String passwordVal = '';
  bool _isconfirmVisible = false;
  String confirmpasswordVal = '';
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
                      'Reset Password?',
                      'Enter your new password ',
                    ),
                    SizedBox(height: 32),
                    passwordtextFieldColumn(
                      passwordVal,
                      passwordController,
                      _isVisible,
                      () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          _isVisible = !_isVisible;
                        });
                      },
                      context,
                    ),
                    SizedBox(height: 16),
                    passwordtextFieldColumn(
                      confirmpasswordVal,
                      confirmpasswordController,
                      _isconfirmVisible,
                      () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          _isconfirmVisible = !_isconfirmVisible;
                        });
                      },
                      context,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: kwikbutton(
                    'Save new password',
                    () {
                      if (passwordController.text.isNotEmpty &&
                          confirmpasswordController.text.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => AccountCreateSucess(
                                  img:
                                      "assets/images/icons/password_success.png",
                                  text: "Password Updated!",
                                  buttonText: "Back to login",
                                  buttonFunc: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginScreen(),
                                      ),
                                    );
                                  },
                                  subText:
                                      "Password update successfully. Please login again.",
                                ),
                          ),
                        );
                      } else {}
                    },

                    enabled:
                        passwordController.text.isNotEmpty &&
                                confirmpasswordController.text.isNotEmpty
                            ? true
                            : false,
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
