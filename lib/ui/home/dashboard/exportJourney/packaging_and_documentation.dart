import 'package:flutter/material.dart';
import 'package:kwik_port/api/controller/agency/export_stage_api.dart';
import 'package:kwik_port/api/controller/agency/get_agency_api.dart';
import 'package:kwik_port/api/model/dashboard_model.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/home/dashboard/exportJourney/export_journey_screen.dart';
import 'package:kwik_port/ui/home/dashboard/procurement%20Agency/agency_selection_confirmed_dialog.dart';
import 'package:kwik_port/ui/home/dashboard/procurement%20Agency/confirm_agency_selection_dialog.dart';
import 'package:kwik_port/utils/button/back_nav_header.dart';
import 'package:kwik_port/utils/button/bottom_navigatior_bar.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/button/loading_dialog.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:kwik_port/utils/toast.dart';
import 'package:provider/provider.dart';

class PackagingAndDocumentation extends StatefulWidget {
  final KwikTicketModel? kwikticket;
  final int stageType;

  const PackagingAndDocumentation({
    super.key,
    required this.kwikticket,
    required this.stageType,
  });

  @override
  State<PackagingAndDocumentation> createState() =>
      _PackagingAndDocumentationState();
}

class _PackagingAndDocumentationState extends State<PackagingAndDocumentation> {
  int itemCount = 5;
  String? selectedAgencyId;
  String? selectedAgencyName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GetAgencyApi>(
        context,
        listen: false,
      ).fetchAgenciesByStageType(widget.stageType);
    });
  }

  @override
  Widget build(BuildContext context) {
    final agencyApi = Provider.of<GetAgencyApi>(context);
    final exportStageApi = Provider.of<ExportStageApi>(context, listen: false);

    return Scaffold(
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 42.0, bottom: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: backNavRow(
              context,
              "Packaging & Documentation",
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      backgroundColor: colorCodes.whiteSmoke,
      body: ListView(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 65),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 138,
                width: 390,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
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
                    SizedBox(width: 8),
                    SizedBox(
                      width: 265,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Export Documentation & Packaging",
                            style: kwikTextStlye(
                              14.0,
                              FontWeight.w600,
                              colorCodes.black,
                            ),
                          ),
                          Text(
                            "Your gross export earning is already credited in your KwikLC wallet. Agency fees for Packaging, Quality & Documentation will be automatically deducted in USD before withdrawal becomes available",
                            textAlign: TextAlign.start,
                            style: kwikTextStlye(
                              12.0,
                              FontWeight.w300,
                              colorCodes.jetBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select Packaging Agency",
                  style: kwikTextStlye(16.0, FontWeight.w600, colorCodes.black),
                ),
              ),
              SizedBox(height: 20),
              if (agencyApi.loading) const CircularProgressIndicator(),
              if (!agencyApi.loading && agencyApi.agencies.isEmpty)
                const Text('No agencies found'),
              if (!agencyApi.loading && agencyApi.agencies.isNotEmpty)
                ListView.separated(
                  itemCount: agencyApi.agencies.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (ctx, index) {
                    final agency = agencyApi.agencies[index];
                    final id = agency.id ?? '';
                    final name = agency.name ?? 'Unnamed';
                    final fee = agency.serviceFee?.toString() ?? '0';
                    final days =
                        agency.numberOfDaysToDeliver?.toString() ?? '-';
                    final rating = (agency.rating?.toDouble());

                    return selectPakagingAgency(
                      "assets/images/icons/dashboard/procurement_agency_logo.png",
                      name,
                      "₦$fee",
                      "\$$fee",
                      rating,
                      "145 reviews",
                      "$days days",
                      // "${daysToHours(int.tryParse(days) ?? 0)}hours",
                      "Phytosanitary Cert", //Not done
                      2,
                      false,

                      () async {
                        // if (selectedAgencyId == null) {
                        //   showToastContainer(
                        //     "Agency",
                        //     "Please select an agency first",
                        //     colorCodes.mistyRose,
                        //     colorCodes.portlandOrange,
                        //     context,
                        //   );

                        //   return;
                        // }
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return LoadingDialog();
                          },
                        );
                        await exportStageApi.selectAgency(
                          exporterContractId:
                              widget.kwikticket?.exporter?.id ?? '',
                          agencyId: agency.id!,
                          stageType: widget.stageType,
                        );

                        Navigator.pop(context);
                        if (exportStageApi.success) {
                          // ✅ On success — show confirmation flow
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return ConfirmAgencySelectionDialog(
                                serviceFee: "\$50",
                                totalcostTons: "20.5",
                                totalCost: "₦246,000,000",
                                agencyName: selectedAgencyName ?? "",
                                kwikticket: widget.kwikticket,
                                // confirmFunc: () {
                                // Navigator.pop(context); // close confirmation dialog

                                // showDialog(
                                //   barrierDismissible: false,
                                //   context: context,
                                //   builder: (BuildContext context) {
                                //     return AgencySelectionConfirmedDialog(
                                //       serviceFee: "\$50",
                                //       totalcostTons: "20.5",
                                //       totalCost: "₦246,000,000",
                                //       continueFunc: () {
                                //         Navigator.pop(
                                //           context,
                                //         ); // close success dialog

                                // // ✅ Go to ExportJourneyScreen and make it UNPOPABLE
                                // Navigator.pushAndRemoveUntil(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder:
                                //         (_) => ExportJourneyScreen(
                                //           kwikticket: widget.kwikticket,
                                //           // ?.exporterContractId ??
                                //           // '',
                                //         ),
                                //             ),
                                //             (Route<dynamic> route) => false,
                                //           );
                                //         },
                                //       );
                                //     },
                                //   );
                                // },
                                agencyId: selectedAgencyId!,
                              );
                            },
                          );
                        }
                      },
                    );
                  },
                ),

              kwikbutton(
                "Confirm Agency Selection",
                () {},
                // () async {
                //   if (selectedAgencyId == null) {
                //     showToastContainer(
                //       "Agency",
                //       "Please select an agency first",
                //       colorCodes.mistyRose,
                //       colorCodes.portlandOrange,
                //       context,
                //     );

                //     return;
                //   }
                //   showDialog(
                //     context: context,
                //     builder: (BuildContext context) {
                //       return LoadingDialog();
                //     },
                //   );
                //   await exportStageApi.selectAgency(
                //     exporterContractId: widget.kwikticket?.exporter?.id ?? '',
                //     agencyId: selectedAgencyId!,
                //     stageType: widget.stageType,
                //   );

                //   Navigator.pop(context);
                //   if (exportStageApi.success) {
                //     // ✅ On success — show confirmation flow
                //     showDialog(
                //       barrierDismissible: false,
                //       context: context,
                //       builder: (BuildContext context) {
                //         return ConfirmAgencySelectionDialog(
                //           serviceFee: "\$50",
                //           totalcostTons: "20.5",
                //           totalCost: "₦246,000,000",
                //           agencyName: selectedAgencyName ?? "",
                //           kwikticket: widget.kwikticket,
                //           // confirmFunc: () {
                //           // Navigator.pop(context); // close confirmation dialog

                //           // showDialog(
                //           //   barrierDismissible: false,
                //           //   context: context,
                //           //   builder: (BuildContext context) {
                //           //     return AgencySelectionConfirmedDialog(
                //           //       serviceFee: "\$50",
                //           //       totalcostTons: "20.5",
                //           //       totalCost: "₦246,000,000",
                //           //       continueFunc: () {
                //           //         Navigator.pop(
                //           //           context,
                //           //         ); // close success dialog

                //           // // ✅ Go to ExportJourneyScreen and make it UNPOPABLE
                //           // Navigator.pushAndRemoveUntil(
                //           //   context,
                //           //   MaterialPageRoute(
                //           //     builder:
                //           //         (_) => ExportJourneyScreen(
                //           //           kwikticket: widget.kwikticket,
                //           //           // ?.exporterContractId ??
                //           //           // '',
                //           //         ),
                //           //             ),
                //           //             (Route<dynamic> route) => false,
                //           //           );
                //           //         },
                //           //       );
                //           //     },
                //           //   );
                //           // },
                //           agencyId: selectedAgencyId!,
                //         );
                //       },
                //     );
                //   }
                //   // showDialog(
                //   //   barrierDismissible: false,
                //   //   context: context,

                //   //   builder: (BuildContext context) {
                //   //     return ConfirmAgencySelectionDialog(
                //   //       serviceFee: "\$50",
                //   //       totalcostTons: "20.5",
                //   //       totalCost: "₦246,000,000",
                //   // confirmFunc: () {
                //   //   Navigator.pop(context);
                //   //   showDialog(
                //   //     barrierDismissible: false,
                //   //     context: context,

                //   //     builder: (BuildContext context) {
                //   //       return AgencySelectionConfirmedDialog(
                //   //         serviceFee: "\$50",
                //   //         totalcostTons: "20.5",
                //   //         totalCost: "₦246,000,000",
                //   //         continueFunc: () {
                //   //           Navigator.push(
                //   //             context,
                //   //             MaterialPageRoute(
                //   //               builder:
                //   //                   (context) => ExportJourneyScreen(
                //   //                     exporterContractId: '',
                //   //                   ),
                //   //             ),
                //   //           );
                //   //         },
                //   //       );
                //   //     },
                //   //   );
                //   // },
                //   // agencyName: "",
                //   // kwikticket: widget.kwikticket,
                //   //   );
                //   // },
                //   // );
                // },
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
                      "Confirm Agency Selection",
                      style: kwikTextStlye(
                        14.0,
                        FontWeight.w500,
                        colorCodes.whiteSmoke,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Bottomnavigationbar(1),
    );
  }

  int daysToHours(int days) {
    return days * 24;
  }

  Widget selectPakagingAgency(
    agencyLogo,
    agencyName,
    cost,
    convertedcost,
    agencyRatings,
    amountofreviews,
    lengthofJourney,
    agencydetail,
    agencydetailindex,
    enabled,
    selectFunc,
  ) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          decoration: BoxDecoration(
            color: colorCodes.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(agencyLogo, height: 40, width: 40),
                      SizedBox(width: 5),
                      SizedBox(
                        width: 150,
                        child: Text(
                          agencyName,
                          style: kwikTextStlye(
                            14.0,
                            FontWeight.w600,
                            colorCodes.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    cost,
                    style: kwikTextStlye(
                      12.0,
                      FontWeight.w600,
                      colorCodes.black,
                      fontFamily: "",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 40),
                      Image.asset(
                        'assets/images/icons/dashboard/star_filled.png',
                        height: 14,
                        width: 15,
                      ),
                      SizedBox(width: 3),
                      Text(
                        "($agencyRatings)",
                        style: kwikTextStlye(
                          12.0,
                          FontWeight.w300,
                          colorCodes.graniteGrey,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        "$amountofreviews",
                        style: kwikTextStlye(
                          12.0,
                          FontWeight.w300,
                          colorCodes.graniteGrey,
                        ),
                      ),
                      SizedBox(width: 10),

                      Image.asset(
                        'assets/images/icons/clock.png',
                        height: 15,
                        width: 15,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "$lengthofJourney",
                        style: kwikTextStlye(
                          12.0,
                          FontWeight.w300,
                          colorCodes.graniteGrey,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "(~$convertedcost)",
                    style: kwikTextStlye(
                      10.0,
                      FontWeight.w300,
                      colorCodes.graniteGrey,
                      fontFamily: "",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: List.generate(
                  agencydetailindex,
                  (index) => Container(
                    height: 23,
                    // width: 110,
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorCodes.antiFlashWhite,
                      border: Border.all(
                        color: colorCodes.whiteSmoke,
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Text(
                      "$agencydetail",
                      style: kwikTextStlye(
                        10.0,
                        FontWeight.w500,
                        colorCodes.black,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  // Container(
                  //   height: 23,
                  //   width: 110,
                  //   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                  //   decoration: BoxDecoration(
                  //     color: colorCodes.antiFlashWhite,
                  //     border: Border.all(
                  //       color: colorCodes.whiteSmoke,
                  //       width: 1.2,
                  //     ),
                  //     borderRadius: BorderRadius.circular(22),
                  //   ),
                  //   child: Text(
                  //     "$agencydetail",
                  //     style: kwikTextStlye(
                  //       10.0,
                  //       FontWeight.w500,
                  //       colorCodes.black,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        kwikbutton("Select", selectFunc, enabled: enabled),
      ],
    );
  }
}
