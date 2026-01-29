import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/api/controller/home/dashboard_api.dart';
import 'package:kwik_port/api/model/signupResponse.dart';
import 'package:kwik_port/api/model/userModel.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/main.dart';
import 'package:kwik_port/ui/home/dashboard/dashboard.dart';
import 'package:kwik_port/ui/home/profile/accordion.dart';
import 'package:kwik_port/ui/home/profile/edit_profile_screen.dart';
import 'package:kwik_port/ui/onboarding/auth/change_password_screen.dart';
import 'package:kwik_port/ui/onboarding/auth/login_screen.dart';
import 'package:kwik_port/ui/onboarding/auth/terms_and_conditions_screen.dart';
import 'package:kwik_port/utils/button/back_nav_header.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/contract_detail_heading_and_subtitle.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
    bool _pushNotificationsEnabled = true;
    bool _darkModeEnabled = false;
  @override
  Widget build(BuildContext context) {
    final dashboardApi = Provider.of<DashboardApi>(context);

    final user = dashboardApi.data?.userProfile;
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
                          child:
                              userDataVar?.image != null &&
                                      userDataVar!.image!.isNotEmpty
                                  ? Image.network(
                                    userDataVar!.image!,
                                    fit: BoxFit.cover,
                                    width: 51,
                                    height: 51,
                                    errorBuilder: (context, error, stackTrace) {
                                      // fallback to initials if network image fails
                                      return FittedBox(
                                        child: Text(
                                          _generateInitials(
                                            "${userDataVar?.firstName!.toUpperCase()} ${userDataVar?.lastName!.toUpperCase()}",
                                          ),
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            color: HexColor("#33B1FF"),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                  : FittedBox(
                                    child: Text(
                                      _generateInitials(
                                        user != null
                                            ? "${user.firstName.toUpperCase()} ${user.lastName.toUpperCase()}"
                                            : "User",
                                      ),
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
                          // "John Gbenga",
                          "${userDataVar?.firstName}  ${userDataVar?.lastName}",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: colorCodes.black,
                          ),
                        ),
                        Text(
                          "ID: ${userDataVar?.exporter?.exporterUniqueId ?? " KWP-2024-001"}", //ID: KWP-2024-001
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
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        contractDetailHeadingAndSubtitle(
                          "First Name",
                          "Last Name",
                          "${userDataVar?.firstName}",
                          "${userDataVar?.lastName}",
                        ),
                        SizedBox(height: 20.0),
                        contractDetailHeadingAndSubtitle(
                          "Phone Number",
                          "Email Address",
                          "${userDataVar?.phoneNumber}",
                          // "+234-810-9957-139",
                          "${userDataVar?.email}",
                          // "Johngbenga@gmail.com",
                        ),
                        SizedBox(height: 20.0),
                        contractDetailHeadingAndSubtitle(
                          "Export ID",
                          "Export Name",
                          userDataVar?.exporter?.exporterUniqueId ??
                              "DW-KR-29012",
                           userDataVar?.exporter?.businessName ??
                              "######",
                          //"####",
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
                            ).then((value) async {
                              // 🧠 Refresh user data after editing profile
                              final prefs = await SharedPreferences.getInstance();
                              final userSessionStr = prefs.getString(
                                'userSession',
                              );
                              if (userSessionStr != null) {
                                setState(() {
                                  userDataVar = UserSession.fromJson(
                                    jsonDecode(userSessionStr),
                                  );
                                });
                              }
                            });
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
                                width: 10,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Edit Profile",
                                style: kwikTextStlye(
                                  15.0,
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
                ),
                SizedBox(height: 15.0),
                Accordion(title: "Help & Support", child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.phone, color: colorCodes.azureBlue),
                        SizedBox(width: 8),
                        Text(
                          "+234 814 720 8234",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            color: colorCodes.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.email, color: colorCodes.azureBlue),
                        SizedBox(width: 8),
                        Text(
                          "support@kwikports.com",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            color: colorCodes.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: colorCodes.azureBlue.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.chat_bubble_outline, color: colorCodes.azureBlue),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Live Chat",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            color: colorCodes.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
                SizedBox(height: 15.0),
                Accordion(
                  title: "Preferences and Settings",
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SwitchListTile(
                          title: Text("Push Notifications", style: TextStyle(fontSize: 14)),
                          value: _pushNotificationsEnabled,
                          onChanged: (val) {
                            setState(() => _pushNotificationsEnabled = val);
                          },
                          inactiveThumbColor: colorCodes.aluminium,
                          inactiveTrackColor: colorCodes.aluminium.withOpacity(0.3),
                        ),
                        SwitchListTile(
                          title: Text("Dark Mode", style: TextStyle(fontSize: 14)),
                          value: _darkModeEnabled,
                          onChanged: (val) {
                            setState(() => _darkModeEnabled = val);
                          },
                          inactiveThumbColor: colorCodes.aluminium,
                          inactiveTrackColor: colorCodes.aluminium.withOpacity(0.3),
                        ),
                        ListTile(
                          leading: Icon(Icons.language, size: 22),
                          title: Text("Language", style: TextStyle(fontSize: 14)),
                          trailing: Text("English", style: TextStyle(fontSize: 13)),
                          onTap: () {
                            // Show language selection dialog
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.privacy_tip_outlined, size: 22),
                          title: Text("Privacy Settings", style: TextStyle(fontSize: 14)),
                          onTap: () {
                            // Navigate to privacy settings
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.info_outline, size: 22),
                          title: Text("App Version", style: TextStyle(fontSize: 14)),
                          trailing: Text("v1.0.0", style: TextStyle(fontSize: 13)),
                        ),
                        // ListTile(
                        //   leading: Icon(Icons.delete_outline, color: Colors.red, size: 22),
                        //   title: Text("Delete Account", style: TextStyle(color: Colors.red, fontSize: 14)),
                        //   onTap: () {
                        //     // Show delete confirmation
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                Accordion(
                  title: "Security",
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 358,
                        child: kwikbutton(
                          '',
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangePasswordScreen(),
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
                                "Change Password",
                                style: kwikTextStlye(
                                  16.0,
                                  FontWeight.w500,
                                  colorCodes.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.0),
                Accordion(title: "Bank Accounts", child: Column(
                  children: [
                    SizedBox(height: 16),
                    Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                        decoration: BoxDecoration(
                          color: colorCodes.azureBlue.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.account_balance_wallet_rounded, size: 40, color: colorCodes.azureBlue),
                            SizedBox(height: 12),
                            Text(
                              "Bank Account",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: colorCodes.azureBlue,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Coming soon",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500,
                                color: colorCodes.aluminium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                )),

                SizedBox(height: 15.0),
                SizedBox(
                  height: 60,
                  child: Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    color: colorCodes.white,
                    child: ListTile(
                      leading: Icon(Icons.description_outlined, color: colorCodes.portlandOrange),
                      title: Text(
                        "Terms & Conditions",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                          color: colorCodes.black,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 18, color: colorCodes.portlandOrange),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TermsAndConditionsScreen(),
                          ),
                        );
                        // When user comes back, this screen is still here
                      },
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                Accordion(title: "About", child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    
                  ],
                )),
                SizedBox(height: 15.0),

                SizedBox(
                  height: 40,
                  width: 358,
                  child: kwikbutton(

                    "Logout",
                    () async {
                      final shouldLogout = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Confirm Logout'),
                          content: Text('Are you sure you want to sign out?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text('Logout'),
                            ),
                          ],
                        ),
                      );

                      if (shouldLogout == true) {
                        final prefs = await SharedPreferences.getInstance();

                        // Backup keys you want to keep
                        final inProgress = prefs.getBool('journeyInProgress');
                        final exportContractId = prefs.getString(
                          'activeExportContractId',
                        );

                        // Clear all data
                        await prefs.clear();

                        // Restore only what you want to persist
                        if (inProgress != null)
                          await prefs.setBool('journeyInProgress', inProgress);
                        if (exportContractId != null)
                          await prefs.setString(
                            'activeExportContractId',
                            exportContractId,
                          );

                        final selected = prefs.getBool('procurementSelected');
                        final startTime = prefs.getInt('procurementStartTime');
                        final showProcurement = prefs.getBool('showProcurement');

                        if (selected != null)
                          await prefs.setBool('procurementSelected', selected);
                        if (startTime != null)
                          await prefs.setInt('procurementStartTime', startTime);
                        if (showProcurement != null)
                          await prefs.setBool('showProcurement', showProcurement);

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                          (Route<dynamic> route) => false,
                        );
                      }
                    },

                    textColor: colorCodes.white,
                    backgroundcolor: colorCodes.portlandOrange,
                    borderColor: colorCodes.portlandOrange,
                    buttonChild: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/signout.png",
                          height: 20,
                          width: 20,
                          color: colorCodes.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Sign out",
                          style: kwikTextStlye(
                            16.0,
                            FontWeight.w500,
                            colorCodes.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _generateInitials(String fullName) {
    List<String> nameParts = fullName.split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
      ;
    } else if (nameParts.length == 1) {
      return '${nameParts[0][0]}'.toUpperCase();
      ;
    } else {
      return ''; // Handle the case where the name is empty
    }
  }
}
