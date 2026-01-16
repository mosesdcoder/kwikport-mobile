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
import 'package:kwik_port/ui/home/dashboard/exportJourney/journey_Subtitle_list.dart';
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

  List<String> statusTexts = [
    "Pending",
    "Pending",
    "Pending",
    "Pending",
    "Pending",
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
    "Final Export 🚢",
  ];

  late List<StageStatus> stageStates;
  int selectedMainStage = 2;

  Timer? _autoRefreshTimer;
  Map<int, List<ExportSubStageModel>> stageSubStages = {};
  @override
  void initState() {
    super.initState();

    // Try to load cached state first for instant UI
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

      // Load cached stageStates
      final cachedStates = prefs.getString('exportStageStates_${widget.exporterContractId}');
      final cachedSubStages = prefs.getString('exportStageSubStages_${widget.exporterContractId}');
      List<StageStatus>? loadedStates;
      Map<int, List<ExportSubStageModel>>? loadedSubStages;
      if (cachedStates != null) {
        final indices = List<int>.from(jsonDecode(cachedStates));
        loadedStates = indices.map((i) => StageStatus.values[i]).toList();
      }
      if (cachedSubStages != null) {
        final decoded = jsonDecode(cachedSubStages) as Map<String, dynamic>;
        loadedSubStages = decoded.map((k, v) => MapEntry(int.parse(k), (v as List).map((e) => ExportSubStageModel.fromJson(e)).toList()));
      }
      if (loadedStates != null || loadedSubStages != null) {
        setState(() {
          if (loadedStates != null) stageStates = loadedStates;
          if (loadedSubStages != null) stageSubStages = loadedSubStages;
        });
      }

      // Initial load - fetch all 5 stages in parallel
      await Future.wait([
        _fetchStage(1),
        _fetchStage(2),
        _fetchStage(3),
        _fetchStage(4),
        _fetchStage(5),
      ]);
      if (mounted) {
        setState(() => isLoading = false);
      }

      // Auto-refresh every 30 seconds
      _autoRefreshTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
        debugPrint("⏱ Auto-refreshing export substages...");
        await _autoRefresh();
      });
    });
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _autoRefresh() async {
    if (!mounted) return;
    
    // Fetch incomplete stages in parallel
    final refreshFutures = <Future>[];
    for (int stage = 1; stage <= _stageTitles.length; stage++) {
      if (stageStates[stage - 1] != StageStatus.completed) {
        refreshFutures.add(_fetchStage(stage));
      }
    }
    await Future.wait(refreshFutures);
  }
  
  Future<void> _fetchStage(int mainStage) async {
    final api = Provider.of<ExportSubStageApi>(context, listen: false);

    final fetchedSubStages = await api.getSubStages(
      exporterContractId: widget.exporterContractId,
      mainStage: mainStage,
    );
    
    if (fetchedSubStages != null) {
      fetchedSubStages.forEach((s) {
        debugPrint("${s.subStageName}: isCompleted=${s.isCompleted}, isActive=${s.isActive}");
      });
    }

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
        debugPrint("Raw JSON for stage $mainStage: ${jsonEncode(fetchedSubStages)}");
      });

      final allCompleted = fetchedSubStages.every((s) => s.isCompleted ?? false);
      final anyActive = fetchedSubStages.any((s) => s.isActive ?? false);
      // ✅ NEW: Check for agency/truck selection based on stage and substage name
      final agencySubstage = fetchedSubStages.firstWhere(
        (s) {
          final name = s.subStageName?.toLowerCase() ?? '';
          // ✅ Only check for agency selection in stages 1-4 (NOT stage 5)
          if (mainStage == 5) return false; // Final Export has no agency selection
          return name.contains('agency assigned') || 
                 name.contains('truck assigned') ||
                 name.contains('in transit');
        },
        orElse: () => ExportSubStageModel(
          id: '',
          subStageName: '',
          order: 0,
          estimatedDays: 0,
          isCompleted: true,
          isActive: false,
        ),
      );
      final needsAgencySelection = 
          (mainStage != 5) && // ✅ Never show "Select Agency" for Final Export
          (agencySubstage.isCompleted == false) && 
          (agencySubstage.isActive == true);
      debugPrint("🔍 Stage $mainStage - Agency/Truck needs selection: $needsAgencySelection");
      debugPrint("🔍 Found substage: ${agencySubstage.subStageName}");
      final index = mainStage - 1;
      if (index >= 0 && index < stageStates.length) {
        setState(() {
          if (allCompleted) {
            stageStates[index] = StageStatus.completed;
            _unlockNextStage(mainStage + 1);
          } else if (needsAgencySelection) {
            // ✅ Set to selectAgency when agency substage is active but not completed
            stageStates[index] = StageStatus.selectAgency;
          } else if (anyActive) {
            stageStates[index] = StageStatus.inProgress;
          } else {
            stageStates[index] = StageStatus.pending;
          }
        });
      }
      // Save updated state to SharedPreferences for instant UI next time
      final prefs = await SharedPreferences.getInstance();
      // Save stageStates as list of indices
      await prefs.setString('exportStageStates_${widget.exporterContractId}', jsonEncode(stageStates.map((e) => e.index).toList()));
      // Save stageSubStages as map of int to list of json
      final subStagesToSave = stageSubStages.map((k, v) => MapEntry(k.toString(), v.map((e) => e.toJson()).toList()));
      await prefs.setString('exportStageSubStages_${widget.exporterContractId}', jsonEncode(subStagesToSave));
    }
  }

  void _unlockNextStage(int nextStage) {
    final index = nextStage - 1;
    if (index >= 0 && index < stageStates.length && mounted) {
      if (stageStates[index] == StageStatus.pending) {
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
        debugPrint('ExportJourneyScreen: kwikticket = \\${widget.kwikticket}');
        debugPrint('ExportJourneyScreen: commodity = \\${widget.kwikticket?.commodity}');
        debugPrint('ExportJourneyScreen: commodity name = \\${widget.kwikticket?.commodity?.name}');
      debugPrint('ExportJourneyScreen: commodity name = ' + (widget.kwikticket?.commodity?.name ?? 'null'));
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
                                            final sub = substagesForStage[subIndex];
                                            final isChecked = sub.isCompleted ?? false;
                                            final isActive = sub.isActive ?? false;
                                            final subTitle = subIndex < subTitles.length ? subTitles[subIndex] : "";
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

                                // ✅ Handle "Select Agency" button click
                                if (stageStates[index] == StageStatus.selectAgency) {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PackagingAndDocumentation(
                                        kwikticket: widget.kwikticket,
                                        stageType: mainStage,
                                        exporterContractId: widget.exporterContractId,
                                        exportData: widget.exportData,
                                      ),
                                    ),
                                  );
                                  
                                  // Refresh after returning
                                  await _fetchStage(mainStage);
                                } else if (stageStates[index] == StageStatus.inProgress) {
                                  showToastContainer(
                                    "In Progress ⚙️",
                                    "This stage is currently being processed.",
                                    colorCodes.azureBlue,
                                    colorCodes.white,
                                    context,
                                  );
                                } else if (stageStates[index] == StageStatus.completed) {
                                  showToastContainer(
                                    "Completed ✅",
                                    "This stage has been completed.",
                                    colorCodes.pigmentGreen,
                                    colorCodes.white,
                                    context,
                                  );
                                }
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

                // ✅ Only show Continue button when all stages are completed
                if (stageStates.every((status) => status == StageStatus.completed))
                  kwikbutton("Continue", () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('journeyInProgress');
                    await prefs.remove('activeExportContractId');
                    await prefs.remove('activeKwikTicket');
                    await prefs.remove('procurementCompleted');
                  await prefs.remove('procurementInProgress');
                  
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

  Future<void> _handleStageButton(int index) async {
    final currentStage = index + 1;
    
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
          builder: (_) => PackagingAndDocumentation(
            kwikticket: widget.kwikticket,
            stageType: currentStage,
            exporterContractId: widget.exporterContractId,
            exportData: widget.exportData,
          ),
        ),
      );

      await _fetchStage(currentStage);
      if (mounted) {
        setState(() {
          stageStates[index] = StageStatus.inProgress;
        });
      }
    } else {
      showToastContainer(
        "Export Stage",
        stageStates[index] == StageStatus.completed
            ? "Stage already completed ✅"
            : "Stage is currently in progress ⚙️",
        colorCodes.azureBlue,
        colorCodes.mediumSeaGreen,
        context,
      );
    }
  }

  // Future<void> _handleStageButton(int index) async {
  //   final currentStage = index + 1;
    
  //   if (stageStates[index] == StageStatus.pending) {
  //     showToastContainer(
  //       "Locked Stage 🚧",
  //       "Complete the previous stage to unlock this one.",
  //       colorCodes.sunset,
  //       colorCodes.white,
  //       context,
  //     );
  //     return;
  //   }
    
  //   if (stageStates[index] == StageStatus.selectAgency) {
  //     await Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (_) => PackagingAndDocumentation(
  //           kwikticket: widget.kwikticket,
  //           stageType: currentStage,
  //           exporterContractId: widget.exporterContractId,
  //           exportData: widget.exportData,
  //         ),
  //       ),
  //     );

  //     await _fetchStage(currentStage);
  //     if (mounted) {
  //       setState(() {
  //         stageStates[index] = StageStatus.inProgress;
  //       });
  //     }
  //   } else {
  //     showToastContainer(
  //       "Export Stage",
  //       stageStates[index] == StageStatus.completed
  //           ? "Stage already completed ✅"
  //           : "Stage is currently in progress ⚙️",
  //       colorCodes.azureBlue,
  //       colorCodes.mediumSeaGreen,
  //       context,
  //     );
  //   }
  // }

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
