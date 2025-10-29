import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kwik_port/api/controller/authApi/update_user_api.dart';
import 'package:kwik_port/api/controller/home/dashboard_api.dart';
import 'package:kwik_port/api/model/userModel.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/button/back_nav_header.dart';
import 'package:kwik_port/utils/button/icon_text_button.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/button/loading_dialog.dart';
import 'package:kwik_port/utils/text/header_subtitle_text.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:kwik_port/utils/textFields/emailField_column.dart';
import 'package:kwik_port/utils/textFields/nameField_column.dart';
import 'package:kwik_port/utils/textFields/passwordField_column.dart';
import 'package:kwik_port/utils/textFields/phoneNumber_field.dart';
import 'package:kwik_port/utils/toast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController(
    // text: "",
  );
  TextEditingController phoneNumberController = TextEditingController();

  FocusNode phoneNumberFocusNode = FocusNode();
  String flag = "assets/images/icons/Indonesia (ID).png";
  String dialCode = 'NG';
  bool _isvisible = false;
  // int countryNumLength = 9;
  bool countList = false;
  String emailVal = '';
  String fullnameVal = '';
  String passwordVal = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController.text = userDataVar?.email ?? '';
    fullnameController.text =
        "${userDataVar?.firstName ?? ''} ${userDataVar?.lastName ?? ''}";
    // passwordController==userDataVar?.;
    phoneNumberController.text = userDataVar?.phoneNumber ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final updateUserProvider = Provider.of<UpdateUserApi>(
      context,
      listen: false,
    );
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

                // countryNumLength + 1,
                (value) {
                  // if (value.startsWith("0")) {
                  //   phoneNumberController.value = TextEditingValue(
                  //     text: value.substring(1),
                  //   );
                  // }
                  // if (phoneNumberController.text.length > countryNumLength) {
                  //   phoneNumberController.text = phoneNumberController.text
                  //       .substring(0, countryNumLength);
                  // }
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
              kwikbutton("Save", () => saveFunc(updateUserProvider)),
            ],
          ),
        ],
      ),
    );
  }

  saveFunc(UpdateUserApi updateUserProvider) async {
    FocusScope.of(context).unfocus();

    final prefs = await SharedPreferences.getInstance();
    final userSessionStr = prefs.getString('userSession');
    final dashboardApi = Provider.of<DashboardApi>(context, listen: false);
    final dashboardUserId = dashboardApi.data?.userProfile?.id;
    if (userSessionStr == null) {
      showToastContainer(
        "User not found",
        "Please log in again.",
        colorCodes.mistyRose,
        colorCodes.portlandOrange,
        context,
      );
      return;
    }

    final userSession = UserSession.fromJson(jsonDecode(userSessionStr));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LoadingDialog();
      },
    );
    // Show loading indicator while saving
    updateUserProvider
        .updateUser(
          id: dashboardUserId ?? '',
          firstName: fullnameController.text.split(' ').first,
          lastName:
              fullnameController.text.split(' ').length > 1
                  ? fullnameController.text.split(' ').last
                  : '',
          phoneNumber: phoneNumberController.text,
          email: emailController.text,
        )
        .then((_) async {
          Navigator.pop(context);
          if (updateUserProvider.success) {
            // ✅ Update local userDataVar
            // ✅ Update global session
            userDataVar = userDataVar?.copyWith(
              firstName: fullnameController.text.split(' ').first,
              lastName:
                  fullnameController.text.split(' ').length > 1
                      ? fullnameController.text.split(' ').last
                      : '',
              phoneNumber: phoneNumberController.text,
              email: emailController.text,
            );

            // ✅ Save updated session persistently
            await saveUserSession(userDataVar!);

            // ✅ Persist updated session locally
            await prefs.setString(
              'userSession',
              jsonEncode(userDataVar?.toJson()),
            );

            // ✅ Show success dialog
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 24, width: 24),
                      Image.asset(
                        'assets/images/icons/success_login.png',
                        height: 96,
                        width: 113,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pop(context, true);
                        },
                        child: Image.asset(
                          "assets/images/icons/close-circle.png",
                          height: 24,
                          width: 24,
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
                );
              },
            );
          } else {
            showToastContainer(
              "User Update",
              updateUserProvider.message,
              colorCodes.mistyRose,
              colorCodes.portlandOrange,
              context,
            );
          }
        });
    await Provider.of<DashboardApi>(
      context,
      listen: false,
    ).refreshUserFromPrefs();
  }
}

// kwikbutton("Save", () async {
//   final updateApi = Provider.of<UpdateUserApi>(context, listen: false);

//   bool success = await updateApi.updateUser(
//     id: "yourUserIdHere", // ideally from user provider or local storage
//     firstName: fullnameController.text.split(' ').first,
//     lastName: fullnameController.text.split(' ').last,
//     phoneNumber: phoneNumberController.text,
//     image: "", // TODO: integrate image picker if needed
//   );

//   if (success) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Success"),
//         content: Text(updateApi.message),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.pop(context);
//             },
//             child: const Text("OK"),
//           ),
//         ],
//       ),
//     );
//   } else {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Failed"),
//         content: Text(updateApi.message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("OK"),
//           ),
//         ],
//       ),
//
