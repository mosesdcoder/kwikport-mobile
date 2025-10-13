import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/api/controller/agency/export_substage_api.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/home/dashboard/exportJourney/export_complete_screen.dart';
import 'package:kwik_port/ui/home/dashboard/exportJourney/packaging_and_documentation.dart';
import 'package:kwik_port/ui/home/profile/export_accordion.dart';
import 'package:kwik_port/utils/button/back_nav_header.dart';
import 'package:kwik_port/utils/button/bottom_navigatior_bar.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:provider/provider.dart';

class ExportJourneyScreen extends StatefulWidget {
  final String exporterContractId;

  const ExportJourneyScreen({super.key, required this.exporterContractId});

  @override
  State<ExportJourneyScreen> createState() => _ExportJourneyScreenState();
}

class _ExportJourneyScreenState extends State<ExportJourneyScreen> {
  bool checkterms = false;
  int itemCount = 5;
  List progressTitle = [
    "Agency Assigned ",
    "Sourcing in progress 🔍",
    "Quality Grading & Checks ⚖ ️",
    "Goods Ready for Next Stage 📦",
    "Procurement complete 🎯",
  ];
  List<String> statusTexts = [
    "Pending", // Procurement
    "Pending", // Packaging
    "Pending", // Logistics
    "Pending", // Freight Forwarding
    "Pending", // Final Export
  ];
  List progressSubTitle = [
    "Your selected procurement agency is now responsible for sourcing your goods",
    "Your agency is sourcing the required commodity from verified suppliers.",
    "Your goods are being graded and inspected at the point of purchase.",
    "Your goods are ready and awaiting packaging & documentation.",
    "Your goods are ready and awaiting packaging & documentation.",
  ];
  List<List<bool>> isCheckedSections = [
    List.filled(5, false), // Procurement
    List.filled(5, false), // Packaging, Quality Control & Documentation
    List.filled(5, false), // Logistics
    List.filled(5, false), // Freight Forwarding
    List.filled(5, false), // Final Export
  ];
  List<bool> isChecked = [false, false, false, false, false];
  int selectedMainStage = 1; // you can change depending on stage

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExportSubStageApi>(context, listen: false).getSubStages(
        exporterContractId: widget.exporterContractId,
        mainStage: selectedMainStage,
      );
    });
  }

  Future<void> _refresh() async {
    await Provider.of<ExportSubStageApi>(context, listen: false).getSubStages(
      exporterContractId: widget.exporterContractId,
      mainStage: selectedMainStage,
    );
  }

  @override
  Widget build(BuildContext context) {
    final exportSubStageProvider = Provider.of<ExportSubStageApi>(context);

    return Scaffold(
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 42.0, bottom: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: backNavRow(context, "Your Export Journey"),
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
                // height: 581,
                width: 391,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                decoration: BoxDecoration(
                  color: colorCodes.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Overall Progress",
                          style: kwikTextStlye(
                            12.0,
                            FontWeight.w300,
                            colorCodes.darkGrey,
                          ),
                        ),
                        Text(
                          "15% Complete",
                          style: kwikTextStlye(
                            12.0,
                            FontWeight.w300,
                            colorCodes.darkGrey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    LinearProgressIndicator(
                      backgroundColor: HexColor("#D6E7FF"),
                      minHeight: 8,
                      value: 0.15,
                      borderRadius: BorderRadius.circular(12),
                      color: colorCodes.azureBlue,
                    ),

                    SizedBox(height: 25),
                    // ExportAccordion(title: title, statusbtntxt: statusbtntxt, statusbtnFunc: statusbtnFunc, child: child)
                    ExportAccordion(
                      title: "Procurement 🏭",
                      statusbtntxt: "Completed",
                      statusbtnFunc: () {},
                      child: SizedBox(
                        height: 450,
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          separatorBuilder:
                              (context, index) => SizedBox(height: 10),
                          itemCount: itemCount,
                          itemBuilder: (ctx, index) {
                            return checkContainer(
                              progressTitle[index],
                              isCheckedSections[0],
                              isChecked[index],
                              progressSubTitle[index],
                              false,
                              "",
                              () {
                                setState(() {
                                  isChecked[index] = !isChecked[index];
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    ExportAccordion(
                      title: "Packaging, Quality Control & Documentation 📋",
                      statusbtntxt: "Select Agency",
                      statusbtnFunc: () {},
                      child: SizedBox(
                        height: 450,
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          separatorBuilder:
                              (context, index) => SizedBox(height: 10),
                          itemCount: itemCount,
                          itemBuilder: (ctx, index) {
                            return checkContainer(
                              progressTitle[index],
                              isCheckedSections[1],
                              isChecked[index],
                              progressSubTitle[index],
                              true,
                              "2-3days",
                              () {
                                setState(() {
                                  isChecked[index] = !isChecked[index];
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    ExportAccordion(
                      title: "Logistics",
                      statusbtntxt: "Pending",
                      statusbtnFunc: () {},
                      child: SizedBox(
                        height: 450,
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          separatorBuilder:
                              (context, index) => SizedBox(height: 10),
                          itemCount: itemCount,
                          itemBuilder: (ctx, index) {
                            return checkContainer(
                              progressTitle[index],
                              isCheckedSections[2],
                              isChecked[index],
                              progressSubTitle[index],
                              true,
                              "1day",
                              () {
                                setState(() {
                                  isChecked[index] = !isChecked[index];
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    ExportAccordion(
                      title:
                          "Freight Forwarding (Port Clearance & Vessel Loading)",
                      statusbtntxt: "Pending",
                      statusbtnFunc: () {},
                      child: SizedBox(
                        height: 450,
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          separatorBuilder:
                              (context, index) => SizedBox(height: 10),
                          itemCount: itemCount,
                          itemBuilder: (ctx, index) {
                            return checkContainer(
                              progressTitle[index],
                              isCheckedSections[3],
                              isChecked[index],
                              progressSubTitle[index],
                              false,
                              "",
                              () {
                                setState(() {
                                  isChecked[index] = !isChecked[index];
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    ExportAccordion(
                      title: "Final Export",
                      statusbtntxt: "Pending",
                      statusbtnFunc: () {},
                      child: SizedBox(
                        height: 450,
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          separatorBuilder:
                              (context, index) => SizedBox(height: 10),
                          itemCount: itemCount,
                          itemBuilder: (ctx, index) {
                            return checkContainer(
                              progressTitle[index],
                              isCheckedSections[4],
                              isChecked[index],
                              progressSubTitle[index],
                              false,
                              "",
                              () {
                                setState(() {
                                  isChecked[index] = !isChecked[index];
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Container(
                height: 160,
                width: 391,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                decoration: BoxDecoration(
                  color: colorCodes.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Container(
                    //   height: 74,
                    //   width: 350,
                    //   alignment: Alignment.center,
                    //   padding: EdgeInsets.symmetric(
                    //     horizontal: 10,
                    //     vertical: 15,
                    //   ),
                    //   decoration: BoxDecoration(
                    //     color: colorCodes.floralWhite,
                    //     borderRadius: BorderRadius.circular(16),
                    //     border: Border.all(
                    //       width: 1.5,
                    //       color: colorCodes.sunset,
                    //     ),
                    //   ),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Image.asset(
                    //         "assets/images/icons/dashboard/Frame 10000060291.png",
                    //         height: 25,
                    //         width: 25,
                    //       ),
                    //       SizedBox(width: 12),
                    //       SizedBox(
                    //         width: 211,
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Text(
                    //               "Action Required: Packaging & Documentation",
                    //               style: kwikTextStlye(
                    //                 14.0,
                    //                 FontWeight.w600,
                    //                 colorCodes.black,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(height: 10),
                    Container(
                      height: 104,
                      width: 350,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        color: colorCodes.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          width: 1.5,
                          color: colorCodes.sunset,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            "assets/images/icons/dashboard/Frame 10000060291.png",
                            height: 24,
                            width: 24,
                          ),
                          SizedBox(width: 8),
                          SizedBox(
                            width: 238,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Agency Selction Required",
                                  style: kwikTextStlye(
                                    14.0,
                                    FontWeight.w600,
                                    colorCodes.sinopia,
                                  ),
                                ),
                                Text(
                                  "Procurement is complete. Select a packaging & documentation agency to continue your export journey.",
                                  style: kwikTextStlye(
                                    10.0,
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
                  ],
                ),
              ),
              SizedBox(height: 15),
              kwikbutton(
                "Select Packaging Agency",
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PackagingAndDocumentation(),
                    ),
                  );
                },
                buttonChild: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Select Packaging Agency",
                      style: kwikTextStlye(
                        14.0,
                        FontWeight.w600,
                        // enabled == true
                        //     ?
                        colorCodes.whiteSmoke,
                        // : colorCodes.aluminium,
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
              SizedBox(height: 10),
              kwikbutton("Complete Export", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExportCompleteScreen(),
                  ),
                );
              }),
              SizedBox(height: 25),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Bottomnavigationbar(1),
    );
  }

  Widget checkContainer(
    title,
    isCheckedSection,
    checkterms,
    subtitle,
    delay,
    delaydate,
    checkFunc,
  ) {
    return Container(
      height: 75,
      width: 335,
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: colorCodes.whiteSmoke,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: checkFunc,
            child:
                checkterms == true
                    ? Image.asset(
                      "assets/images/icons/dashboard/Checkbox (1).png",
                      height: 23,
                      width: 23,
                    )
                    : Container(
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: colorCodes.frenchSkyBlue,
                          width: 1.5,
                        ),

                        color: colorCodes.white,
                        borderRadius: BorderRadius.circular(
                          6,
                        ), // rounded corners
                      ),
                    ),
          ),
          SizedBox(width: 5),
          SizedBox(
            width: 220,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.start,
                      style: kwikTextStlye(
                        10.0,
                        FontWeight.w500,
                        colorCodes.black,
                      ),
                    ),
                    delay == true
                        ? Container(
                          width: 57,
                          height: 20,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: colorCodes.white,
                            borderRadius: BorderRadius.circular(22.03),
                            border: Border.all(
                              color: colorCodes.antiFlashWhite,
                              width: 1, // border-width
                            ),
                          ),
                          child: Text(
                            delaydate,
                            style: kwikTextStlye(
                              10.0,
                              FontWeight.w400,
                              colorCodes.textBlack,
                            ),
                          ),
                        )
                        : SizedBox(width: 10),
                  ],
                ),
                // SizedBox(height: 2),
                Text(
                  subtitle,
                  textAlign: TextAlign.start,
                  style: kwikTextStlye(10.0, FontWeight.w300, colorCodes.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
