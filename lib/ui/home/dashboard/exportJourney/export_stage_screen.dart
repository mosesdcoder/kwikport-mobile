import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/api/controller/agency/export_substage_api.dart';
import 'package:kwik_port/api/model/export_substage_model.dart';
import 'package:kwik_port/api/model/dashboard_model.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/home/dashboard/exportJourney/journey_Subtitle_list.dart';
import 'package:kwik_port/utils/button/back_nav_header.dart';
import 'package:kwik_port/utils/button/bottom_navigatior_bar.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:kwik_port/utils/toast.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

enum StageStatus { pending, selectAgency, inProgress, completed }

class ExportStageScreen extends StatefulWidget {
  final KwikTicketModel? kwikticket;
  final String exporterContractId;
  final int stageNumber; // 1-5
  final String stageTitle;
  final List<String> subtitles;
  final bool isUnlocked;
  final VoidCallback onStageComplete;

  const ExportStageScreen({
    super.key,
    required this.kwikticket,
    required this.exporterContractId,
    required this.stageNumber,
    required this.stageTitle,
    required this.subtitles,
    required this.isUnlocked,
    required this.onStageComplete,
  });

  @override
  State<ExportStageScreen> createState() => _ExportStageScreenState();
}

class _ExportStageScreenState extends State<ExportStageScreen> {
  late StageStatus stageStatus;
  List<ExportSubStageModel> substages = [];
  bool isLoading = true;
  Timer? _autoRefreshTimer;

  @override
  void initState() {
    super.initState();
    stageStatus = widget.isUnlocked ? StageStatus.selectAgency : StageStatus.pending;
    _fetchStageData();

    // Auto-refresh every 30 seconds
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _fetchStageData();
    });
  }

  Future<void> _fetchStageData() async {
    final api = Provider.of<ExportSubStageApi>(context, listen: false);
    final apiStage = widget.stageNumber + 1;

    final fetched = await api.getSubStages(
      exporterContractId: widget.exporterContractId,
      mainStage: apiStage,
    );

    if (fetched != null && fetched.isNotEmpty) {
      final allCompleted = fetched.every((s) => s.isCompleted ?? false);
      final anyActive = fetched.any((s) => s.isActive ?? false);

      setState(() {
        substages = fetched;
        if (allCompleted) {
          stageStatus = StageStatus.completed;
        } else if (anyActive) {
          stageStatus = StageStatus.inProgress;
        } else if (widget.isUnlocked) {
          stageStatus = StageStatus.selectAgency;
        }
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  Color _getStatusColor(StageStatus status) {
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

  String _getStatusText(StageStatus status) {
    switch (status) {
      case StageStatus.completed:
        return "✅ Completed";
      case StageStatus.inProgress:
        return "⚙️ In Progress";
      case StageStatus.selectAgency:
        return "🎯 Select Agency";
      default:
        return "⏳ Pending";
    }
  }

  @override
  Widget build(BuildContext context) {
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
              widget.stageTitle,
              func: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      backgroundColor: colorCodes.whiteSmoke,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : !widget.isUnlocked
              ? _buildLockedScreen()
              : RefreshIndicator(
                  onRefresh: _fetchStageData,
                  child: ListView(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 20,
                      bottom: 100,
                    ),
                    children: [
                      _buildStageCard(),
                      SizedBox(height: 20),
                      _buildProgressSection(),
                      SizedBox(height: 20),
                      _buildSubstagesSection(),
                      SizedBox(height: 30),
                      _buildContinueButton(),
                      SizedBox(height: 60),
                    ],
                  ),
                ),
      bottomNavigationBar: Bottomnavigationbar(1),
    );
  }

  Widget _buildLockedScreen() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colorCodes.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline, size: 64, color: colorCodes.aluminium),
            SizedBox(height: 20),
            Text(
              "Stage Locked 🔐",
              style: kwikTextStlye(20.0, FontWeight.w600, colorCodes.black),
            ),
            SizedBox(height: 12),
            Text(
              "Complete the previous stage to unlock this one.",
              textAlign: TextAlign.center,
              style:
                  kwikTextStlye(14.0, FontWeight.w400, colorCodes.graniteGrey),
            ),
            SizedBox(height: 20),
            Text(
              "Stage ${widget.stageNumber}",
              style: kwikTextStlye(12.0, FontWeight.w300, colorCodes.darkGrey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStageCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorCodes.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorCodes.antiFlashWhite),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Stage ${widget.stageNumber}",
                style: kwikTextStlye(12.0, FontWeight.w300, colorCodes.darkGrey),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(stageStatus).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getStatusText(stageStatus),
                  style: kwikTextStlye(
                    11.0,
                    FontWeight.w600,
                    _getStatusColor(stageStatus),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            widget.stageTitle,
            style: kwikTextStlye(16.0, FontWeight.w600, colorCodes.black),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    final completedCount =
        substages.where((s) => s.isCompleted ?? false).length;
    final progress = substages.isEmpty ? 0.0 : completedCount / substages.length;

    return Container(
      padding: EdgeInsets.all(16),
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
                "Progress",
                style: kwikTextStlye(12.0, FontWeight.w500, colorCodes.black),
              ),
              Text(
                "${(progress * 100).toInt()}%",
                style: kwikTextStlye(
                  12.0,
                  FontWeight.w600,
                  colorCodes.azureBlue,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              backgroundColor: HexColor("#D6E7FF"),
              minHeight: 8,
              value: progress,
              color: colorCodes.azureBlue,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "$completedCount of ${substages.length} tasks completed",
            style: kwikTextStlye(10.0, FontWeight.w300, colorCodes.graniteGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildSubstagesSection() {
    if (substages.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorCodes.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            "No substages available",
            style: kwikTextStlye(14.0, FontWeight.w400, colorCodes.graniteGrey),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorCodes.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tasks",
            style: kwikTextStlye(14.0, FontWeight.w600, colorCodes.black),
          ),
          SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => SizedBox(height: 10),
            itemCount: substages.length,
            itemBuilder: (_, index) {
              final sub = substages[index];
              final isCompleted = sub.isCompleted ?? false;
              final subtitle = index < widget.subtitles.length
                  ? widget.subtitles[index]
                  : "";

              return _buildTaskItem(
                sub.subStageName ?? "Task ${index + 1}",
                subtitle,
                isCompleted,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(String title, String subtitle, bool isCompleted) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCompleted
            ? colorCodes.pigmentGreen.withOpacity(0.1)
            : colorCodes.whiteSmoke,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isCompleted ? colorCodes.pigmentGreen : colorCodes.antiFlashWhite,
        ),
      ),
      child: Row(
        children: [
          isCompleted
              ? Icon(Icons.check_circle, color: colorCodes.pigmentGreen, size: 24)
              : Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colorCodes.frenchSkyBlue,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: kwikTextStlye(
                    12.0,
                    FontWeight.w500,
                    isCompleted ? colorCodes.pigmentGreen : colorCodes.black,
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: kwikTextStlye(
                      10.0,
                      FontWeight.w300,
                      colorCodes.graniteGrey,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    final isEnabled = stageStatus == StageStatus.completed;

    return InkWell(
      onTap: isEnabled
          ? () {
              widget.onStageComplete();
              Navigator.pop(context);
            }
          : () {
              showToastContainer(
                "Stage Not Complete",
                "Complete all tasks before continuing.",
                colorCodes.sunset,
                colorCodes.white,
                context,
              );
            },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isEnabled ? colorCodes.azureBlue : colorCodes.aluminium,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            isEnabled ? "Continue to Next Stage" : "Complete Stage to Continue",
            style: kwikTextStlye(14.0, FontWeight.w600, colorCodes.white),
          ),
        ),
      ),
    );
  }
}
