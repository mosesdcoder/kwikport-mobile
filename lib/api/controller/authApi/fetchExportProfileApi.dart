import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kwik_port/api/model/userModel.dart';
import 'package:kwik_port/api/utils/utils.dart';

class FetchExportProfileApi extends ChangeNotifier {
  bool _fetchSuccess = false;
  bool get fetchSuccess => _fetchSuccess;

  String _message = '';
  String get message => _message;
  ExporterModel? _exporter;
  ExporterModel? get exporter => _exporter;
  Future<ExporterModel?> fetchProfile() async {
    // Implementation for fetching the export profile
    // This is a placeholder implementation
    try {
      var result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final response = await HttpService.getRequest(
          '/Exporter/get-exporters',
          // requiresAuth: true,
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['isSuccessful'] == true &&
              data['data'] != null &&
              data['data']['results'] != null &&
              data['data']['results'].isNotEmpty) {
            // ✅ Pick the first exporter record
            final exporterJson = data['data']['results'][0];
            final exporter = ExporterModel.fromJson(exporterJson);
            print('✅ Exporter found: ${exporter.exporterUniqueId}');
            return exporter;
          } else {
            print('⚠️ No exporter found in response');
          }
        } else {
          print('⚠️ Exporter fetch failed: ${response.statusCode}');
        }
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
