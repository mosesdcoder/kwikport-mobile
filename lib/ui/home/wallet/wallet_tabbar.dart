import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';

Widget transactionHistoryTabBar(_tabController) {
  return Container(
    height: 30,
    width: 390,
    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),

    decoration: BoxDecoration(
      color: colorCodes.white,
      borderRadius: BorderRadius.circular(100),
    ),
    child: TabBar(
      // indicatorColor: colorCodes.teaGreen,
      // labelPadding: const EdgeInsets.symmetric(vertical: 12),
      indicatorSize: TabBarIndicatorSize.tab,

      labelColor: colorCodes.white,
      labelStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 12.0,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelColor: colorCodes.darkGrey,
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 10.0,
        fontWeight: FontWeight.w500,
        // color: colorCodes
      ),

      // indicatorPadding: const EdgeInsets.symmetric(
      //   vertical: 4,
      //   horizontal: 4,
      // ),
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: colorCodes.frenchSkyBlue),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            colorCodes.jordyBlue,
            colorCodes.azureBlue,
            colorCodes.azureBlue,
          ],
        ),
        color: colorCodes.white,
      ),
      controller: _tabController,
      tabs: [
        Tab(text: "All"),
        Tab(text: "Deposit"),
        Tab(text: "Withdrawals"),
        Tab(text: "Earnings"),
        Tab(text: "Fees"),
      ],
    ),
  );
}
