import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/button/dropdown_button.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/containers/upload_image_container.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:kwik_port/utils/textFields/nameField_column.dart';

class DocumentVerification extends StatefulWidget {
  final nextFunc, previousFunc;
  const DocumentVerification({
    super.key,
    required this.nextFunc,
    required this.previousFunc,
  });

  @override
  State<DocumentVerification> createState() => _DocumentVerificationState();
}

class _DocumentVerificationState extends State<DocumentVerification> {
  String? certificatetionType;
  bool isiconExpanded = false;
  bool isdropdownExpanded = false;
  TextEditingController iDNumbercontroller = TextEditingController();
  List<String> certificatetionTypeList = [
    'Nigerian',
    'Kenyan',
    'Ghanian',
    'American',
    'Other',
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 990,
      width: 391,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: Column(
          children: [
            Container(
              height: 865,
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
                            "Document Verification",
                            style: kwikTextStlye(
                              18.0,
                              FontWeight.w600,
                              colorCodes.black,
                            ),
                          ),
                          Text(
                            "Upload required identity documents",
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
                  Container(
                    height: 109,
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
                          "assets/images/icons/dashboard/Frame 1000006029.png",
                          height: 20,
                          width: 20,
                        ),
                        SizedBox(width: 6),
                        SizedBox(
                          width: 280,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Document Security",
                                style: kwikTextStlye(
                                  14.0,
                                  FontWeight.w600,
                                  colorCodes.black,
                                ),
                              ),
                              Text(
                                "Your documents are encrypted and securely stored. We only use them for identity verification.",
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
                  SizedBox(height: 25),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Quality Certification",
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
                    certificatetionType,
                    "Select certification type",
                    certificatetionTypeList.map(dropMenuItem).toList(),
                    (newValue) {
                      setState(() {
                        certificatetionType = newValue;
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
                  kycnameFieldColumn(
                    "ID Number",
                    "",
                    iDNumbercontroller,
                    hintText: "Peter Walker",
                  ),
                  SizedBox(height: 15),
                  uploadImageContainer("Upload ID Document", () {}),
                  SizedBox(height: 15),
                  uploadImageContainer("Proof of Address", () {}),
                ],
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 38,
                  width: 150,
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
                  width: 150,
                  child: kwikbutton(
                    "Next",
                    widget.nextFunc,
                    fontSize: 12.0,
                    buttonChild: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Next",
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
