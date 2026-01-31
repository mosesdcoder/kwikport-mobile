import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/api/model/userModel.dart';
import 'package:kwik_port/colors/color.dart';

Widget nameAndNotifHeading(
  context,
  fullname,
  newNotification,
  notificationFunc,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          InkWell(
            onTap: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => Profiledetailscreen()));
            },
            child: Container(
              height: 50,
              width: 50,
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: HexColor("#FFE8CC"),
                shape: BoxShape.circle,
                border: Border.all(color: colorCodes.white, width: 2.0),
              ),
              child: Center(
                child: CircleAvatar(
                  radius: 25, // slightly smaller to show border effect
                  backgroundColor: Colors.transparent,
                  backgroundImage: (userDataVar?.image != null && (userDataVar?.image?.isNotEmpty ?? false))
                      ? NetworkImage(userDataVar!.image!)
                      : null,
                  child: (userDataVar?.image == null || (userDataVar?.image?.isEmpty ?? true))
                      ? FittedBox(
                          child: Text(
                            _generateInitials(
                              "${userDataVar?.firstName?.toUpperCase() ?? ''} ${userDataVar?.lastName?.toUpperCase() ?? ''}",
                            ),
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: HexColor("#FF8A00"),
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        )
                      : null,
                ),
                // userDataVar?.image != null && userDataVar!.image!.isNotEmpty
                //     ? Image.network(
                //       userDataVar!.image!,
                //       fit: BoxFit.cover,
                //       width: 51,
                //       height: 51,
                //       errorBuilder: (context, error, stackTrace) {
                //         // fallback to initials if network image fails
                //         return FittedBox(
                //           child: Text(
                //             _generateInitials(
                //               "${userDataVar?.firstName!.toUpperCase()} ${userDataVar?.lastName!.toUpperCase()}",
                //             ),
                //             style: TextStyle(
                //               fontFamily: "Poppins",
                //               color: HexColor("#33B1FF"),
                //               fontWeight: FontWeight.w600,
                //               fontSize: 20,
                //             ),
                //           ),
                //         );
                //       },
                //     )
                //     : FittedBox(
                //       child: Text(
                //         _generateInitials(fullname),
                //         style: TextStyle(
                //           fontFamily: "Poppins",
                //           color: HexColor(
                //             "#FF8A00",
                //           ), // Set your desired text color
                //           fontWeight: FontWeight.w600,
                //           fontSize: 20,
                //         ),
                //       ),
                //     ),
              ),
            ),
          ),
          SizedBox(width: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fullname,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  color: colorCodes.black,
                ),
              ),
              Text(
                "ID: "+(userDataVar?.exporterUniqueId ?? "-"),
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: colorCodes.aluminium,
                ),
              ),
            ],
          ),
        ],
      ),
      Row(
        children: [
          InkWell(
            onTap: () {},
            child: Image.asset(
              "assets/images/icons/informationIcon.png",
              height: 40,
              width: 40,
            ),
          ),
          InkWell(
            onTap: notificationFunc,
            child: Container(
              height: 40,
              width: 40,
              // alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorCodes.white,
                border: Border.all(
                  width: 1.5,
                  color: colorCodes.antiFlashWhite,
                ),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/icons/notification.png',
                    color: colorCodes.black,
                    height: 24,
                    width: 24,
                  ),
                  newNotification
                      ? Positioned(
                        top: 10,
                        // top: 0,
                        right: 10,
                        child: CircleAvatar(
                          radius: 3.0,
                          backgroundColor: colorCodes.portlandOrange,
                        ),
                      )
                      : Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget nameAndNotifHeading2(
  context,
  fullName,
  newNotification,
  notificationFunc,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          InkWell(
            onTap: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => Profiledetailscreen()));
            },
            child: Container(
              height: 55,
              width: 55,
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: HexColor("#FFE8CC"),
                shape: BoxShape.circle,
                border: Border.all(color: colorCodes.white, width: 2.0),
              ),
              child: Center(
                child: CircleAvatar(
                  radius: 25, // slightly smaller to show border effect
                  backgroundColor: Colors.transparent,
                  backgroundImage: (userDataVar?.image != null && (userDataVar?.image?.isNotEmpty ?? false))
                      ? NetworkImage(userDataVar!.image!)
                      : null,
                  child: (userDataVar?.image == null || (userDataVar?.image?.isEmpty ?? true))
                      ? FittedBox(
                          child: Text(
                            _generateInitials(
                              "${userDataVar?.firstName?.toUpperCase() ?? ''} ${userDataVar?.lastName?.toUpperCase() ?? ''}",
                            ),
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: HexColor("#FF8A00"),
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        )
                      : null,
                ),
                // userDataVar?.image != null && userDataVar!.image!.isNotEmpty
                //     ? Image.network(
                //       userDataVar!.image!,
                //       fit: BoxFit.cover,
                //       width: 51,
                //       height: 51,
                //       errorBuilder: (context, error, stackTrace) {
                //         // fallback to initials if network image fails
                //         return FittedBox(
                //           child: Text(
                //             _generateInitials(
                //               "${userDataVar?.firstName!.toUpperCase()} ${userDataVar?.lastName!.toUpperCase()}",
                //             ),
                //             style: TextStyle(
                //               fontFamily: "Poppins",
                //               color: HexColor("#33B1FF"),
                //               fontWeight: FontWeight.w600,
                //               fontSize: 20,
                //             ),
                //           ),
                //         );
                //       },
                //     )
                //     : FittedBox(
                //       child: Text(
                //         _generateInitials(fullName),
                //         style: TextStyle(
                //           fontFamily: "Poppins",
                //           color: HexColor(
                //             "#FF8A00",
                //           ), // Set your desired text color
                //           fontWeight: FontWeight.w600,
                //           fontSize: 20,
                //         ),
                //       ),
                //     ),
              ),
            ),
          ),
          SizedBox(width: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fullName,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: colorCodes.black,
                ),
              ),
              Text(
                "ID: "+(userDataVar?.exporterUniqueId ?? "-"),
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
      InkWell(
        onTap: notificationFunc,
        child: Container(
          height: 48,
          width: 48,
          // alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colorCodes.white,
            border: Border.all(width: 1.5, color: colorCodes.antiFlashWhite),
            shape: BoxShape.circle,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/images/icons/notification.png',
                color: colorCodes.black,
                height: 24,
                width: 24,
              ),
              newNotification
                  ? Positioned(
                    top: 12,
                    // top: 0,
                    right: 15,
                    child: CircleAvatar(
                      radius: 3.0,
                      backgroundColor: colorCodes.portlandOrange,
                    ),
                  )
                  : Container(),
            ],
          ),
        ),
      ),
    ],
  );
}

String _generateInitials(String fullName) {
  if (fullName == null) return '';
  String trimmed = fullName.trim();
  if (trimmed.isEmpty) return '';
  List<String> nameParts = trimmed.split(' ').where((part) => part.isNotEmpty).toList();
  if (nameParts.length >= 2) {
    return ('${nameParts[0][0]}${nameParts[1][0]}').toUpperCase();
  } else if (nameParts.length == 1 && nameParts[0].isNotEmpty) {
    return nameParts[0][0].toUpperCase();
  } else {
    return '';
  }
}
