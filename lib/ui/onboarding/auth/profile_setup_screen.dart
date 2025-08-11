import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/onboarding/auth/profile_setup_success.dart';
import 'package:kwik_port/utils/button/backNav_button.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/header_subtitle_text.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:kwik_port/utils/text/validationtext.dart';
import 'package:kwik_port/utils/textFields/nameField_column.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  TextEditingController fullNamecontroller = TextEditingController();
  TextEditingController bussinessNamecontroller = TextEditingController();

  String nameerrorText = "";
  String buserrorText = "";
  void validate() {
    if (bussinessNamecontroller.text.length >= 5) {
      setState(() {});
    }
  }

  @override
  void initState() {
    bussinessNamecontroller.addListener(validate);
    super.initState();
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
                      "You're in! Let's set up your exporter profile.",
                      'Enter your details below to set up your profile',
                    ),
                    SizedBox(height: 32),
                    nameFieldColumn(nameerrorText, fullNamecontroller),
                    nameerrorText == ""
                        ? Container()
                        : validationtext(nameerrorText),

                    SizedBox(height: 16),
                    nameFieldColumn(
                      buserrorText,
                      bussinessNamecontroller,
                      title: "Your Export Business Name",
                      hintText: "",
                      suffixIcon:
                          bussinessNamecontroller.text.isNotEmpty
                              ? Image.asset(
                                'assets/images/icons/Checkbox.png',
                                height: 16,
                                width: 16,
                              )
                              : SizedBox(),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: kwikbutton(
                    'Proceed & generate export ID',
                    () {
                      if (fullNamecontroller.text.isNotEmpty &&
                          bussinessNamecontroller.text.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileSetupSuccess(),
                          ),
                        );
                      } else {}
                    },

                    enabled:
                        fullNamecontroller.text.isNotEmpty &&
                                bussinessNamecontroller.text.isNotEmpty
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
