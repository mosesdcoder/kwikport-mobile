import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/main.dart';
import 'package:kwik_port/ui/home/dashboard/dashboard.dart';
import 'package:kwik_port/ui/home/profile/accordion.dart';
import 'package:kwik_port/ui/home/profile/edit_profile_screen.dart';
import 'package:kwik_port/utils/button/back_nav_header.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/contract_detail_heading_and_subtitle.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    // currentIndex = 4;
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent going back
        return false;
      },
      child: Scaffold(
        backgroundColor: colorCodes.whiteSmoke,
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                backNavRow(
                  context,
                  "My Profile",
                  func: () {
                    currentIndex = 1;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Dashboard()),
                    );
                  },
                ),
                SizedBox(height: 24.0),
                Row(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        height: 55,
                        width: 55,
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: HexColor("#D6EFFF"),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: HexColor("#F8FAFB"),
                            width: 2.0,
                          ),
                        ),
                        child: Center(
                          child: FittedBox(
                            child: Text(
                              "JG",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                color: HexColor("#33B1FF"),
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'John Gbenga',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: colorCodes.black,
                          ),
                        ),
                        Text(
                          "ID: KWP-2024-001",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: colorCodes.aluminium,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 20.0),
                Accordion(
                  title: "Personal Information",
                  child: Column(
                    children: [
                      contractDetailHeadingAndSubtitle(
                        "First Name",
                        "Last Name",
                        "John",
                        "Gbenga",
                      ),
                      SizedBox(height: 20.0),
                      contractDetailHeadingAndSubtitle(
                        "Phone Number",
                        "Email Address",
                        "+234-810-9957-139",
                        "+234-810-9957-139",
                      ),
                      SizedBox(height: 20.0),
                      contractDetailHeadingAndSubtitle(
                        "Export ID",
                        "Export Name",
                        "DW-KR-29012",
                        "####",
                      ),
                      SizedBox(height: 20.0),
                      kwikbutton(
                        '',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfileScreen(),
                              // settings: RouteSettings(name: 'ProfileSreen'),
                            ),
                          );
                        },
                        textColor: colorCodes.textBlack,
                        backgroundcolor: colorCodes.white,
                        borderColor: colorCodes.darkGrey,
                        buttonChild: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/icons/edit-2.png",
                              height: 18,
                              width: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Edit Profile",
                              style: kwikTextStlye(
                                16.0,
                                FontWeight.w500,
                                colorCodes.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
                Accordion(
                  title: "Shipping Statistics",
                  child: Column(children: [
                    
                  ],
                ),
                ),
                SizedBox(height: 16.0),
                Accordion(
                  title: "Preferences and Settings",
                  child: Column(children: [
                    
                  ],
                ),
                ),
                SizedBox(height: 16.0),
                Accordion(title: "Security", child: Column(children: [
                    
                  ],
                )),
                SizedBox(height: 16.0),
                Accordion(title: "About & Help", child: Column(children: [
                    
                  ],
                )),
                SizedBox(height: 16.0),
                Accordion(title: "Terms & Use", child: Column(children: [
                    
                  ],
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
