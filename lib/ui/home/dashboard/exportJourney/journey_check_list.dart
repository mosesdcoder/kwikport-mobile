import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

Widget journeyCheckList(
  String title,
  bool isCompleted,
  bool isCurrent,
) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    decoration: BoxDecoration(
      color: isCurrent ? colorCodes.paleCornflowerBlue.withOpacity(0.1) : colorCodes.whiteSmoke,
      borderRadius: BorderRadius.circular(10),
      border: isCurrent ? Border.all(
        color: colorCodes.paleCornflowerBlue,
        width: 1.5,
      ) : null,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        isCompleted
            ? Icon(
                Icons.check_circle,
                color: colorCodes.pigmentGreen,
                size: 24,
              )
            : isCurrent
                ? Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorCodes.azureBlue,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        height: 12,
                        width: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorCodes.azureBlue,
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorCodes.graniteGrey.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                  ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: kwikTextStlye(
              14.0,
              isCurrent ? FontWeight.w600 : FontWeight.w400,
              isCurrent ? colorCodes.black : colorCodes.graniteGrey,
            ),
          ),
        ),
      ],
    ),
  );
}

// Widget checkContainer(
//   title,
//   // isCheckedSection,
//   checkterms,
//   subtitle,
//   delay,
//   delaydate,
//   // checkFunc,
// ) {
//   return Container(
//     height: 75,
//     width: 335,
//     padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//     decoration: BoxDecoration(
//       color: colorCodes.whiteSmoke,
//       borderRadius: BorderRadius.circular(10),
//     ),
//     child: Row(
//       // mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // InkWell(
//         //   // onTap: checkFunc,
//         //   child:
//         checkterms == true
//             ? Image.asset(
//               "assets/images/icons/dashboard/Checkbox (1).png",
//               height: 23,
//               width: 23,
//             )
//             : Container(
//               height: 20,
//               width: 20,
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 border: Border.all(color: colorCodes.frenchSkyBlue, width: 1.5),

//                 color: colorCodes.white,
//                 borderRadius: BorderRadius.circular(6), // rounded corners
//               ),
//             ),
//         // ),
//         SizedBox(width: 5),
//         SizedBox(
//           width: 220,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     title,
//                     textAlign: TextAlign.start,
//                     style: kwikTextStlye(
//                       10.0,
//                       FontWeight.w500,
//                       colorCodes.black,
//                     ),
//                   ),
//                   delay == true
//                       ? Container(
//                         width: 57,
//                         height: 20,
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 5,
//                           vertical: 3,
//                         ),
//                         decoration: BoxDecoration(
//                           color: colorCodes.white,
//                           borderRadius: BorderRadius.circular(22.03),
//                           border: Border.all(
//                             color: colorCodes.antiFlashWhite,
//                             width: 1, // border-width
//                           ),
//                         ),
//                         child: Text(
//                           delaydate,
//                           style: kwikTextStlye(
//                             10.0,
//                             FontWeight.w400,
//                             colorCodes.textBlack,
//                           ),
//                         ),
//                       )
//                       : SizedBox(width: 10),
//                 ],
//               ),
//               // SizedBox(height: 2),
//               Text(
//                 subtitle,
//                 textAlign: TextAlign.start,
//                 style: kwikTextStlye(10.0, FontWeight.w300, colorCodes.black),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }
