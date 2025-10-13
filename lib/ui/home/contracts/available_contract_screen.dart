// import 'package:flutter/material.dart';
// import 'package:kwik_port/colors/color.dart';
// import 'package:kwik_port/main.dart';
// import 'package:kwik_port/ui/home/contracts/contract_details_screen.dart';
// import 'package:kwik_port/utils/button/back_nav_header.dart';
// import 'package:kwik_port/utils/button/bottom_navigatior_bar.dart';
// import 'package:kwik_port/utils/containers/available_contract_container.dart';

// class AvailableContractScreen extends StatefulWidget {
//   const AvailableContractScreen({super.key});

//   @override
//   State<AvailableContractScreen> createState() =>
//       _AvailableContractScreenState();
// }

// class _AvailableContractScreenState extends State<AvailableContractScreen> {
//   int itemCount = 5;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBody: true,
//       backgroundColor: colorCodes.whiteSmoke,
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(85.0),
//         child: Padding(
//           padding: const EdgeInsets.only(left: 20.0, top: 42.0, bottom: 15),
//           child: backNavRow(
//             context,
//             "Available Contracts",
//             func: () {
//               currentIndex = 1;
//               Navigator.pop(context);
//             },
//           ),
//         ),
//       ),
//       body: ListView(
//         padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(
//                 height: 320 * itemCount.toDouble(),
//                 child: ListView.separated(
//                   physics: NeverScrollableScrollPhysics(),
//                   separatorBuilder: (context, index) => SizedBox(height: 16),
//                   itemCount: itemCount,
//                   itemBuilder: (ctx, index) {
//                     return avaiableontractContainer(
//                       "assets/images/cocoa.png",
//                       "Cocoa Bean",
//                       "assets/images/icons/tick-circle.png",
//                       "Open",
//                       "100 tons",
//                       "assets/images/icons/Country.png",
//                       "Argentina",
//                       "20 tons",
//                       "100 tons",
//                       "20%",
//                       "\$12,500",
//                       "assets/images/icons/Trending up.png",
//                       "15.5%",
//                       () {
//                         currentIndex = 2;
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder:
//                                 (context) =>
//                                     ContractDetailsScreen(contractId: ''),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       bottomNavigationBar: Bottomnavigationbar(2),
//     );
//   }
// }
