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
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController dobController;
  final TextEditingController streetAddressController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final String? nationality;
  final Function(String?) onNationalityChanged;

  final VoidCallback nextFunc;
  // final nextFunc;
  const PersonalInformation({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.dobController,
    required this.streetAddressController,
    required this.cityController,
    required this.stateController,
    required this.nationality,
    required this.onNationalityChanged,
    required this.nextFunc,
  });

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  // TextEditingController emailcontroller = TextEditingController();
  // TextEditingController firstNamecontroller = TextEditingController();
  // TextEditingController lastNamecontroller = TextEditingController();
  // TextEditingController phonenumbercontroller = TextEditingController();
  // TextEditingController dobController = TextEditingController();
  // TextEditingController streetAddresscontroller = TextEditingController();
  // TextEditingController cityController = TextEditingController();
  // TextEditingController stateController = TextEditingController();
  // String? nationality;
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
    widget.firstNameController.addListener(_validateForm);
    widget.lastNameController.addListener(_validateForm);
    widget.emailController.addListener(_validateForm);
    widget.phoneController.addListener(_validateForm);
    widget.dobController.addListener(_validateForm);
    widget.streetAddressController.addListener(_validateForm);
    widget.cityController.addListener(_validateForm);
    widget.stateController.addListener(_validateForm);
  }

  @override
  void dispose() {
    widget.firstNameController.removeListener(_validateForm);
    widget.lastNameController.removeListener(_validateForm);
    widget.emailController.removeListener(_validateForm);
    widget.phoneController.removeListener(_validateForm);
    widget.dobController.removeListener(_validateForm);
    widget.streetAddressController.removeListener(_validateForm);
    widget.cityController.removeListener(_validateForm);
    widget.stateController.removeListener(_validateForm);

    widget.firstNameController.dispose();
    widget.lastNameController.dispose();
    widget.emailController.dispose();
    widget.phoneController.dispose();
    widget.dobController.dispose();
    widget.streetAddressController.dispose();
    widget.cityController.dispose();
    widget.stateController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final bool isFormValid =
        widget.firstNameController.text.isNotEmpty &&
        widget.lastNameController.text.isNotEmpty &&
        widget.emailController.text.isNotEmpty &&
        widget.phoneController.text.isNotEmpty &&
        widget.dobController.text.isNotEmpty &&
        widget.streetAddressController.text.isNotEmpty &&
        widget.cityController.text.isNotEmpty &&
        widget.stateController.text.isNotEmpty &&
        widget.nationality != null;
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
                        width: 139,
                        child: kycnameFieldColumn(
                          "First Name",
                          "",
                          widget.firstNameController,
                          textColor: colorCodes.black,
                        ),
                      ),
                      SizedBox(
                        width: 139,
                        child: kycnameFieldColumn(
                          "Last Name",
                          "",
                          widget.lastNameController,
                          textColor: colorCodes.black,
                        ),
                      ),
                      kycemailFieldColumn(
                        "",
                        widget.emailController,
                        textColor: colorCodes.black,
                      ),
                      SizedBox(height: 15),
                      kycphonenumberFieldColumn(
                        "",
                        widget.phoneController,
                        textColor: colorCodes.black,
                      ),
                      SizedBox(height: 15),
                      dateofbirthTxtField(
                        "Date of Birth",
                        widget.dobController,
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
                              widget.dobController.text = DateFormat(
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
                          widget.streetAddressController,
                          hintText: "123 Main Street, Lagos",
                          maxLines: 5,
                          // maxLength: 200,
                          textColor: colorCodes.black,
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
                              widget.cityController,
                              hintText: "Lagos",
                              textColor: colorCodes.black,
                            ),
                          ),
                          SizedBox(
                            width: 129,
                            child: kycnameFieldColumn(
                              "State",
                              "",
                              widget.stateController,
                              hintText: "Lagos",
                              textColor: colorCodes.black,
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
                        widget.nationality,
                        "Select nationality",
                        nationalityList.map(dropMenuItem).toList(),
                        (value) {
                          widget.onNationalityChanged(value as String?);
                        }, // (newValue) {
                        //   setState(() {
                        //     widget.nationality = newValue;
                        //   });
                        // },
                        (isOpen) {
                          setState(() {
                            isiconExpanded = isOpen;
                            isdropdownExpanded = isOpen;
                          });
                        },
                      ),
                    ],
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
