import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:kwik_port/api/controller/authApi/createExportProfileApi.dart';
import 'package:kwik_port/api/model/userModel.dart';
import 'package:kwik_port/api/utils/loader.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/main.dart';
import 'package:kwik_port/ui/onboarding/auth/profile_setup_success.dart';
import 'package:kwik_port/utils/button/backNav_button.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/header_subtitle_text.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:kwik_port/utils/text/validationtext.dart';
import 'package:kwik_port/utils/textFields/nameField_column.dart';
import 'package:kwik_port/utils/toast.dart';
import 'package:provider/provider.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  TextEditingController fullNamecontroller = TextEditingController();
  TextEditingController bussinessNamecontroller = TextEditingController();
  var _image;
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
    final createProfliePRovider = Provider.of<CreateExportProfileApi>(context);
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

                    // nameFieldColumn(
                    //   nameerrorText,
                    //   fullNamecontroller,
                    //   title: "Username",
                    // ),
                    // nameerrorText == ""
                    //     ? Container()
                    //     : validationtext(nameerrorText),
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
                                height: 12,
                                width: 12,
                              )
                              : SizedBox(),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: kwikbutton(
                    'Proceed & generate export ID',
                    () => proceedFunc(createProfliePRovider),

                    enabled:
                        // fullNamecontroller.text.isNotEmpty &&
                        bussinessNamecontroller.text.isNotEmpty ? true : false,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  proceedFunc(CreateExportProfileApi createProfliePRovider) async {
    // String fullName =
    //     "${userDataVar.data.firstName} ${userDataVar.data.lastName} ${userDataVar.data.otherName ?? ""}"
    // .trim();
    if (bussinessNamecontroller.text.isNotEmpty) {
      showLoader(context: context);
      createProfliePRovider
          .createExportProfile(
            bussinessNamecontroller.text,
            // fullName,
            "",
            "",
            "",
            "",
            "",

            _image,
            context,
          )
          .then((value) {
            Loader.hide();
            if (createProfliePRovider.profileCreationSuccess) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileSetupSuccess()),
              );

              currentIndex = 1;
            } else {
              // Show error message if profile creation failed
              showToastContainer(
                "Failed To Create Profile",
                createProfliePRovider.message,
                colorCodes.mistyRose,
                colorCodes.portlandOrange,
                context,
              );
            }
          });
    } else {}
  }
}
