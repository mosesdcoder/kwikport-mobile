import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/home/exportfulfillment/KycVerification/bussiness_informatin.dart';
import 'package:kwik_port/ui/home/exportfulfillment/KycVerification/document_verification.dart';
import 'package:kwik_port/ui/home/exportfulfillment/KycVerification/identity_verification.dart';
import 'package:kwik_port/ui/home/exportfulfillment/KycVerification/kyc_successful_dialog.dart';
import 'package:kwik_port/ui/home/exportfulfillment/KycVerification/personal_information.dart';
import 'package:kwik_port/utils/button/back_nav_header.dart';
import 'package:kwik_port/utils/button/bottom_navigatior_bar.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

class KycVerificationScreen extends StatefulWidget {
  const KycVerificationScreen({super.key});

  @override
  State<KycVerificationScreen> createState() => _KycVerificationScreenState();
}

class _KycVerificationScreenState extends State<KycVerificationScreen> {
  double linearValue = 0.25;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    "Step 1: Personal Information",
                    style: kwikTextStlye(
                      12.0,
                      FontWeight.w300,
                      colorCodes.darkGrey,
                    ),
                  ),
                  Text(
                    "25% Complete",
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
          nextFunc: () {
            setState(() {
              linearValue += 0.25;
            });
          },
        );
      // Code to execute if expression matches value1

      case 0.50:
        return DocumentVerification(
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
                return KycSuccessfulDialog();
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
          nextFunc: () {
            setState(() {
              linearValue += 0.25;
            });
          },
        );
      // Code to execute if none of the cases match
    }
  }
}
