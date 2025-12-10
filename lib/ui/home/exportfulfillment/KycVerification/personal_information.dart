import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/button/dropdown_button.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:kwik_port/utils/textFields/date_of_birth_field.dart';
import 'package:kwik_port/utils/textFields/emailField_column.dart';
import 'package:kwik_port/utils/textFields/nameField_column.dart';
import 'package:kwik_port/utils/textFields/phoneNumber_field.dart';

class PersonalInformation extends StatefulWidget {
  final nextFunc;
  const PersonalInformation({super.key, required this.nextFunc});

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController firstNamecontroller = TextEditingController();
  TextEditingController lastNamecontroller = TextEditingController();
  TextEditingController phonenumbercontroller = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController streetAddresscontroller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();

  String? nationality;
  bool isiconExpanded = false;
  bool isdropdownExpanded = false;
  bool _isFormValid = false;

  List<String> nationalityList = [
    'Nigerian',
    'Kenyan',
    'Ghanian',
    'American',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    firstNamecontroller.addListener(_validateForm);
    lastNamecontroller.addListener(_validateForm);
    emailcontroller.addListener(_validateForm);
    phonenumbercontroller.addListener(_validateForm);
    dobController.addListener(_validateForm);
    streetAddresscontroller.addListener(_validateForm);
    cityController.addListener(_validateForm);
    stateController.addListener(_validateForm);
  }

  @override
  void dispose() {
    firstNamecontroller.removeListener(_validateForm);
    lastNamecontroller.removeListener(_validateForm);
    emailcontroller.removeListener(_validateForm);
    phonenumbercontroller.removeListener(_validateForm);
    dobController.removeListener(_validateForm);
    streetAddresscontroller.removeListener(_validateForm);
    cityController.removeListener(_validateForm);
    stateController.removeListener(_validateForm);

    firstNamecontroller.dispose();
    lastNamecontroller.dispose();
    emailcontroller.dispose();
    phonenumbercontroller.dispose();
    dobController.dispose();
    streetAddresscontroller.dispose();
    cityController.dispose();
    stateController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final bool isFormValid = firstNamecontroller.text.isNotEmpty &&
        lastNamecontroller.text.isNotEmpty &&
        emailcontroller.text.isNotEmpty &&
        phonenumbercontroller.text.isNotEmpty &&
        dobController.text.isNotEmpty &&
        streetAddresscontroller.text.isNotEmpty &&
        cityController.text.isNotEmpty &&
        stateController.text.isNotEmpty &&
        nationality != null;
    if (_isFormValid != isFormValid) {
      setState(() {
        _isFormValid = isFormValid;
      });
    }
  }

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
              height: 830,
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
                            "Personal Information",
                            style: kwikTextStlye(
                              18.0,
                              FontWeight.w600,
                              colorCodes.black,
                            ),
                          ),
                          Text(
                            "Provide your basic personal details",
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 129,
                        child: kycnameFieldColumn(
                          "First Name",
                          "", hintText: "John",
                          firstNamecontroller,
                        ),
                      ),
                      SizedBox(
                        width: 129,
                        child: kycnameFieldColumn(
                          "Last Name",
                          "",
                          hintText: "Doe",
                          lastNamecontroller,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  kycemailFieldColumn("", emailcontroller),
                  SizedBox(height: 15),
                  kycphonenumberFieldColumn("", phonenumbercontroller),
                  SizedBox(height: 15),
                  dateofbirthTxtField(
                    "Date of Birth",
                    dobController,
                    "",
                    () async {
                      var date = DateTime.now();
                      DateTime? dateofBirth = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().subtract(
                          Duration(days: 18 * 365),
                        ),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now().subtract(
                          Duration(days: 18 * 365),
                        ),
                      );
                      if (dateofBirth != null) {
                        setState(() {
                          dobController.text = DateFormat(
                            'dd/MM/yyyy',
                          ).format(dateofBirth);
                        });
                      }
                    },
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    height: 152,
                    width: 351,
                    child: kycnameFieldColumn(
                      "Street Address",
                      "",
                      streetAddresscontroller,
                      hintText: "123 Main Street, Lagos",
                      maxLines: 5,
                      // maxLength: 200,
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 129,
                        child: kycnameFieldColumn(
                          "City",
                          "",
                          cityController,
                          hintText: "Lagos",
                        ),
                      ),
                      SizedBox(
                        width: 129,
                        child: kycnameFieldColumn(
                          "State",
                          "",
                          stateController,
                          hintText: "Lagos",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Nationality",
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
                    nationality,
                    "Select nationality",
                    nationalityList.map(dropMenuItem).toList(),
                    (newValue) {
                      setState(() {
                        nationality = newValue;
                      });
                      _validateForm();
                    },
                    (isOpen) {
                      setState(() {
                        isiconExpanded = isOpen;
                        isdropdownExpanded = isOpen;
                      });
                    },
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
                    "Cancel",
                    () {
                      Navigator.pop(context);
                    },
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
                    "Next",
                    _isFormValid ? widget.nextFunc : null,
                    enabled: _isFormValid,
                    fontSize: 12.0,
                    buttonChild: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Next",
                          style: kwikTextStlye(
                            14.0,
                            FontWeight.w500,
                            _isFormValid
                                ? colorCodes.whiteSmoke
                                : colorCodes.aluminium,
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
      child: Row(
        children: [
          Image.asset(
            "assets/images/icons/dashboard/Frame 1000006029 (3).png",
            height: 25,
            width: 25,
          ),
          SizedBox(width: 12),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 16.0,
              color: colorCodes.black,
            ),
          ),
        ],
      ),
    );
  }
}
