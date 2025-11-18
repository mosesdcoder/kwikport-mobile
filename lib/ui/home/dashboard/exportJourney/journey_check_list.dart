import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

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
