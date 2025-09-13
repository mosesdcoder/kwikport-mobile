import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/home/dashboard/dashboard.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

class ProfileSetupSuccess extends StatefulWidget {
  const ProfileSetupSuccess({super.key});

  @override
  State<ProfileSetupSuccess> createState() => _ProfileSetupSuccessState();
}

class _ProfileSetupSuccessState extends State<ProfileSetupSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorCodes.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/icons/account_successimg.png',
                height: 96,
                width: 113,
              ),
              SizedBox(height: 40),
              Text(
                "Exporter ID Generated",
                style: kwikTextStlye(24.0, FontWeight.w600, colorCodes.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Container(
                height: 30,
                width: 270,
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: colorCodes.platinum),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14.0,
                          fontWeight: FontWeight.w300,
                          color: colorCodes.graniteGrey,
                        ),

                        children: [
                          TextSpan(text: "Your export ID is "),
                          TextSpan(
                            text: 'KWP-2024-001 ',
                            style: TextStyle(color: colorCodes.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {},
                      child: Image.asset(
                        'assets/images/icons/copy_outline.png',
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Container(
                height: 50,
                // width: 350,
                padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),

                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: HexColor("#D0E1FB").withOpacity(0.3),
                  border: Border.all(color: colorCodes.paleCornflowerBlue),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/icons/kwiktickett.png",
                      height: 20,
                      width: 20,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "This is your unique identifier for all export activities.",
                      style: kwikTextStlye(
                        12.0,
                        FontWeight.w300,
                        colorCodes.graniteGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 48),
              kwikbutton("Proceed to dashboard", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
