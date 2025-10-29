// lib/api/controller/export_stage/export_stage_api.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kwik_port/api/utils/utils.dart'; // HttpService
import 'package:shared_preferences/shared_preferences.dart';

class ExportStageApi extends ChangeNotifier {
  bool loading = false;
  String _message = '';
  String get message => _message;

  bool _success = false;
  bool get success => _success;

  /// Select an agency for a given exporter contract and stageType (general select)
  selectAgency({
    required String exporterContractId,
    required String agencyId,
    required int stageType,
  }) async {
    if (loading) return;
    loading = true;
    notifyListeners();

    try {
      final body = {
        'exporterContractId': exporterContractId,
        'agencyId': agencyId,
        'stageType': stageType,
      };

      final response = await HttpService.postRequest(
        '/Agency/select-agency',
        body,
      );

      debugPrint('select-agency: ${response.statusCode}, ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _success = data['isSuccessful'] == true;
        _message = data['message'] ?? '';
      } else {
        _success = false;
        _message = 'Failed to select agency. ';
      }
    } catch (e) {
      _success = false;
      _message = 'Error selecting agency: $e';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  /// Select procurement agency (separate endpoint)
  selectProcurementAgency({
    required String exporterContractId,
    required String agencyId,
  }) async {
    if (loading) return;
    loading = true;
    notifyListeners();

    try {
      final body = {
        'exporterContractId': exporterContractId,
        'agencyId': agencyId,
      };

      final response = await HttpService.postRequest(
        '/ExportStage/select-procurement-agency',
        body,
      );

      debugPrint(
        'select-procurement-agency: ${response.statusCode}, ${response.body}',
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _success = data['isSuccessful'] == true;
        _message = data['message'] ?? '';
      } else {
        _success = false;
        _message =
            'Failed to select procurement agency. (${response.statusCode})';
      }
    } catch (e) {
      _success = false;
      _message = 'Error selecting procurement agency: $e';
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
