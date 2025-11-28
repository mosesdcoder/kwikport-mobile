// lib/api/controller/export_stage/export_substage_api.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kwik_port/api/model/export_substage_model.dart';
import 'package:kwik_port/api/utils/utils.dart';
import 'package:kwik_port/ui/home/dashboard/exportJourney/export_journey_screen.dart';

class ExportSubStageApi extends ChangeNotifier {
  bool loading = false;
  String message = '';
  List<ExportSubStageModel> subStages = [];

  /// GET: get-substages?ExporterContractId=xxx&MainStage=1
  getSubStages({
    required String exporterContractId,
    required int mainStage,
  }) async {
    if (loading) return;
    loading = true;
    notifyListeners();

    try {
      final path =
          '/ExportSubStage/get-substages?ExporterContractId=$exporterContractId&MainStage=$mainStage';
      final response = await HttpService.getRequest(path);

      debugPrint('get-substages: ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['isSuccessful'] == true && data['data'] != null) {
          final list = data['data'] as List;
          final List<ExportSubStageModel> subStages = list
              .map((j) => ExportSubStageModel.fromJson(j))
              .toList(growable: true);
          message = data['message'] ?? '';
          debugPrint('Raw JSON for stage $mainStage: ${response.body}');
          for (final s in subStages) {
            debugPrint(
              '${s.subStageName}: isCompleted=${s.isCompleted}, isActive=${s.isActive}',
            );
          }
          debugPrint(
            "Fetched ${subStages.length} substages for stage $mainStage",
          );
          return subStages;
        } else {
          subStages = [];
          message = data['message'] ?? 'No substages';
        }
      } else {
        subStages = [];
        message = 'Failed to load substages (${response.statusCode})';
      }
    } catch (e) {
      subStages = [];
      message = 'Error: $e';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  /// POST /ExportSubStage/progress
  markProgress({
    required String exporterContractId,
    required int mainStage,
  }) async {
    if (loading) return false;
    loading = true;
    notifyListeners();

    try {
      final body = {
        'exporterContractId': exporterContractId,
        'mainStage': mainStage,
      };

      final response = await HttpService.postRequest(
        '/ExportSubStage/progress',
        body,
      );

      debugPrint('progress: ${response.statusCode}, ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final ok = data['isSuccessful'] == true || data['data'] == true;
        loading = false;
        notifyListeners();
        return ok;
      } else {
        loading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      loading = false;
      notifyListeners();
      return false;
    }
  }

  /// POST /ExportSubStage/complete
  Future<bool> completeSubStage({
    required String subStageId,
    String? notes,
  }) async {
    if (loading) return false;
    loading = true;
    notifyListeners();

    try {
      final body = {'subStageId': subStageId, 'notes': notes ?? ''};

      final response = await HttpService.postRequest(
        '/ExportSubStage/complete',
        body,
      );

      debugPrint('complete: ${response.statusCode}, ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final ok = data['isSuccessful'] == true || data['data'] == true;
        loading = false;
        notifyListeners();
        return ok;
      } else {
        loading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      loading = false;
      notifyListeners();
      return false;
    }
  }
}

class ExportJourneyProvider with ChangeNotifier {
  List<StageStatus> stageStates = [
    StageStatus.inProgress, // Procurement
    StageStatus.pending, // Packaging
    StageStatus.pending, // Logistics
    StageStatus.pending, // Freight Forwarding
    StageStatus.pending, // Final Export
  ];

  void updateStage(int index, StageStatus status) {
    stageStates[index] = status;
    notifyListeners();
  }
}
