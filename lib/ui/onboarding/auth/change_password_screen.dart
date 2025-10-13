import 'package:flutter/material.dart';
import 'package:kwik_port/api/controller/authApi/change_password_api.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/home/profile/profile_screen.dart';
import 'package:kwik_port/ui/onboarding/account_create_sucess.dart';
import 'package:kwik_port/utils/button/backNav_button.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/button/loading_dialog.dart';
import 'package:kwik_port/utils/text/header_subtitle_text.dart';
import 'package:kwik_port/utils/textFields/passwordField_column.dart';
import 'package:kwik_port/utils/toast.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController currentpasswordController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  bool _isVisible = false;
  String passwordVal = '';
  bool _isconfirmVisible = false;
  bool _iscurrentVisible = false;
  String confirmpasswordVal = '';
  String currentpasswordVal = '';
  @override
  Widget build(BuildContext context) {
    final changePasswordProvider = Provider.of<ChangePasswordApi>(
      context,
      listen: false,
    );
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
                      'Change Password?',
                      'Enter your current password ',
                    ),
                    SizedBox(height: 32),
                    passwordtextFieldColumn(
                      currentpasswordVal,
                      currentpasswordController,
                      _iscurrentVisible,
                      () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          _iscurrentVisible = !_iscurrentVisible;
                        });
                      },
                      context,
                      title: "Current Password",
                    ),
                    SizedBox(height: 16),
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
                      title: "New Password",
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
                      title: "Confirm New Password",
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: kwikbutton(
                    'Change password',
                    () {
                      if (passwordController.text.isNotEmpty &&
                          confirmpasswordController.text.isNotEmpty) {
                        LoadingDialog();
                        changePasswordProvider
                            .changePassword(
                              currentpasswordController.text,
                              passwordController.text,
                              confirmpasswordController.text,
                              context,
                            )
                            .then((_) {
                              Navigator.pop(context);
                              if (changePasswordProvider.success) {
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
                                                builder:
                                                    (context) =>
                                                        ProfileScreen(),
                                              ),
                                            );
                                          },
                                          subText:
                                              "Password update successfully. Please login again.",
                                        ),
                                  ),
                                );
                              } else {
                                showToastContainer(
                                  "Error",
                                  changePasswordProvider.message,
                                  colorCodes.mistyRose,
                                  colorCodes.portlandOrange,
                                  context,
                                );
                              }
                            });
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
