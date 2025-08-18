import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/button/back_nav_header.dart';
import 'package:kwik_port/utils/button/icon_text_button.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/header_subtitle_text.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:kwik_port/utils/textFields/emailField_column.dart';
import 'package:kwik_port/utils/textFields/nameField_column.dart';
import 'package:kwik_port/utils/textFields/passwordField_column.dart';
import 'package:kwik_port/utils/textFields/phoneNumber_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController emailController = TextEditingController(
    text: "Johngbenga@gmail.com",
  );
  TextEditingController fullnameController = TextEditingController(
    text: "John Gbenga",
  );
  TextEditingController passwordController = TextEditingController(
    text: "JohnGbenga",
  );
  TextEditingController phoneNumberController = TextEditingController(
    text: "8109957139",
  );

  FocusNode phoneNumberFocusNode = FocusNode();
  String flag = "assets/images/icons/Indonesia (ID).png";
  String dialCode = '254';
  bool _isvisible = false;
  int countryNumLength = 9;
  bool countList = false;
  String emailVal = '';
  String fullnameVal = '';
  String passwordVal = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorCodes.whiteSmoke,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              backNavRow(context, "Edit Profile"),
              SizedBox(height: 32.0),
              headerSubtitleDescriptionsmall(
                "Personal Information",
                "Your personal information and account security settings.",
              ),
              SizedBox(height: 16.0),
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/Profile.png",
                  height: 69,
                  width: 69,
                ),
              ),
              SizedBox(height: 13.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 38,
                    width: 116,
                    child: iconTextButton(
                      "Remove",
                      "assets/images/icons/trash.png",
                      () {},
                      colorCodes.portlandOrange,
                      colorCodes.portlandOrange,
                      textColor: colorCodes.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  SizedBox(
                    height: 38,
                    width: 116,
                    child: iconTextButton(
                      "Change",
                      "assets/images/icons/edit-2.png",
                      () {},
                      colorCodes.white,
                      colorCodes.antiFlashWhite,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 36),
              nameFieldColumn(fullnameVal, fullnameController, title: ""),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Phone Number",
                  style: kwikTextStlye(14.0, FontWeight.w500, colorCodes.black),
                ),
              ),
              SizedBox(height: 8),
              phoneTextfield(
                phoneNumberFocusNode,
                phoneNumberController,
                flag,
                dialCode,
                () async {
                  setState(() {
                    countList = !countList;
                  });
                },
                countryNumLength + 1,

                (value) {
                  if (value.startsWith("0")) {
                    phoneNumberController.value = TextEditingValue(
                      text: value.substring(1),
                    );
                  }
                  if (phoneNumberController.text.length > countryNumLength) {
                    phoneNumberController.text = phoneNumberController.text
                        .substring(0, countryNumLength);
                  }
                },
                context,
              ),
              emailFieldColumn(emailVal, emailController),
              SizedBox(height: 16),
              passwordtextFieldColumn(
                passwordVal,
                passwordController,
                _isvisible,
                () {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    _isvisible = !_isvisible;
                  });
                },
                context,
              ),
              SizedBox(height: 66),
              kwikbutton("Save", () {
                showDialog(
                  barrierDismissible: false,
                  context: context,

                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(height: 24, width: 24),
                          Column(
                            children: [
                              SizedBox(height: 8),
                              Image.asset(
                                'assets/images/icons/success_login.png',
                                height: 96,
                                width: 113,
                              ),
                            ],
                          ),
                          // SizedBox(width: 46),
                          Align(
                            alignment: Alignment.topRight,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                // Navigator.popUntil(context, (route) {
                                //   return route.settings.name == 'ProfileScreen';
                                // });
                              },
                              child: Image.asset(
                                "assets/images/icons/close-circle.png",
                                height: 24,
                                width: 24,
                              ),
                            ),
                          ),
                        ],
                      ),

                      content: Text(
                        "Edit saved!",
                        textAlign: TextAlign.center,
                        style: kwikTextStlye(
                          24.0,
                          FontWeight.w600,
                          colorCodes.black,
                        ),
                      ),
                      actions: [
                        Column(
                          children: [
                            Text(
                              "Your changes have been saved successfully.",
                              textAlign: TextAlign.center,
                              style: kwikTextStlye(
                                14.0,
                                FontWeight.w300,
                                colorCodes.graniteGrey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
