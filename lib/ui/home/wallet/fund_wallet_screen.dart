import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kwik_port/api/controller/home/dashboard_api.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/utils/button/back_nav_header.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:kwik_port/utils/textFields/und_tetfield.dart';
import 'package:provider/provider.dart';

class FundWalletScreen extends StatefulWidget {
  const FundWalletScreen({super.key});

  @override
  State<FundWalletScreen> createState() => _FundWalletScreenState();
}

class _FundWalletScreenState extends State<FundWalletScreen> {
  TextEditingController fundAccountfield = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dashboardApi = Provider.of<DashboardApi>(context);
    final isLoading = dashboardApi.loading;
    final walletBalance = dashboardApi.data?.walletBalance ?? 0.0;
    final NumberFormat currencyFormat = NumberFormat("#,###");

    return Scaffold(
      extendBody: true,
      backgroundColor: colorCodes.whiteSmoke,
      body: ListView(
        shrinkWrap: true,
        physics: RangeMaintainingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 50.0),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              backNavRow(context, "Fund Wallet"),
              SizedBox(height: 35.0),
              Container(
                height: 130,
                width: 342,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                decoration: BoxDecoration(
                  color: colorCodes.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    width: 1.5,
                    color: colorCodes.paleCornflowerBlue,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/images/icons/dashboard/Frame 1000006029.png",
                      height: 20,
                      width: 20,
                    ),
                    SizedBox(width: 5),
                    SizedBox(
                      width: 240,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Funding Tips",
                            style: kwikTextStlye(
                              14.0,
                              FontWeight.w600,
                              colorCodes.black,
                            ),
                          ),
                          Text(
                            """• All transactions are secured with bank-level encryption
• Minimum funding amount is ₦1,000
• No fees for bank transfers
• Funds reflect instantly in your wallet""",
                            textAlign: TextAlign.start,
                            style: kwikTextStlye(
                              12.0,
                              FontWeight.w300,
                              colorCodes.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 55.0),
              Text(
                "Enter Amount",
                style: TextStyle(fontSize: 18.0, color: colorCodes.bluetiful),
              ),
              SizedBox(height: 20.0),
              fundTextfield(fundAccountfield, "", (value) {
                // Remove commas
                String numericValue = value.replaceAll(",", "");

                if (numericValue.isEmpty) {
                  fundAccountfield.value = TextEditingValue(
                    text: "",
                    selection: TextSelection.collapsed(offset: 0),
                  );
                  return;
                }

                // Format with commas
                final newValue = currencyFormat.format(int.parse(numericValue));

                fundAccountfield.value = TextEditingValue(
                  text: newValue,
                  selection: TextSelection.collapsed(offset: newValue.length),
                );
              }),

              SizedBox(height: 110.0),
              kwikbutton("Continue", () {
                int amountToSend = int.parse(
                  fundAccountfield.text.replaceAll(",", ""),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
