import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/api/model/dashboard_model.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/home/dashboard/dashboard.dart';
import 'package:kwik_port/ui/home/exportfulfillment/KycVerification/bussiness_informatin.dart';
import 'package:kwik_port/ui/home/exportfulfillment/KycVerification/document_verification.dart';
import 'package:kwik_port/ui/home/exportfulfillment/KycVerification/identity_verification.dart';
import 'package:kwik_port/ui/home/exportfulfillment/KycVerification/kyc_successful_dialog.dart';
import 'package:kwik_port/ui/home/exportfulfillment/KycVerification/personal_information.dart';
import 'package:kwik_port/utils/button/back_nav_header.dart';
import 'package:kwik_port/utils/button/bottom_navigatior_bar.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

class KycVerificationScreen extends StatefulWidget {
  final KwikTicketModel kwikticket;

  const KycVerificationScreen({super.key, required this.kwikticket});

  @override
  State<KycVerificationScreen> createState() => _KycVerificationScreenState();
}

class _KycVerificationScreenState extends State<KycVerificationScreen> {
  double linearValue = 0.25;
  // Shared controllers and state for Personal Information
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController streetAddressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  String? nationality;
  // Document verification state
  String? certificationType;
  TextEditingController iDNumberController = TextEditingController();
  File? idDocumentFile;
  File? proofOfAddressFile;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dobController.dispose();
    streetAddressController.dispose();
    cityController.dispose();
    stateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 42.0, bottom: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: backNavRow(context, "KYC Verification"),
          ),
        ),
      ),
      backgroundColor: colorCodes.whiteSmoke,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LinearProgressIndicator(
                backgroundColor: HexColor("#D6E7FF"),
                minHeight: 8,
                value: linearValue,
                borderRadius: BorderRadius.circular(12),
                color: colorCodes.azureBlue,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getStepTitle(),
                    style: kwikTextStlye(
                      12.0,
                      FontWeight.w300,
                      colorCodes.darkGrey,
                    ),
                  ),
                  Text(
                    "${(linearValue * 100).toInt()}% Complete",
                    style: kwikTextStlye(
                      12.0,
                      FontWeight.w300,
                      colorCodes.darkGrey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 26),
              verifcationDialog(),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Bottomnavigationbar(3),
    );
  }

  Widget verifcationDialog() {
    switch (linearValue) {
      case 0.25:
        return PersonalInformation(
          firstNameController: firstNameController,
          lastNameController: lastNameController,
          emailController: emailController,
          phoneController: phoneController,
          dobController: dobController,
          streetAddressController: streetAddressController,
          cityController: cityController,
          stateController: stateController,
          nationality: nationality,
          onNationalityChanged: (String? value) {
            setState(() {
              nationality = value;
            });
          },

          nextFunc: () {
            setState(() {
              linearValue += 0.25;
            });
          },
          // nextFunc: () {
          //   setState(() {
          //     linearValue += 0.25;
          //   });
          // },
        );
      // Code to execute if expression matches value1

      case 0.50:
        return DocumentVerification(
          certificationType: certificationType,
          iDNumberController: iDNumberController,
          idDocumentFile: idDocumentFile,
          proofOfAddressFile: proofOfAddressFile,
          nextFunc: () {
            setState(() {
              linearValue += 0.25;
            });
          },
          previousFunc: () {
            setState(() {
              linearValue -= 0.25;
            });
          },
          onCertificationTypeChanged: (String? value) {
            setState(() {
              certificationType = value;
            });
          },
          onIdDocumentChanged: (file) {
            setState(() {
              idDocumentFile = file;
            });
          },
          onProofOfAddressChanged: (file) {
            setState(() {
              proofOfAddressFile = file;
            });
          },
          // nextFunc: () {
          //   setState(() {
          //     linearValue += 0.25;
          //   });
          // },
          // previousFunc: () {
          //   setState(() {
          //     linearValue -= 0.25;
          //   });
          // },
        );
      // Code to execute if expression matches value2
      // ... additional cases
      case 0.75:
        return IdentityVerification(
          nextFunc: () {
            setState(() {
              linearValue += 0.25;
            });
          },
          previousFunc: () {
            setState(() {
              linearValue -= 0.25;
            });
          },
        );
      case 1.0:
        return BussinessInformation(
          submitFunc: () {
            showDialog(
              barrierDismissible: false,
              context: context,

              builder: (BuildContext context) {
                return KycSuccessfulDialog(kwikticket: widget.kwikticket);
              },
            );
          },
          previousFunc: () {
            setState(() {
              linearValue -= 0.25;
            });
          },
        );
      default:
        return PersonalInformation(
          firstNameController: firstNameController,
          lastNameController: lastNameController,
          emailController: emailController,
          phoneController: phoneController,
          dobController: dobController,
          streetAddressController: streetAddressController,
          cityController: cityController,
          stateController: stateController,
          nationality: nationality,
          onNationalityChanged: (value) {
            setState(() {
              nationality = value;
            });
          },
          nextFunc: () {
            setState(() {
              linearValue += 0.25;
            });
          },
          // nextFunc: () {
          //   setState(() {
          //     linearValue += 0.25;
          //   });
          // },
        );
      // Code to execute if none of the cases match
    }
  }

  String getStepTitle() {
    if (linearValue <= 0.25) {
      return "Step 1: Personal Information";
    } else if (linearValue <= 0.50) {
      return "Step 2: Document Verification";
    } else if (linearValue <= 0.75) {
      return "Step 3: Identity Verification";
    } else {
      return "Step 4: Business Information";
    }
  }
}

  // Widget verifcationDialog() {
    // switch (linearValue) {
    //   case 0.25:
    //     return PersonalInformation(
    //       nextFunc: () {
    //         setState(() {
    //           linearValue += 0.25;
    //         });
    //       },
    //     );
    //   // Code to execute if expression matches value1

    //   case 0.50:
    //     return DocumentVerification(
    //       nextFunc: () {
    //         setState(() {
    //           linearValue += 0.25;
    //         });
    //       },
    //       previousFunc: () {
    //         setState(() {
    //           linearValue -= 0.25;
    //         });
    //       },
    //     );
    //   // Code to execute if expression matches value2
    //   // ... additional cases
    //   case 0.75:
    //     return IdentityVerification(
    //       nextFunc: () {
    //         setState(() {
    //           linearValue += 0.25;
    //         });
    //       },
    //       previousFunc: () {
    //         setState(() {
    //           linearValue -= 0.25;
    //         });
    //       },
    //     );
    //   case 1.0:
    //     return BussinessInformation(
    //       submitFunc: () {
    //         showDialog(
    //           barrierDismissible: false,
    //           context: context,

    //           builder: (BuildContext context) {
    //             return KycSuccessfulDialog(kwikticket: widget.kwikticket);
    //           },
    //         );
    //       },
    //       previousFunc: () {
    //         setState(() {
    //           linearValue -= 0.25;
    //         });
    //       },
    //     );
    //   default:
    //     return PersonalInformation(
    //       nextFunc: () {
    //         setState(() {
    //           linearValue += 0.25;
    //         });
    //       },
    //     );
    //   // Code to execute if none of the cases match
    // }
  

