import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/button/dropdown_button.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:kwik_port/utils/textFields/nameField_column.dart';

class BussinessInformation extends StatefulWidget {
  final submitFunc, previousFunc;

  const BussinessInformation({
    super.key,
    required this.submitFunc,
    required this.previousFunc,
  });

  @override
  State<BussinessInformation> createState() => _BussinessInformationState();
}

class _BussinessInformationState extends State<BussinessInformation> {
  TextEditingController bussinessnamecontroller = TextEditingController();
  TextEditingController bussinessRegistratinNumber = TextEditingController();
  TextEditingController bussinessAddresscontroller = TextEditingController();
  String? bussinessType;
  bool isiconExpanded = false;
  bool isdropdownExpanded = false;
  String? exportExperience;
  bool exportExperienceiconExpanded = false;
  bool exportExperiencedropdownExpanded = false;

  List<String> bussinessTypeList = [
    'Nigerian',
    'Kenyan',
    'Ghanian',
    'American',
    'Other',
  ];
  List<String> exportExperienceList = [
    'Nigerian',
    'Kenyan',
    'Ghanian',
    'American',
    'Other',
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 970,
      width: 391,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: Column(
          children: [
            Container(
              height: 755,
              width: 391,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: colorCodes.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/icons/dashboard/Frame 1000006029 (3).png",
                        height: 25,
                        width: 25,
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Business Information",
                            style: kwikTextStlye(
                              18.0,
                              FontWeight.w600,
                              colorCodes.black,
                            ),
                          ),
                          Text(
                            "Tell us about your export business",
                            style: kwikTextStlye(
                              12.0,
                              FontWeight.w300,
                              colorCodes.graniteGrey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 25),

                  kycnameFieldColumn(
                    "Business Name",
                    "",
                    bussinessnamecontroller,
                    hintText: "Peter Walker",
                  ),

                  SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Type of Business",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: colorCodes.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  kycNationalityDropdown(
                    bussinessType,
                    "Select certification type",
                    bussinessTypeList.map(dropMenuItem).toList(),
                    (newValue) {
                      setState(() {
                        bussinessType = newValue;
                      });
                    },
                    (isOpen) {
                      setState(() {
                        isiconExpanded = isOpen;
                        isdropdownExpanded = isOpen;
                      });
                    },
                  ),

                  SizedBox(height: 15),
                  SizedBox(
                    height: 152,
                    width: 351,
                    child: kycnameFieldColumn(
                      "Business Address",
                      "",
                      bussinessAddresscontroller,
                      hintText: "123 Main Street, Lagos",
                      maxLines: 5,
                      // maxLength: 200,
                    ),
                  ),
                  SizedBox(height: 15),
                  kycnameFieldColumn(
                    "Business Registration Number (optional)",
                    "",
                    bussinessRegistratinNumber,
                    hintText: "Peter Walker",
                  ),
                  SizedBox(height: 15),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Export Experience",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: colorCodes.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  kycNationalityDropdown(
                    exportExperience,
                    "Select",
                    exportExperienceList.map(dropMenuItem).toList(),
                    (newValue) {
                      setState(() {
                        exportExperience = newValue;
                      });
                    },
                    (isOpen) {
                      setState(() {
                        isiconExpanded = isOpen;
                        isdropdownExpanded = isOpen;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  Container(
                    height: 119,
                    width: 351,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: colorCodes.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        width: 1.5,
                        color: colorCodes.paleCornflowerBlue,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/images/icons/dashboard/Frame 1000006022.png",
                          height: 20,
                          width: 20,
                        ),
                        SizedBox(width: 6),
                        SizedBox(
                          width: 274,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Why We Need This Information",
                                style: kwikTextStlye(
                                  14.0,
                                  FontWeight.w600,
                                  colorCodes.black,
                                ),
                              ),
                              Text(
                                "This helps us understand your business needs and provide better export financing and support services.",
                                textAlign: TextAlign.start,
                                style: kwikTextStlye(
                                  12.0,
                                  FontWeight.w300,
                                  colorCodes.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Container(
              height: 85,
              width: 391,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: colorCodes.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  width: 1.5,
                  color: colorCodes.paleCornflowerBlue,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/images/icons/dashboard/Frame 1000006029.png",
                    height: 20,
                    width: 20,
                  ),
                  SizedBox(width: 6),
                  SizedBox(
                    width: 314,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Security Notice",
                          style: kwikTextStlye(
                            14.0,
                            FontWeight.w600,
                            colorCodes.black,
                          ),
                        ),
                        Text(
                          "Your information is encrypted and stored securely. We comply with all data protection regulations.",
                          textAlign: TextAlign.start,
                          style: kwikTextStlye(
                            12.0,
                            FontWeight.w300,
                            colorCodes.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 38,
                  width: 140,
                  child: kwikbutton(
                    "Previous",
                    widget.previousFunc,
                    backgroundcolor: colorCodes.white,
                    textColor: colorCodes.black,
                    borderColor: colorCodes.antiFlashWhite,
                    fontSize: 12.0,
                  ),
                ),
                SizedBox(
                  height: 38,
                  width: 140,
                  child: kwikbutton(
                    "Submit KYC",
                    widget.submitFunc,
                    fontSize: 12.0,
                    buttonChild: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Submit KYC",
                          style: kwikTextStlye(
                            14.0,
                            FontWeight.w500,
                            colorCodes.whiteSmoke,
                          ),
                        ),
                        SizedBox(width: 8),
                        Image.asset(
                          "assets/images/icons/arrow-right.png",
                          height: 18,
                          width: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  DropdownMenuItem<String> dropMenuItem(value) {
    return DropdownMenuItem(
      value: value,
      child: Text(
        value,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
          color: colorCodes.black,
        ),
      ),
    );
  }
}
