import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kwik_port/api/controller/home/dashboard_api.dart';
import 'package:kwik_port/api/controller/kwikTickets/update_kwikticket_status_api.dart';
import 'package:kwik_port/api/model/dashboard_model.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/home/exportfulfillment/KycVerification/export_payment_success_dialog.dart';
import 'package:kwik_port/utils/button/back_nav_header.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:kwik_port/utils/toast.dart';
import 'package:provider/provider.dart';

class ExportPaymentConfirmed extends StatefulWidget {
  final KwikTicketModel kwikticket;
  final String referenceNumber;
  final String dateTime;
  // final String amountPaid;
  final String paymentMethod;

  const ExportPaymentConfirmed({
    super.key,
    required this.kwikticket,
    required this.referenceNumber,
    required this.dateTime,
    // required this.amountPaid,
    required this.paymentMethod,
  });

  @override
  State<ExportPaymentConfirmed> createState() => _ExportPaymentConfirmedState();
}

class _ExportPaymentConfirmedState extends State<ExportPaymentConfirmed> {
  @override
  void initState() {
    Timer(Duration(seconds: 2), () async {
      showDialog(
        barrierDismissible: false,
        context: context,

        builder: (BuildContext context) {
          return ExportPaymentSucessfulDialog(kwikticket: widget.kwikticket);
        },
      );
      // } else {
      //   showToastContainer(
      //     "Ticket Status",
      //     updateApi.message,
      //     colorCodes.mistyRose,
      //     colorCodes.portlandOrange,
      //     context,
      //   );
      // }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorCodes.whiteSmoke,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              backNavRow(context, "Payment"),
              SizedBox(height: 110),
              Image.asset(
                'assets/images/icons/success_login.png',
                height: 96,
                width: 113,
              ),
              SizedBox(height: 40),
              Text(
                'Payment Confirmed!',
                style: kwikTextStlye(24.0, FontWeight.w600, colorCodes.black),
              ),
              Text(
                'Your export journey has begun!',
                style: kwikTextStlye(
                  14.0,
                  FontWeight.w300,
                  colorCodes.graniteGrey,
                ),
              ),
              SizedBox(height: 30),
              Container(
                height: 169,
                width: 390,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                decoration: BoxDecoration(
                  color: colorCodes.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(width: 1.2, color: colorCodes.white),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaction Details',
                      style: kwikTextStlye(
                        12.0,
                        FontWeight.w600,
                        colorCodes.black,
                      ),
                    ),
                    SizedBox(height: 11),
                    confirmeddetailRow(
                      "Reference Number",
                      widget.referenceNumber, // "TXN-2024-EX7B9C2A5",
                    ),
                    SizedBox(height: 11),
                    confirmeddetailRow("Date & Time", widget.dateTime),
                    SizedBox(height: 11),
                    confirmeddetailRow(
                      "Amount Paid",
                      "${widget.kwikticket.kwikTicketAmount}", // "#2,499,000.00",
                      detailColor: colorCodes.azureBlue,
                      fontFamily: "",
                    ),
                    SizedBox(height: 11),
                    confirmeddetailRow("Payment method", widget.paymentMethod),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget confirmeddetailRow(title, detail, {detailColor, fontFamily}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: kwikTextStlye(12.0, FontWeight.w300, colorCodes.graniteGrey),
      ),
      Text(
        detail,
        style: kwikTextStlye(
          12.0,
          FontWeight.w600,
          detailColor ?? colorCodes.graniteGrey,
          fontFamily: fontFamily ?? "Poppins",
        ),
      ),
    ],
  );
}
