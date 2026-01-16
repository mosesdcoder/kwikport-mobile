import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/api/model/dashboard_model.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/home/dashboard/exportJourney/export_journey_screen.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

class AgencySelectionConfirmedDialog extends StatefulWidget {
  final serviceFee, totalcostTons, totalCost, agencyName;
  final KwikTicketModel? kwikticket;
  final ExportSummaryModel exportData;
  
  const AgencySelectionConfirmedDialog({
    super.key,
    required this.serviceFee,
    required this.totalcostTons,
    required this.totalCost,
    required this.agencyName,
    required this.kwikticket,
    required this.exportData,
  });

  @override
  State<AgencySelectionConfirmedDialog> createState() =>
      _AgencySelectionConfirmedDialogState();
}

class _AgencySelectionConfirmedDialogState
    extends State<AgencySelectionConfirmedDialog> {
  @override
  Widget build(BuildContext context) {
    debugPrint('AgencySelectionConfirmedDialog: totalcostTons = \'${widget.totalcostTons}\'');
    return SizedBox(
      width: 390,
      child: Dialog(
        child: Container(
          // height: 704, // Remove fixed height to allow scrolling
          width: 390,
          decoration: BoxDecoration(
            color: colorCodes.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorCodes.antiFlashWhite, width: 1.2),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/images/icons/procuement_select_check.png",
                  height: 96,
                  width: 113,
                ),
                SizedBox(height: 40),
                Text(
                  "Agency Selection Confirmed!",
                  style: kwikTextStlye(
                    16.0,
                    FontWeight.w500,
                    colorCodes.black,
                  ),
                ),
                SizedBox(height: 25),
                  Container(
                    height: 340,

                    width: 342,
                    decoration: BoxDecoration(
                      color: colorCodes.whiteSmoke,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: colorCodes.antiFlashWhite,
                        width: 1.2,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/icons/dashboard/procurement_agency_logo.png",
                          height: 52,
                          width: 52,
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.agencyName ?? '',
                          style: kwikTextStlye(
                            16.0,
                            FontWeight.w600,
                            colorCodes.black,
                          ),
                        ),
                        SizedBox(height: 24),
                        Container(
                          height: 92,
                          width: 304,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: HexColor("#E7E7E7"),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Service fee:",
                                    textAlign: TextAlign.center,
                                    style: kwikTextStlye(
                                      14.0,
                                      FontWeight.w300,
                                      colorCodes.aluminium,
                                    ),
                                  ),
                                  Text(
                                    widget.serviceFee,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: "",
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: colorCodes.graniteGrey,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total Cost (${widget.totalcostTons} Tons)",
                                    textAlign: TextAlign.center,
                                    style: kwikTextStlye(
                                      10.0,
                                      FontWeight.w500,
                                      colorCodes.black,
                                    ),
                                  ),
                                  Text(
                                    widget.totalCost,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: "",
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w500,
                                      color: colorCodes.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          "This will be automatically deducted from your KwikLC wallet.",
                          textAlign: TextAlign.center,
                          style: kwikTextStlye(
                            12.0,
                            FontWeight.w500,
                            colorCodes.graniteGrey,
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                  kwikbutton(
                    "Continue your export tracking",
                    () async {
                      // Log debug info BEFORE any dialog or navigation
                      debugPrint("🚗 'Continue your export tracking' clicked");
                      debugPrint("  - ExportData ID: ${widget.exportData.contractId}");
                      debugPrint("  - KwikTicket ID: ${widget.kwikticket?.id}");

                      // Show loading indicator
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(colorCodes.yellowOrange),
                            ),
                          );
                        },
                      );

                      // Small delay to ensure API has processed the selection
                      await Future.delayed(Duration(milliseconds: 500));

                      // Close loading dialog
                      if (context.mounted) {
                        Navigator.pop(context);
                      }

                      // Close all remaining dialogs and navigation stack
                      if (context.mounted) {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      }

                      // Navigate to ExportJourneyScreen
                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ExportJourneyScreen(
                              kwikticket: widget.kwikticket,
                              exporterContractId: widget.exportData.exporterContractId ?? "",
                              exportData: widget.exportData,
                            ),
                          ),
                        );
                      }
                    },
                    buttonChild: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/icons/dashboard/driving.png",
                          height: 18,
                          width: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Continue your export tracking",
                          style: kwikTextStlye(
                            12.0,
                            FontWeight.w500,
                            colorCodes.whiteSmoke,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ),
      ),
    );
  }
}
