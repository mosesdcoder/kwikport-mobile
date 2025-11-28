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
        final dashboardResponse = await HttpService.getRequest(
          '/Dashboard/user-dashboard',
        );
        if (dashboardResponse.statusCode != 200) {
          print(
            '⚠️ Failed to fetch dashboard: ${dashboardResponse.statusCode}',
          );
          return null;
        }

        final dashboardData = jsonDecode(dashboardResponse.body);
        if (dashboardData['isSuccessful'] != true ||
            dashboardData['data'] == null) {
          print('⚠️ Dashboard response invalid');
          return null;
        }

        final userProfile = dashboardData['data']['userProfile'];
        final exporterId = userProfile?['exporterId'];
        if (exporterId == null) {
          print('⚠️ No exporterId found in dashboard userProfile');
          return null;
        }

        print('✅ exporterId from dashboard: $exporterId');

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
            // ✅ Step 3: Match by exporterId from Dashboard
            final exporterData = jsonDecode(response.body);
            final exporters = (exporterData['data']?['results'] ?? []) as List;

            final matched = exporters.firstWhere(
              (exp) => exp['id'] == exporterId,
              orElse: () => null,
            );

            if (matched == null) {
              print('⚠️ No exporter found with id: $exporterId');
              return null;
            }

            final exporter = ExporterModel.fromJson(matched);
            _exporter = exporter;
            _fetchSuccess = true;
            _message = 'Exporter fetched successfully';
            notifyListeners();

            print('✅ Correct exporter found: ${exporter.exporterUniqueId}');
            return exporter;
            // final exporters =
            //     (data['data']['results'] as List)
            //         .map((e) => ExporterModel.fromJson(e))
            //         .toList();

            // // ✅ Get current logged-in user ID (from Auth)
            // // final userId = userDataVar?.auth?.identifier;

            // final userId = userDataVar?.auth?.identifier;

            // if (userId == null) {
            //   print('⚠️ No logged-in user ID found.');
            //   return null;
            // }

            // ✅ Find exporter linked to this user
            // final matched =
            //     exporters.where((exp) => exp.userId == userId).toList();

            // if (matched.isNotEmpty) {
            //   final exporter = matched.first;
            //   print('✅ Correct exporter found: ${exporter.exporterUniqueId}');
            //   return exporter;
            // } else {
            //   print('⚠️ No exporter found for userId: $userId');
            //   return null;
            // }
            // final exporters =
            //     (data['data']['results'] as List)
            //         .map((e) => ExporterModel.fromJson(e))
            //         .toList();

            // // ✅ Get current logged-in userId from login data
            // final userId =
            //     userDataVar?.auth?.identifier; // ✅ comes from login session
            // // from your saved session
            // if (userId == null) {
            //   print('⚠️ No logged-in user ID found.');
            //   return null;
            // }

            // ✅ Find exporter linked to this user
            // final exporter =
            //     exporters.where((exp) => exp.userId == userId).toList();
            // if (exporter.isNotEmpty) {
            //   print(
            //     '✅ Correct exporter found: ${exporter.first.exporterUniqueId}',
            //   );
            //   return exporter.first;
            // } else {
            //   print('⚠️ No exporter found for userId: $userId');
            //   return null;
            // }
            // final exporter = exporters.firstWhere(
            //   (exp) => exp.userId == userId,
            //   orElse: () {
            //     print('⚠️ No exporter found for userId: $userId');
            //     return exporters.isNotEmpty ? exporters.first : null;
            //   },
            // );
            //             final exporter = exporters.firstWhereOrNull((exp) => exp.userId == userId);
            // //

            //             if (exporter != null) {
            //               print('✅ Correct exporter found: ${exporter.exporterUniqueId}');
            //               return exporter;
            //             } else {
            //               print('⚠️ Exporter list is empty.');
            //             }
            // print('✅ Exporter found: ${exporter.exporterUniqueId}');
            // return exporter;
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
