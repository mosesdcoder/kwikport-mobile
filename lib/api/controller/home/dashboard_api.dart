// lib/api/controller/dashboard_api.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kwik_port/api/model/dashboard_model.dart';
import 'package:kwik_port/api/model/signupResponse.dart';
import 'package:kwik_port/api/utils/utils.dart'; // for HttpService
import 'package:kwik_port/api/model/userModel.dart'; // if ApiResponse is here
// import 'package:kwik_port/api/model/contractModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardApi extends ChangeNotifier {
  bool _loading = false;
  String _message = '';
  DashboardModel? _data;

  bool get loading => _loading;
  String get message => _message;
  DashboardModel? get data => _data;

  Future<void> fetchDashboard({bool refresh = false}) async {
    if (_loading) return;
    _loading = true;
    _message = '';
    notifyListeners();

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isEmpty || result[0].rawAddress.isEmpty) {
        throw Exception('No internet connection');
      }

      final response = await HttpService.getRequest(
        '/Dashboard/user-dashboard',
      );
      final decoded = json.decode(response.body);
      // Use the same ApiResponse<T> as in your project:
      final apiResponse = ApiResponse.fromJson(
        decoded,
        (json) => DashboardModel.fromJson(json),
      );

      if (response.statusCode == 200 && apiResponse.isSuccessful) {
        _data = apiResponse.data;
        _message = apiResponse.message;
        // final userProfile = data?['data']?['userProfile'];
        final userProfile = _data?.userProfile;
        // Update global session
        if (userProfile != null) {
          final updatedSession = UserSession(
            auth: userDataVar?.auth,
            firstName: userProfile.firstName,
            lastName: userProfile.lastName,
            email: userProfile.email,
            phoneNumber: userProfile.phoneNumber,
            exporter:
                userDataVar
                    ?.exporter, // keep exporter info if already available
          );
          await saveUserSession(updatedSession);
          print("✅ User session updated from Dashboard");
          print("Exports count: ${apiResponse.data?.exports.length}");
        } else {
          print("⚠️ userProfile is null in Dashboard response");
        }
      } else {
        // handle non-200 or unsuccessful
        _message =
            apiResponse.message.isNotEmpty
                ? apiResponse.message
                : 'Failed to fetch dashboard';
      }
    } catch (e, st) {
      print('Dashboard fetch error: $e\n$st');
      _message = 'Error fetching dashboard';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> refreshUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString('userSession');
    if (userStr != null) {
      userDataVar = UserSession.fromJson(jsonDecode(userStr));
      notifyListeners(); // 👈 forces UI to rebuild
    }
  }

  // small helpers:
  int get activeKwikTicketsCount =>
      _data?.kwikTickets.where((t) => t.isActive == true).length ?? 0;

  int get completedExportsCount =>
      _data?.exports.where((e) => e.completedAt != null).length ?? 0;
}
