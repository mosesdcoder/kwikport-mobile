import 'package:flutter/material.dart';
import 'package:kwik_port/api/controller/home/dashboard_api.dart';
import 'package:kwik_port/api/controller/kwikTickets/fund_ticket_api.dart';
import 'package:kwik_port/api/model/dashboard_model.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/main.dart';
import 'package:kwik_port/ui/home/exportfulfillment/KycVerification/fund_export_contract.dart';
import 'package:kwik_port/ui/home/exportfulfillment/KycVerification/kyc_verification_screen.dart';
import 'package:kwik_port/utils/button/back_nav_header.dart';
import 'package:kwik_port/utils/button/bottom_navigatior_bar.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/button/loading_dialog.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:kwik_port/utils/toast.dart';
import 'package:provider/provider.dart';

class ExportFulfillmentScreen extends StatefulWidget {
  final KwikTicketModel kwikticket;

  const ExportFulfillmentScreen({super.key, required this.kwikticket});

  @override
  State<ExportFulfillmentScreen> createState() =>
      _ExportFulfillmentScreenState();
}

class _ExportFulfillmentScreenState extends State<ExportFulfillmentScreen> {
  @override
  Widget build(BuildContext context) {
    final dashboardApi = Provider.of<DashboardApi>(context);

    final fundTicketApi = Provider.of<FundKwikticketApi>(
      context,
      listen: false,
    );

    return Scaffold(
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 42.0, bottom: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: backNavRow(context, "Export fulfilment"),
          ),
        ),
      ),
      backgroundColor: colorCodes.whiteSmoke,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: backNavRow(context, "Export fulfilment"),
              // ),
              // SizedBox(height: 51),
              Image.asset(
                "assets/images/icons/dashboard/Export fulfilment.png",
                height: 96,
                width: 113,
              ),
              SizedBox(height: 40),
              Text(
                "How would you like to fulfill your export?",
                style: kwikTextStlye(24.0, FontWeight.w600, colorCodes.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 17),
              Text(
                "Choose the best option for your export needs",
                style: kwikTextStlye(
                  14.0,
                  FontWeight.w300,
                  colorCodes.darkGrey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              fulfildataContainer(
                "Use capital with kwikprocure",
                "Fund the procurement of export-ready goods. No need to source products yourself",
                "Select from verified procurement agencies on KwikPort",
                "Agencies handle sourcing, quality, and delivery on your behalf.",
                "Your KwikTicket is activated once procurement is confirmed",
                fundTicketApi,
                dashboardApi,
              ),
              SizedBox(height: 10),
              fulfilproductContainer(
                "Use your own product",
                "Already have export-ready goods? Let's verify they meet international standards.",
                "Complete verification to qualify for product submission",
                "Deliver your commodity to KwikPort’s testing facility for approval",
                "Once approved, your KwikTicket becomes an active export contract.",
                false,
              ),
              SizedBox(height: 10),
              Container(
                height: 109,
                width: 390,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
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
                    SizedBox(width: 4),
                    SizedBox(
                      width: 275,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pro tip",
                            style: kwikTextStlye(
                              14.0,
                              FontWeight.w600,
                              colorCodes.black,
                            ),
                          ),
                          Text(
                            "Complete KYC verification to unlock product verification, or use KwikProcure to start exporting immediately.",
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
              SizedBox(height: 50),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Bottomnavigationbar(3),
    );
  }

  Widget fulfildataContainer(
    title,
    subtitle,
    dataOne,
    dataTwo,
    dataThree,
    FundKwikticketApi fundTicketApi,
    DashboardApi dashboardApi,
  ) {
    return Container(
      height: 277,
      width: 390,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(
        color: colorCodes.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 1.2, color: colorCodes.antiFlashWhite),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/icons/dashboard/Frame 1000006245 (2).png",
                height: 25,
                width: 25,
              ),
              SizedBox(width: 10),
              Text(
                title,
                style: kwikTextStlye(14.0, FontWeight.w600, colorCodes.black),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              SizedBox(width: 18),
              SizedBox(
                width: 275,
                child: Text(
                  subtitle,
                  style: kwikTextStlye(
                    12.0,
                    FontWeight.w300,
                    colorCodes.darkGrey,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(width: 26),
              Image.asset(
                "assets/images/icons/dashboard/Frame 1000006245.png",
                height: 25,
                width: 25,
              ),
              SizedBox(width: 6),
              SizedBox(
                width: 230,
                child: Text(
                  dataOne,
                  style: kwikTextStlye(
                    10.0,
                    FontWeight.w500,
                    colorCodes.darkGrey,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 7),
          Row(
            children: [
              SizedBox(width: 26),
              Image.asset(
                "assets/images/icons/dashboard/Frame 1000006245.png",
                height: 25,
                width: 25,
              ),
              SizedBox(width: 6),
              SizedBox(
                width: 230,
                child: Text(
                  dataTwo,
                  style: kwikTextStlye(
                    10.0,
                    FontWeight.w500,
                    colorCodes.darkGrey,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 7),
          Row(
            children: [
              SizedBox(width: 26),
              Image.asset(
                "assets/images/icons/dashboard/Frame 1000006245.png",
                height: 25,
                width: 25,
              ),
              SizedBox(width: 6),
              SizedBox(
                width: 230,
                child: Text(
                  dataThree,
                  style: kwikTextStlye(
                    10.0,
                    FontWeight.w500,
                    colorCodes.darkGrey,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 38,
            child: kwikbutton(
              "",
              () async {
                // setState(() => fundTicketApi.loading = true);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return LoadingDialog();
                  },
                );
                await fundTicketApi.fundTicket(
                  kwikTicketId: widget.kwikticket.id, //.toString(),
                  exporterId: widget.kwikticket.exporter!.id, //.toString(),
                );
                Navigator.pop(context);
                // setState(() => fundTicketApi.loading = false);

                if (fundTicketApi.isSuccessful == true &&
                    fundTicketApi.authorizationUrl != null) {
                  debugPrint("Fund Ticket id: ${widget.kwikticket.id}");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => FundExportContract(
                            kwikticket: widget.kwikticket,
                            url: fundTicketApi.authorizationUrl!,
                            kwikTicketId: widget.kwikticket.id,
                            referenceNumber: fundTicketApi.paymentReference!,
                            paymentMethod: fundTicketApi.provider!,
                          ),
                    ),
                  );
                } else {
                  showToastContainer(
                    "Fund Ticket",
                    fundTicketApi.message,
                    colorCodes.mistyRose,
                    colorCodes.portlandOrange,
                    context,
                  );
                }

                currentIndex = 3;
              },
              buttonChild: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Continue with KwikProcure",
                    style: kwikTextStlye(
                      14.0,
                      FontWeight.w600,
                      colorCodes.whiteSmoke,
                    ),
                  ),
                  SizedBox(width: 8),
                  Image.asset(
                    "assets/images/icons/arrow-right.png",
                    height: 18,
                    width: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget fulfilproductContainer(
    title,
    subtitle,
    dataOne,
    dataTwo,
    dataThree,
    enabled,
  ) {
    return Container(
      height: 440,
      width: 390,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: colorCodes.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 1.2, color: colorCodes.antiFlashWhite),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/icons/dashboard/Frame 1000006245 (1).png",
                height: 25,
                width: 25,
              ),
              SizedBox(width: 10),
              Text(
                title,
                style: kwikTextStlye(14.0, FontWeight.w600, colorCodes.black),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              SizedBox(width: 18),
              SizedBox(
                width: 265,
                child: Text(
                  subtitle,
                  style: kwikTextStlye(
                    12.0,
                    FontWeight.w300,
                    colorCodes.darkGrey,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(width: 25),
              Image.asset(
                "assets/images/icons/dashboard/Frame 1000006245.png",
                height: 25,
                width: 25,
              ),
              SizedBox(width: 6),
              SizedBox(
                width: 226,
                child: Text(
                  dataOne,
                  style: kwikTextStlye(
                    10.0,
                    FontWeight.w500,
                    colorCodes.darkGrey,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 7),
          Row(
            children: [
              SizedBox(width: 25),
              Image.asset(
                "assets/images/icons/dashboard/Frame 1000006245.png",
                height: 25,
                width: 25,
              ),
              SizedBox(width: 6),
              SizedBox(
                width: 226,
                child: Text(
                  dataTwo,
                  style: kwikTextStlye(
                    10.0,
                    FontWeight.w500,
                    colorCodes.darkGrey,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 7),
          Row(
            children: [
              SizedBox(width: 25),
              Image.asset(
                "assets/images/icons/dashboard/Frame 1000006245.png",
                height: 25,
                width: 25,
              ),
              SizedBox(width: 5),
              SizedBox(
                width: 226,
                child: Text(
                  dataThree,
                  style: kwikTextStlye(
                    10.0,
                    FontWeight.w500,
                    colorCodes.darkGrey,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            height: 85,
            width: 285,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
              color: colorCodes.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(width: 1.0, color: colorCodes.portlandOrange),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/images/icons/dashboard/info_red.png",
                  height: 32,
                  width: 32,
                ),
                SizedBox(width: 8),
                SizedBox(
                  width: 213,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "KYC Verification Required",
                        style: kwikTextStlye(
                          12.0,
                          FontWeight.w600,
                          colorCodes.sinopia,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Complete your identity verification to submit products for verification.",
                        style: kwikTextStlye(
                          10.0,
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
          SizedBox(height: 20),
          SizedBox(
            height: 38,
            child: kwikbutton(
              "",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => KycVerificationScreen(
                          kwikticket: widget.kwikticket,
                        ),
                  ),
                );
                currentIndex = 3;
              },
              buttonChild: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Start  KYC Verification",
                    style: kwikTextStlye(
                      14.0,
                      FontWeight.w600,
                      colorCodes.whiteSmoke,
                    ),
                  ),
                  SizedBox(width: 8),
                  Image.asset(
                    "assets/images/icons/arrow-right.png",
                    height: 18,
                    width: 18,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 38,
            child: kwikbutton(
              "",
              () {},
              buttonChild: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Verify my product",
                    style: kwikTextStlye(
                      14.0,
                      FontWeight.w600,
                      enabled == true
                          ? colorCodes.whiteSmoke
                          : colorCodes.aluminium,
                    ),
                  ),
                  SizedBox(width: 8),
                  Image.asset(
                    "assets/images/icons/arrow-right.png",
                    height: 18,
                    width: 18,
                  ),
                ],
              ),
              enabled: enabled,
            ),
          ),
        ],
      ),
    );
  }
}
