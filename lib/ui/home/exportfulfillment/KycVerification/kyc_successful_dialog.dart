import 'package:flutter/material.dart';
import 'package:kwik_port/api/controller/home/dashboard_api.dart';
import 'package:kwik_port/api/controller/kwikTickets/fund_ticket_api.dart';
import 'package:kwik_port/api/model/dashboard_model.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/main.dart';
import 'package:kwik_port/ui/home/dashboard/dashboard.dart';
import 'package:kwik_port/ui/home/exportfulfillment/KycVerification/fund_export_contract.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:kwik_port/utils/toast.dart';
import 'package:provider/provider.dart';

class KycSuccessfulDialog extends StatefulWidget {
  final KwikTicketModel kwikticket;

  const KycSuccessfulDialog({super.key, required this.kwikticket});

  @override
  State<KycSuccessfulDialog> createState() => _KycSuccessfulDialogState();
}

class _KycSuccessfulDialogState extends State<KycSuccessfulDialog> {
  @override
  Widget build(BuildContext context) {
    final dashboardApi = Provider.of<DashboardApi>(context);

    final fundTicketApi = Provider.of<FundKwikticketApi>(
      context,
      listen: false,
    );
    return SizedBox(
      width: 390,
      child: Dialog(
        child: Container(
          height: 770,
          width: 390,
          decoration: BoxDecoration(
            color: colorCodes.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorCodes.antiFlashWhite, width: 1.2),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24),
          child: ListView(
            children: [
              Column(
                children: [
                  Image.asset(
                    "assets/images/icons/procuement_select_check.png",
                    height: 96,
                    width: 113,
                  ),
                  SizedBox(height: 40),
                  Text(
                    "KYC Submitted Successfully!",
                    style: kwikTextStlye(
                      16.0,
                      FontWeight.w600,
                      colorCodes.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Your documents are being reviewed and it may take a while.",
                    textAlign: TextAlign.center,
                    style: kwikTextStlye(
                      14.0,
                      FontWeight.w300,
                      colorCodes.graniteGrey,
                    ),
                  ),
                  SizedBox(height: 25),
                  Container(
                    height: 230,
                    width: 342,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    decoration: BoxDecoration(
                      color: colorCodes.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        width: 1.5,
                        color: colorCodes.gainsboro,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "What happens next?",
                          style: kwikTextStlye(
                            14.0,
                            FontWeight.w500,
                            colorCodes.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        whatHappensRow(
                          "assets/images/icons/dashboard/Frame 1000006030 green.png",
                          "Documents Submitted",
                          "Your KYC documents have been recieved",
                        ),
                        SizedBox(height: 10),
                        whatHappensRow(
                          "assets/images/icons/dashboard/Frame 1000006029.png",
                          "Under Review",
                          "Our team is verifying your documents",
                        ),
                        SizedBox(height: 10),
                        whatHappensRow(
                          "assets/images/icons/dashboard/Frame 1000006030 grey.png",
                          "Verification Complete",
                          "You will recieve email notification when verified",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    height: 95,
                    width: 346,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
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
                          // height: 100,
                          width: 235,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Goodnews!",
                                style: kwikTextStlye(
                                  14.0,
                                  FontWeight.w600,
                                  colorCodes.black,
                                ),
                              ),
                              Text(
                                "You can continue with Kwikprocure export services while we verify your documents.",
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
                  SizedBox(height: 12),
                  kwikbutton("Proceed to Kwikprocure", () {
                    setState(() => fundTicketApi.loading = true);

                    fundTicketApi.fundTicket(
                      kwikTicketId: widget.kwikticket.id.toString(),
                      exporterId: widget.kwikticket.exporter!.id.toString(),
                      // dashboardApi.data!.e, //.toString(),
                    );

                    setState(() => fundTicketApi.loading = false);

                    if (fundTicketApi.isSuccessful == true &&
                        fundTicketApi.authorizationUrl != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => FundExportContract(
                                kwikticket: widget.kwikticket,
                                url: fundTicketApi.authorizationUrl!,
                                kwikTicketId: widget.kwikticket.id,
                                referenceNumber:
                                    fundTicketApi.paymentReference!,
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
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder:
                    //         (context) => FundExportContract(
                    //           kwikticket: widget.kwikticket,
                    //         ),
                    //   ),
                    // );
                    currentIndex = 3;
                  }),
                  SizedBox(height: 12),
                  kwikbutton(
                    "Back to Home",
                    () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Dashboard()),
                      );
                      currentIndex = 1;
                    },
                    backgroundcolor: colorCodes.white,
                    textColor: colorCodes.black,
                    borderColor: colorCodes.antiFlashWhite,
                    fontSize: 12.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  whatHappensRow(img, title, subtitle) {
    return SizedBox(
      width: 275,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(img, height: 20, width: 20),
          SizedBox(width: 4),
          SizedBox(
            width: 210,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: kwikTextStlye(14.0, FontWeight.w600, colorCodes.black),
                ),
                Text(
                  subtitle,
                  textAlign: TextAlign.start,
                  style: kwikTextStlye(11.0, FontWeight.w300, colorCodes.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
