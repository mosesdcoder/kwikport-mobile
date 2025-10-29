import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/api/controller/agency/export_stage_api.dart';
import 'package:kwik_port/api/controller/home/dashboard_api.dart';
import 'package:kwik_port/api/model/dashboard_model.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/home/dashboard/exportJourney/export_journey_screen.dart';
import 'package:kwik_port/ui/home/dashboard/procurement%20Agency/agency_selection_confirmed_dialog.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/button/loading_dialog.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:kwik_port/utils/toast.dart';
import 'package:provider/provider.dart';

class ConfirmAgencySelectionDialog extends StatefulWidget {
  final KwikTicketModel? kwikticket;

  final agencyName, serviceFee, totalcostTons, totalCost, agencyId;
  const ConfirmAgencySelectionDialog({
    super.key,
    required this.serviceFee,
    required this.totalcostTons,
    required this.totalCost,
    required this.agencyName,
    required this.kwikticket,
    required this.agencyId,
  });

  @override
  State<ConfirmAgencySelectionDialog> createState() =>
      _ConfirmAgencySelectionDialogState();
}

class _ConfirmAgencySelectionDialogState
    extends State<ConfirmAgencySelectionDialog> {
  @override
  Widget build(BuildContext context) {
    final selectagencyProvider = Provider.of<ExportStageApi>(context);
    final dashboardApi = Provider.of<DashboardApi>(context);

    return SizedBox(
      width: 390,
      child: Dialog(
        child: Container(
          height: 810,

          width: 390,
          decoration: BoxDecoration(
            color: colorCodes.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorCodes.antiFlashWhite, width: 1.2),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 24),
          child: ListView(
            children: [
              Column(
                children: [
                  Image.asset(
                    "assets/images/icons/account_successimg.png",
                    height: 96,
                    width: 113,
                  ),
                  SizedBox(height: 40),
                  Text(
                    "Confirm Agency Selection",
                    style: kwikTextStlye(
                      18.0,
                      FontWeight.w600,
                      colorCodes.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Review your agency selection and confirm to proceed with your export contract.",
                    textAlign: TextAlign.center,
                    style: kwikTextStlye(
                      14.0,
                      FontWeight.w300,
                      colorCodes.graniteGrey,
                    ),
                  ),
                  SizedBox(height: 25),
                  Container(
                    // height: 462,
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
                          widget.agencyName,
                          style: kwikTextStlye(
                            18.0,
                            FontWeight.w400,
                            colorCodes.black,
                          ),
                        ),
                        SizedBox(height: 24),
                        Container(
                          height: 92,
                          width: 308,
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
                                    "Total Cost (${widget.totalcostTons} tons)",
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
                        kwikbutton("Confirm Selection", () async {
                          // Navigator.pop(context);
                          debugPrint(
                            '🛠 ExporterContractId: ${dashboardApi.data?.exports.last.id}', //widget.kwikticket?.exporter?.
                          );
                          // widget.kwikticket?.exporter?.id
                          //dashboardApi.data?.userProfile?.
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => kwikportloader(),
                          );

                          // final selectAgencyApi = Provider.of<ExportStageApi>(
                          //   context,
                          //   listen: false,
                          // );

                          selectagencyProvider
                              .selectAgency(
                                exporterContractId:
                                    dashboardApi.data?.exports?.last.id ?? "",
                                // widget.kwikticket?.exporter?.id ?? '',
                                // ?.first

                                // widget.kwikticket?.exporter?.id ?? '',
                                agencyId: widget.agencyId,
                                stageType: 2,
                              )
                              .then((_) {
                                Navigator.pop(context);
                                if (selectagencyProvider.success) {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AgencySelectionConfirmedDialog(
                                        serviceFee: "${widget.serviceFee}",
                                        totalcostTons:
                                            "${widget.totalcostTons}",
                                        totalCost:
                                            "${widget.kwikticket?.kwikTicketAmount}",
                                        continueFunc: () async {
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (_) => ExportJourneyScreen(
                                                    kwikticket:
                                                        widget.kwikticket,
                                                    // ?.exporterContractId ??
                                                    // '',
                                                  ),
                                            ),
                                            (Route<dynamic> route) => false,
                                          );
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder:
                                          //         (context) => ExportJourneyScreen(
                                          //           kwikticket: widget.kwikticket,
                                          //           //     ?.exportContractId ??
                                          //           // "Unknown id",
                                          //         ),
                                          //   ),
                                          // );
                                        },
                                      );
                                    },
                                  );
                                } else {
                                  Navigator.pop(context);
                                  showToastContainer(
                                    "Procurement Agency",
                                    selectagencyProvider.message,
                                    colorCodes.mistyRose,
                                    colorCodes.portlandOrange,
                                    context,
                                  );
                                }
                              });
                          Navigator.pop(context);
                        }),
                        SizedBox(height: 12),
                        kwikbutton(
                          "Cancel",
                          () {
                            Navigator.pop(context);
                          },
                          backgroundcolor: colorCodes.white,
                          textColor: colorCodes.black,
                          borderColor: colorCodes.antiFlashWhite,
                          fontSize: 12.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
