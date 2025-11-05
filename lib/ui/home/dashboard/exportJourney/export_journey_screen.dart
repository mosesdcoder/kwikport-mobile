import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/api/controller/agency/export_substage_api.dart';
import 'package:kwik_port/api/model/dashboard_model.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/main.dart';
import 'package:kwik_port/ui/home/dashboard/dashboard.dart';
import 'package:kwik_port/ui/home/dashboard/exportJourney/export_complete_screen.dart';
import 'package:kwik_port/ui/home/dashboard/exportJourney/journey_check_list.dart';
import 'package:kwik_port/ui/home/dashboard/exportJourney/packaging_and_documentation.dart';
import 'package:kwik_port/ui/home/profile/export_accordion.dart';
import 'package:kwik_port/utils/button/back_nav_header.dart';
import 'package:kwik_port/utils/button/bottom_navigatior_bar.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:kwik_port/utils/toast.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart'; // at the top of file

class ExportJourneyScreen extends StatefulWidget {
  // final String exporterContractId;
  final KwikTicketModel? kwikticket;
  final String exporterContractId;

  const ExportJourneyScreen({
    super.key,
    required this.kwikticket,
    required this.exporterContractId,
  });

  @override
  State<ExportJourneyScreen> createState() => _ExportJourneyScreenState();
}

enum StageStatus { pending, selectAgency, inProgress, completed }

class _ExportJourneyScreenState extends State<ExportJourneyScreen> {
  Timer? _autoCompleteTimer;
  void _startAutoCompleteTimer(int currentStageIndex) {
    // Only first stage should auto-complete
    if (currentStageIndex != 0) return;

    _autoCompleteTimer?.cancel();

    _autoCompleteTimer = Timer(const Duration(minutes: 1), () {
      setState(() {
        stageStates[currentStageIndex] = StageStatus.completed;

        // Unlock next stage to "Select Agency"
        if (currentStageIndex + 1 < stageStates.length) {
          stageStates[currentStageIndex + 1] = StageStatus.selectAgency;
        }
      });

      showToastContainer(
        "Stage Completed Automatically 🎉",
        "${_stageTitles[currentStageIndex]} marked as complete after 5 minutes.",
        colorCodes.azureBlue,
        colorCodes.mediumSeaGreen,
        context,
      );
    });
    // Unlock next stage
    // _unlockNextStage(
    //   currentStageIndex + 2,
    // ); // +1 for next stage, +1 because index is 0-based
    // });
  }

  bool checkterms = false;
  int itemCount = 5;
  String packagingButtonText = "Select Packaging Agency";
  bool agencySelected = false;
  bool isLoading = true;

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
  // int selectedMainStage = 1; // you can change depending on stage

  final List<String> _stageTitles = [
    "Procurement 🏭",
    "Packaging, Quality Control & Documentation 📋",
    "Logistics 🚚",
    "Freight Forwarding (Port Clearance & Vessel Loading) ⚓",
    "Final Export 🌍",
  ];

  late List<StageStatus> stageStates;
  int selectedMainStage = 2;
  void _updateSectionCompletion(int sectionIndex) {
    final allChecked = isCheckedSections[sectionIndex].every((v) => v);
    if (allChecked) {
      setState(() {
        stageStates[sectionIndex] = StageStatus.completed;
      });
      showToastContainer(
        "Stage Complete 🎉",
        "${_stageTitles[sectionIndex]} marked as complete.",
        colorCodes.azureBlue,
        colorCodes.mediumSeaGreen,
        context,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    stageStates = [
      StageStatus.inProgress, // Procurement
      StageStatus.pending, // Packaging
      StageStatus.pending, // Logistics
      StageStatus.pending, // Freight Forwarding
      StageStatus.pending, // Final Export
    ];
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // In ExportJourneyScreen initState or when starting journey
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('journeyInProgress', true);
      await prefs.setString(
        'activeExportContractId',
        widget.exporterContractId,
      );
      await prefs.setBool('procurementCompleted', true);
      await prefs.setBool('procurementInProgress', false);
      await prefs.remove('procurementStartTime');

      // _startAutoCompleteTimer(currentIndex); // 0 = Procurement stage
      _fetchStage(selectedMainStage);
    });
  }

  @override
  void dispose() {
    // _autoCompleteTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchStage(int mainStage) async {
    final api = Provider.of<ExportSubStageApi>(context, listen: false);
    await api.getSubStages(
      exporterContractId: widget.exporterContractId ?? "",
      mainStage: mainStage,
      // await Provider.of<ExportSubStageApi>(context, listen: false).getSubStages(
      //   exporterContractId: widget.exporterContractId,
      //   mainStage: mainStage,
    );
    // Determine status of current stage
    final allCompleted = api.subStages.every((s) => s.isCompleted);

    if (mainStage == 2 && allCompleted) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('procurementCompleted', true);
      await prefs.setBool('procurementInProgress', false);
      _unlockNextStage(3);
      setState(() {
        stageStates[0] = StageStatus.completed; // Procurement done
      });
    }
    if (mainStage == 3 && allCompleted) {
      _unlockNextStage(4);
    }
    if (mainStage == 4 && allCompleted) {
      _unlockNextStage(5);
    }
    if (mainStage == 5 && allCompleted) {
      _unlockNextStage(6);
    }
    setState(() {});
  }

  // void _unlockNextStage(int nextStage) {
  //   if (nextStage <= stageStates.length) {
  //     setState(() {
  //       stageStates[nextStage - 1] = StageStatus.selectAgency;
  //     });
  //   }
  // }
  void _unlockNextStage(int nextStage) {
    if (nextStage <= stageStates.length) {
      setState(() {
        stageStates[nextStage - 1] = StageStatus.selectAgency;
      });
    }
  }

  Future<void> _refresh() async {
    await _fetchStage(selectedMainStage);
  }

  String _getButtonText(StageStatus status) {
    switch (status) {
      case StageStatus.completed:
        return "Completed";
      case StageStatus.inProgress:
        return "In Progress";
      case StageStatus.selectAgency:
        return "Select Agency";
      default:
        return "Pending";
    }
  }

  Color _getButtonColor(StageStatus status) {
    switch (status) {
      case StageStatus.completed:
        return colorCodes.pigmentGreen;
      case StageStatus.inProgress:
        return colorCodes.azureBlue;
      case StageStatus.selectAgency:
        return colorCodes.yellowOrange;
      default:
        return colorCodes.aluminium;
    }
  }

  @override
  Widget build(BuildContext context) {
    final exportSubStageProvider = Provider.of<ExportSubStageApi>(context);
    final subStages = exportSubStageProvider.subStages;
    // Determine current progress
    bool procurementCompleted = true; // already selected before this screen
    bool packagingCompleted = subStages.every((s) => s.isCompleted);
    bool hasPackagingAgency =
        subStages.isNotEmpty; // or from API flag if available
    String packagingBtnText;
    if (!hasPackagingAgency) {
      packagingBtnText = "Select Agency";
    } else if (packagingCompleted) {
      packagingBtnText = "Completed";
    } else {
      packagingBtnText = "In Progress";
    }
    //  onWillPop: () async {
    //   // Return false to prevent going back
    //   return false;
    // },
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
              "Your Export Journey",
              func: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => Dashboard(kwikticket: widget.kwikticket),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      backgroundColor: colorCodes.whiteSmoke,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
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
                      _overallProgress(
                        // procurementCompleted,
                        // packagingCompleted,
                      ),

                      SizedBox(height: 20),
                      Column(
                        children: List.generate(_stageTitles.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _accordionStage(
                              title: _stageTitles[index],
                              status: stageStates[index],
                              child: SizedBox(
                                height: 450,
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  separatorBuilder:
                                      (_, __) => const SizedBox(height: 10),
                                  itemCount: itemCount,
                                  itemBuilder: (ctx, subIndex) {
                                    return checkContainer(
                                      progressTitle[subIndex],
                                      isCheckedSections[index],
                                      isChecked[subIndex],
                                      progressSubTitle[subIndex],
                                      false,
                                      "",
                                      () {
                                        setState(() {
                                          isCheckedSections[index][subIndex] =
                                              !isCheckedSections[index][subIndex];
                                        });
                                        _updateSectionCompletion(index);
                                      },
                                    );
                                  },
                                ),
                              ),
                              onButtonPressed: () async {
                                await _handleStageButton(index);
                              },
                            ),
                          );
                        }),
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
                // kwikbutton(
                //   "Select Packaging Agency",
                //   () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder:
                //         (context) =>
                //             PackagingAndDocumentation(kwikticket: null,stageType: currentStage, ),
                //   ),
                // );
                // },
                // buttonChild: Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                // children: [
                //   Text(
                //     "Select Packaging Agency",
                //     style: kwikTextStlye(
                //       14.0,
                //       FontWeight.w600,
                // enabled == true
                //     ?
                // colorCodes.whiteSmoke,
                // : colorCodes.aluminium,
                //         ),
                //       ),
                //       SizedBox(width: 8),
                //       Image.asset(
                //         "assets/images/icons/arrow-right.png",
                //         height: 18,
                //         width: 18,
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(height: 10),
                kwikbutton("Complete Export", () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('journeyInProgress', false);
                  await prefs.remove('activeExportContractId');
                  // final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('procurementCompleted');
                  await prefs.remove('procurementInProgress');

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ExportCompleteScreen(
                            kwikticket: widget.kwikticket,
                          ),
                    ),
                  );
                }),
                SizedBox(height: 25),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Bottomnavigationbar(1),
    );
  }

  double _calculateOverallProgress() {
    int totalStages = stageStates.length;
    int completedStages =
        stageStates.where((s) => s == StageStatus.completed).length;

    // Calculate completion as a fraction (e.g., 2/5 = 0.4)
    double progress = completedStages / totalStages;
    return progress;
  }

  Widget _overallProgress() {
    // double progress = 0.0;
    // if (procurementDone) progress += 0.3;
    // if (packagingDone) progress += 0.3;
    double progress = _calculateOverallProgress();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
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
                "${(progress * 100).toInt()}% Complete",
                style: kwikTextStlye(
                  12.0,
                  FontWeight.w300,
                  colorCodes.darkGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            backgroundColor: HexColor("#D6E7FF"),
            minHeight: 8,
            value: progress,
            borderRadius: BorderRadius.circular(12),
            color: colorCodes.azureBlue,
          ),
        ],
      ),
    );
  }

  Future<void> _handleStageButton(int index) async {
    // final currentStage = index + 1;
    final currentStage = index + 2;
    if (index == 0) {
      showToastContainer(
        "Procurement Stage",
        "Procurement agency already assigned. Monitoring in progress 🕓",
        colorCodes.azureBlue,
        colorCodes.mediumSeaGreen,
        context,
      );
      return;
    }
    if (stageStates[index] == StageStatus.pending) {
      showToastContainer(
        "Locked Stage 🚧",
        "Complete the previous stage to unlock this one.",
        colorCodes.sunset,
        colorCodes.white,
        context,
      );
      return;
    }
    if (stageStates[index] == StageStatus.selectAgency) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => PackagingAndDocumentation(
                kwikticket: widget.kwikticket,
                stageType: currentStage,
                exporterContractId: widget.exporterContractId,
              ),
        ),
      );

      // Refresh data after returning
      await _fetchStage(currentStage);

      setState(() {
        stageStates[index] = StageStatus.inProgress; // update local UI
      });
      // Start auto-complete timer for this stage
      // _startAutoCompleteTimer(index);
    } else {
      // Optional handling for other statuses
      showToastContainer(
        "Export Stage",
        stageStates[index] == StageStatus.completed
            ? "Stage already completed ✅"
            : "Stage is currently in progress ⚙️",
        colorCodes.azureBlue,
        colorCodes.mediumSeaGreen,
        context,
      );
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(
      //       stageStates[index] == StageStatus.pending
      //           ? "This stage is not unlocked yet 🚧"
      //           : "Stage already in progress or completed ✅",
      //     ),
      //     backgroundColor: Colors.grey,
      //   ),
      // );
    }
  }

  Widget _accordionStage({
    required String title,
    required StageStatus status,
    required Widget child,
    VoidCallback? onButtonPressed,
    bool expanded = false,
  }) {
    String btnText = _getButtonText(status);
    Color btnColor = _getButtonColor(status);
    return ExportAccordion(
      title: title,
      statusbtntxt: btnText,
      statusbtnFunc: onButtonPressed,
      statusbackgroundColor: btnColor,
      child: child,
    );
  }
}
