import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:kwik_port/utils/textFields/search_field.dart';

class WalletTransactionHistory extends StatefulWidget {
  const WalletTransactionHistory({super.key});

  @override
  State<WalletTransactionHistory> createState() =>
      _WalletTransactionHistoryState();
}

class _WalletTransactionHistoryState extends State<WalletTransactionHistory> {
  TextEditingController searcTransactioncontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 513,
      width: 390,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
        color: colorCodes.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Transaction History",
              style: kwikTextStlye(16.0, FontWeight.w600, colorCodes.black),
            ),
          ),
          SizedBox(height: 10),
          searchFieldColumn(
            "",
            "",
            searcTransactioncontroller,
            "Search transactions...",
          ),
          SizedBox(height: 20),
          transactionHistoryContainer(
            "Cashew Export Earnings ",
            "Successful",
            "05 Sep 2025",
            "10:00 pm",
            "+\$2,000",
            () {},
          ),
        ],
      ),
    );
  }

  Widget transactionHistoryContainer(
    transactiontitle,
    transactionStatus,
    dateofTransaction,
    timeofTransaction,
    earning,
    func,
  ) {
    return InkWell(
      onTap: func,
      child: Container(
        height: 75,
        width: 352,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
        decoration: BoxDecoration(
          color: colorCodes.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 20.0, // Corresponds to the 20px blur radius
              spreadRadius: 0.0,
              offset: Offset(0.0, 0.0),
            ),
          ],
        ),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: colorCodes.whiteSmoke,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(child: Image.asset("", height: 18, width: 18)),
                ),
                SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transactiontitle,
                      style: kwikTextStlye(
                        14.0,
                        FontWeight.w500,
                        colorCodes.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          "$transactionStatus",
                          style: kwikTextStlye(
                            10.0,
                            FontWeight.w300,
                            colorCodes.graniteGrey,
                          ),
                        ),
                        SizedBox(width: 4),
                        Container(
                          height: 3,
                          width: 3,
                          decoration: BoxDecoration(
                            color: colorCodes.graniteGrey,
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          "$dateofTransaction, $timeofTransaction",
                          style: kwikTextStlye(
                            10.0,
                            FontWeight.w300,
                            colorCodes.graniteGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(width: 25),
            Text(
              earning,
              style: kwikTextStlye(
                14.0,
                FontWeight.w600,
                colorCodes.mediumSeaGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
