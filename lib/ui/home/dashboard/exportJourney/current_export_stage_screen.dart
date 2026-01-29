import 'package:flutter/material.dart';
import 'package:kwik_port/api/model/dashboard_model.dart';
import 'package:kwik_port/ui/home/dashboard/exportJourney/freight_forwarding_stage_screen.dart';
import 'package:kwik_port/ui/home/dashboard/exportJourney/logistics_stage_screen.dart';
import 'package:kwik_port/ui/home/dashboard/exportJourney/packaging_stage_screen.dart';
import 'package:kwik_port/ui/home/dashboard/exportJourney/procurement_stage_screen.dart';

class CurrentExportStageScreen extends StatefulWidget {
  final ExportSummaryModel exportData;
  final KwikTicketModel? kwikticket;

  const CurrentExportStageScreen({
    super.key,
    required this.exportData,
    required this.kwikticket,
  });

  @override
  State<CurrentExportStageScreen> createState() => _CurrentExportStageScreenState();
}

class _CurrentExportStageScreenState extends State<CurrentExportStageScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the correct screen after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToStageScreen();
    });
  }

  void _navigateToStageScreen() {
    print("=== CurrentExportStageScreen navigation ===");
    print("Export Data Contract ID: ${widget.exportData.contractId}");
    
    final currentStageInfo = widget.exportData.currentStageInfo;
    print("currentStageInfo: ${currentStageInfo == null ? 'NULL' : 'EXISTS'}");
    
    if (currentStageInfo == null) {
      print("ERROR: currentStageInfo is null - staying on error screen");
      return;
    }

    final mainStage = currentStageInfo.mainStage;
    final allSubStages = currentStageInfo.allSubStages ?? [];
    
    print("Main Stage: '$mainStage'");
    print("All SubStages count: ${allSubStages.length}");
    if (allSubStages.isNotEmpty) {
      print("First substage - name: ${allSubStages.first.subStageName}, isCurrent: ${allSubStages.first.isCurrent}, isCompleted: ${allSubStages.first.isCompleted}");
    }
    
    // Check if first substage is current and not completed (need to select agency)
    final needsAgencySelection = allSubStages.isNotEmpty &&
        allSubStages.first.isCurrent == true &&
        allSubStages.first.isCompleted == false;
    
    print("needsAgencySelection: $needsAgencySelection");

    final screen = _getStageScreen(
      mainStage ?? '',
      needsAgencySelection,
      allSubStages,
    );

    print("Screen returned: ${screen == null ? 'NULL' : screen.runtimeType.toString()}");

    // Navigate to the appropriate screen
    if (screen != null && mounted) {
      print("About to navigate with pushReplacement...");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => screen),
      ).then((_) {
        print("Navigation completed");
      }).catchError((error) {
        print("Navigation error: $error");
      });
    } else {
      print("ERROR: No valid screen to navigate to");
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStageInfo = widget.exportData.currentStageInfo;
    
    if (currentStageInfo == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Export Details")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Unable to load export stage information"),
              const SizedBox(height: 20),
              Text("Contract ID: ${widget.exportData.contractId ?? 'N/A'}"),
            ],
          ),
        ),
      );
    }

    // Show loading indicator while navigating
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text("DEBUG: CurrentExportStageScreen loading...", style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget? _getStageScreen(
    String mainStage,
    bool needsAgencySelection,
    List<SubStageInfo> subStages,
  ) {
    final contractId = widget.exportData.contractId ?? '';
    print("_getStageScreen called with mainStage: '$mainStage', needsAgencySelection: $needsAgencySelection");
    
    // Each stage screen now handles agency selection internally
    switch (mainStage) {
      case 'CommoditySourcing':
        print("Matched CommoditySourcing stage - routing to ProcurementStageScreen");
        return ProcurementStageScreen(
          substages: subStages,
          kwikticket: widget.kwikticket,
          exporterContractId: contractId,
        );

      case 'Packaging':
        print("Matched Packaging stage - routing to PackagingStageScreen");
        return PackagingStageScreen(
          substages: subStages,
          kwikticket: widget.kwikticket,
          exporterContractId: contractId,
        );

      case 'Logistics':
        print("Matched Logistics stage - routing to LogisticsStageScreen");
        return LogisticsStageScreen(
          substages: subStages,
          kwikticket: widget.kwikticket,
          exporterContractId: contractId,
        );

      case 'FreightForwarding':
        print("Matched FreightForwarding stage - routing to FreightForwardingStageScreen");
        return FreightForwardingStageScreen(
          substages: subStages,
          kwikticket: widget.kwikticket,
          exporterContractId: contractId,
        );

      case 'ExportComplete':
        print("Matched ExportComplete stage");
        return FreightForwardingStageScreen(
          substages: subStages,
          kwikticket: widget.kwikticket,
          exporterContractId: contractId,
        );
        
      default:
        print("ERROR: No matching stage case found for: '$mainStage'");
        return null;
    }
  }
}
