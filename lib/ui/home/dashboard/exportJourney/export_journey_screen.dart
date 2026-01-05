import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/api/controller/agency/export_substage_api.dart';
// import 'package:kwik_port/api/model/agency_model.dart';
import 'package:kwik_port/api/model/export_substage_model.dart';
import 'package:kwik_port/api/model/dashboard_model.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/main.dart';
import 'package:kwik_port/ui/home/dashboard/dashboard.dart';
import 'package:kwik_port/ui/home/dashboard/exportJourney/export_complete_screen.dart';
import 'package:kwik_port/ui/home/dashboard/exportJourney/export_stage_screen.dart';
import 'package:kwik_port/ui/home/dashboard/exportJourney/journey_Subtitle_list.dart';
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
  final KwikTicketModel? kwikticket;
  final String exporterContractId;
  final ExportSummaryModel exportData;

  const ExportJourneyScreen({
    super.key,
    required this.kwikticket,
    required this.exporterContractId,
    required this.exportData,
  });

  @override
  State<ExportJourneyScreen> createState() => _ExportJourneyScreenState();
}

enum StageStatus { pending, selectAgency, inProgress, completed }

class _ExportJourneyScreenState extends State<ExportJourneyScreen> {
  bool checkterms = false;
  int itemCount = 5;
  String packagingButtonText = "Select Packaging Agency";
  bool agencySelected = false;
  bool isLoading = true;

  // Map API stage names to UI index
  final Map<String, int> stageNameToIndex = {
    "CommoditySourcing": 0,
    "PackagingQualityControlAndDocumentation": 1,
    "Logistics": 2,
    "FreightForwarding": 3,
    "FinalExport": 4,
    "Payout": 5,
  };

  // Map API stage names to UI titles
  final Map<String, String> stageNameToTitle = {
    "CommoditySourcing": "Procurement 🏭",
    "PackagingQualityControlAndDocumentation": "Packaging, Quality Control & Documentation 📋",
    "Logistics": "Logistics 🚚",
    "FreightForwarding": "Freight Forwarding (Port Clearance & Vessel Loading) ⚓",
    "FinalExport": "Final Export 🌍",
  };

  List<String> statusTexts = [
    "Pending", // Procurement
    "Pending", // Packaging
    "Pending", // Logistics
    "Pending", // Freight Forwarding
    "Pending", // Final Export
  ];
  final List<List<String>> stageSubTitles = [
    procurementSubTitles,
    packagingSubTitles,
    logisticsSubTitles,
    freightSubTitles,
    finalExportSubTitles,
  ];

  // int selectedMainStage = 1; // you can change depending on stage

  final List<String> _stageTitles = [
    "Procurement 🏭",
    "Packaging, Quality Control & Documentation 📋",
    "Logistics 🚚",
    "Freight Forwarding (Port Clearance & Vessel Loading) ⚓",
    "Final Export 🌍",
  ];

  late List<StageStatus> stageStates;
  int? currentStageIndex;
  String? currentStageName;
  List<SubStageInfo> currentSubStages = [];

  Timer? _autoRefreshTimer;
  @override
  void initState() {
    super.initState();

    stageStates = [
      StageStatus.pending,
      StageStatus.pending,
      StageStatus.pending,
      StageStatus.pending,
      StageStatus.pending,
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('journeyInProgress', true);
      await prefs.setString('activeExportContractId', widget.exporterContractId);
      await prefs.setString('activeKwikTicket', jsonEncode(widget.kwikticket!.toJson()));

      _loadCurrentStageFromApi();
      if (mounted) {
        setState(() => isLoading = false);
      }

      _autoRefreshTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
        debugPrint("⏱ Auto-refreshing export substages...");
      });
    });
  }

  void _loadCurrentStageFromApi() {
    final currentStageInfo = widget.exportData.currentStageInfo;

    if (currentStageInfo == null) {
      debugPrint("⚠️ No currentStageInfo found");
      return;
    }

    currentStageName = currentStageInfo.mainStage;
    currentSubStages = currentStageInfo.allSubStages;

    if (currentStageName == "Payout") {
      debugPrint("✅ Export journey is complete!");
      currentStageIndex = null;
      return;
    }

    currentStageIndex = stageNameToIndex[currentStageName];

    if (currentStageIndex == null) {
      debugPrint("⚠️ Unknown stage name: $currentStageName");
      return;
    }

    debugPrint("📍 Current Stage: $currentStageName (Index: $currentStageIndex)");
    debugPrint("📋 Substages: ${currentSubStages.length}");

    final allCompleted = currentSubStages.every((s) => s.isCompleted);
    final anyCompleted = currentSubStages.any((s) => s.isCompleted);
    final anyActive = currentSubStages.any((s) => s.isCurrent);

    if (mounted) {
      setState(() {
        if (allCompleted) {
          stageStates[currentStageIndex!] = StageStatus.completed;
        } else if (anyCompleted) {
          // If any substage is actually completed, show in progress
          stageStates[currentStageIndex!] = StageStatus.inProgress;
        } else {
          // If no substage has been completed yet (even if current), show select agency
          stageStates[currentStageIndex!] = StageStatus.selectAgency;
        }
      });
    }
  }

  /// Initialize journey, clear old data, and fetch stages
  Future<void> _initJourney() async {
    await _resetJourneyPersistency();
    _resetUIState();
    await _fetchAllStages();

    // Start auto-refresh every 30s
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      await _autoRefreshIncompleteStages();
    });

    setState(() => isLoading = false);
  }

  /// Clear old journey data from SharedPreferences
  Future<void> _resetJourneyPersistency() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('activeExportContractId');
    await prefs.remove('journeyInProgress');
    await prefs.remove('procurementCompleted');
    await prefs.remove('procurementInProgress');
    await prefs.remove('packagingCompleted');
    await prefs.remove('packagingInProgress');
    await prefs.remove('procurementStartTime');

    // Save the new exporter ID
    await prefs.setString('activeExportContractId', widget.exporterContractId);
    await prefs.setBool('journeyInProgress', true);
  }

  /// Reset UI state and provider
  void _resetUIState() {
    stageStates = [
      StageStatus.pending,
      StageStatus.pending,
      StageStatus.pending,
      StageStatus.pending,
      StageStatus.pending,
    ];
    stageSubStages.clear();

    final exportProvider = Provider.of<ExportSubStageApi>(
      context,
      listen: false,
    );
    exportProvider.subStages = [];
  }

  /// Fetch all stages for current exporter
  Future<void> _fetchAllStages() async {
    for (int stage = 1; stage <= _stageTitles.length; stage++) {
      await _fetchStage(stage);
    }
  }

  /// Only refresh incomplete stages
  Future<void> _autoRefreshIncompleteStages() async {
    for (int stage = 1; stage <= _stageTitles.length; stage++) {
      if (stageStates[stage - 1] != StageStatus.completed) {
        await _fetchStage(stage);
      }
    }
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _autoRefresh() async {
    if (!mounted) return;
    // Only refresh stages that are NOT completed
    for (int stage = 1; stage <= _stageTitles.length; stage++) {
      if (stageStates[stage - 1] != StageStatus.completed) {
        await _fetchStage(stage);
      }
    }
  }

  Map<int, List<ExportSubStageModel>> stageSubStages = {};
  Future<void> _fetchStage(int mainStage) async {
    final api = Provider.of<ExportSubStageApi>(context, listen: false);

    final apiStage = mainStage + 1; // UI stage 1 (Procurement) queries API with 2

    // ⬅️ Get the response directly from the function
    final fetchedSubStages = await api.getSubStages(
      exporterContractId: widget.exporterContractId,
      mainStage: apiStage,
    );
    fetchedSubStages!.forEach((s) {
      debugPrint("${s.subStageName}: isCompleted=${s.isCompleted}");
    });

    final substagesForStage = stageSubStages[mainStage] ?? [];
    print('Stage $mainStage has ${substagesForStage.length} substages');
    if (fetchedSubStages == null || fetchedSubStages.isEmpty) {
      debugPrint('Stage $mainStage returned no substages.');
      if (mounted) {
        setState(() {
          stageSubStages[mainStage] = [];
        });
      }
      return;
    }

    debugPrint('Stage $mainStage fetched ${fetchedSubStages.length} substages');

    if (mounted) {
      setState(() {
        stageSubStages[mainStage] = fetchedSubStages;
        // exportSubStageProvider.subStages = fetchedSubStages; // Update provider
        debugPrint(
          "Raw JSON for stage $mainStage: ${jsonEncode(fetchedSubStages)}",
        );
      });
    }

    final allCompleted = fetchedSubStages.every((s) => s.isCompleted ?? false);
    final anyActive = fetchedSubStages.any((s) => s.isActive ?? false);
    final index = mainStage - 1; // because stages start at 1
    if (index >= 0 && index < stageStates.length && mounted) {
      setState(() {
        if (allCompleted) {
          stageStates[index] = StageStatus.completed;
          _unlockNextStage(mainStage + 1);
        } else if (anyActive) {
          stageStates[index] = StageStatus.inProgress;
        } else {
          stageStates[index] = StageStatus.pending;
        }
      });
    }

    // setState(() {
    //   if (allCompleted) {
    //     //  stageStates[mainStage - 1]
    //     stageStates[mainStage - 2] = StageStatus.completed;
    //     _unlockNextStage(mainStage + 1);
    //   } else if (anyActive) {
    //     stageStates[mainStage - 2] = StageStatus.inProgress;
    //   } else {
    //     stageStates[mainStage - 2] = StageStatus.pending;
    //   }
    // });
  }

  void _unlockNextStage(int nextStage) {
    final index = nextStage - 1; // align to stages starting at 1
    if (index >= 0 && index < stageStates.length) {
      if (stageStates[index] == StageStatus.pending && mounted) {
        setState(() {
          stageStates[index] = StageStatus.selectAgency;
        });
      }
    }
  }

  Future<void> _refresh() async {
    for (int stage = 1; stage <= _stageTitles.length; stage++) {
      await _fetchStage(stage);
    }
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
    if (currentStageName == "Payout") {
      return ExportCompleteScreen(kwikticket: widget.kwikticket);
    }

    if (currentStageIndex == null) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(85.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 42.0, bottom: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: backNavRow(
                context,
                "Your Export Journey",
                func: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
        backgroundColor: colorCodes.whiteSmoke,
        body: Center(
          child: Text(
            "No active stage found",
            style: kwikTextStlye(14.0, FontWeight.w500, colorCodes.darkGrey),
          ),
        ),
      );
    }

    final currentStageTitle = stageNameToTitle[currentStageName] ?? "Unknown Stage";
    final currentStatus = stageStates[currentStageIndex!];

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
                      _overallProgress(stageStates),

                      SizedBox(height: 20),
                      Column(
                        children: List.generate(_stageTitles.length, (index) {
                          final mainStage = index + 1;
                          final substagesForStage =
                              stageSubStages[mainStage] ?? [];
                          bool canExpand =
                              index == 0 ||
                              stageStates[index - 1] == StageStatus.completed ||
                              stageStates[index] == StageStatus.selectAgency;
                          final subTitles = stageSubTitles[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            // child: SizedBox(),
                            child: _accordionStage(
                              title: _stageTitles[index],
                              status: stageStates[index],
                              // child: SizedBox(),
                              child:
                                  canExpand
                                      ? SizedBox(
                                        height: 450,
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          separatorBuilder:
                                              (_, __) =>
                                                  const SizedBox(height: 10),

                                          itemCount: substagesForStage.length,
                                          // itemCount: subStages.length,
                                          itemBuilder: (ctx, subIndex) {
                                            final sub =
                                                substagesForStage[subIndex];
                                            final isChecked =
                                                sub.isCompleted ?? false;
                                            final isActive =
                                                sub.isActive ?? false;
                                            final subTitle =
                                                subTitles[subIndex];
                                            return checkContainer(
                                              sub.subStageName, // progressTitle[subIndex],
                                              // sub.isCompleted, //  isCheckedSections[index],
                                              isChecked, // isChecked[subIndex],
                                              subTitle,
                                              false,
                                              "",
                                            );
                                          },
                                        ),
                                      )
                                      : const SizedBox.shrink(), // 🚫 don’t show substages when locked

                              onButtonPressed: () async {
                                if (!canExpand) {
                                  showToastContainer(
                                    "Locked Stage 🚧",
                                    "Complete the previous stage to unlock this one.",
                                    colorCodes.sunset,
                                    colorCodes.white,
                                    context,
                                  );
                                  return;
                                }
                                // await _fetchStage(mainStage);
                                await _handleCurrentStageButton();
                              },
                              canExpand: canExpand,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),

                if (currentStatus == StageStatus.selectAgency)
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
                                        "Agency Selection Required",
                                        style: kwikTextStlye(
                                          14.0,
                                          FontWeight.w600,
                                          colorCodes.sinopia,
                                        ),
                                      ),
                                      Text(
                                        "Select an agency to continue your export journey.",
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

                kwikbutton("Continue", () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('journeyInProgress');
                  await prefs.remove('activeExportContractId');
                  await prefs.remove('activeKwikTicket');

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExportCompleteScreen(kwikticket: widget.kwikticket),
                    ),
                  );
                }),

                SizedBox(height: 60),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Bottomnavigationbar(1),
    );
  }

  Widget checkContainer(
    title,
    checkterms,
    subtitle,
    delay,
    delaydate,
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
          // InkWell(
          //   // onTap: checkFunc,
          //   child:
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
                  borderRadius: BorderRadius.circular(6), // rounded corners
                ),
              ),
          // ),
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

  Future<void> _handleCurrentStageButton() async {
    if (currentStageIndex == null) return;

    // API stage types start from 2 (Procurement=2, Packaging=3, etc.)
    final apiStageType = currentStageIndex! + 2;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PackagingAndDocumentation(
          kwikticket: widget.kwikticket,
          stageType: apiStageType,
          exporterContractId: widget.exporterContractId,
        ),
      ),
    );

    setState(() {});
  }

  Widget _accordionStage({
    required String title,
    required StageStatus status,
    required Widget child,
    VoidCallback? onButtonPressed,
    bool expanded = false,
    bool canExpand = true,
  }) {
    String btnText = _getButtonText(status);
    Color btnColor = _getButtonColor(status);
    return ExportAccordion(
      title: title,
      statusbtntxt: btnText,
      statusbtnFunc: onButtonPressed,
      statusbackgroundColor: btnColor,
      child: child,
      canExpand: canExpand,
    );
  }
}

double _calculateOverallProgress(stageStates) {
  int totalStages = stageStates.length;
  int completedStages =
      stageStates.where((s) => s == StageStatus.completed).length;

  // Calculate completion as a fraction (e.g., 2/5 = 0.4)
  double progress = completedStages / totalStages;
  return progress;
}

Widget _overallProgress(stageStates) {
  // double progress = 0.0;
  // if (procurementDone) progress += 0.3;
  // if (packagingDone) progress += 0.3;
  double progress = _calculateOverallProgress(stageStates);
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
              style: kwikTextStlye(12.0, FontWeight.w300, colorCodes.darkGrey),
            ),
            Text(
              "${(progress * 100).toInt()}% Complete",
              style: kwikTextStlye(12.0, FontWeight.w300, colorCodes.darkGrey),
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
