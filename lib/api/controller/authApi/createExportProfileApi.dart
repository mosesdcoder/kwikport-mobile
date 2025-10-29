import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kwik_port/api/model/signupResponse.dart';
import 'package:kwik_port/api/model/userModel.dart';
import 'package:kwik_port/api/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateExportProfileApi extends ChangeNotifier {
  bool _profileCreationSuccess = false;
  bool get profileCreationSuccess => _profileCreationSuccess;

  String _message = '';
  String get message => _message;
  ExporterModel? _exporter;
  ExporterModel? get exporter => _exporter;

  createExportProfile(
    String businessName,
    String businessEmail,
    String logoUrl,
    String city,
    String country,
    String state,
    File? image,
    BuildContext context,
  ) async {
    try {
      var result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('accessToken') ?? '';

        if (token.isEmpty) {
          _message = "Authentication expired. Please log in again.";
          _profileCreationSuccess = false;
          notifyListeners();
          return;
        }
        var body = {
          "businessName": businessName,
          "businessEmail": businessEmail,
          "logoUrl": logoUrl,
          "city": city,
          "country": country,
          "state": state,
        };

        print(body);
        // final prefs = await SharedPreferences.getInstance();
        // final token = prefs.getString('accessToken') ?? '';
        final response = await HttpService.postRequest(
          '/Exporter/create',
          // image,
          body,
          // 'image',
        );

        response.headers['Authorization'] = "Bearer $token";
        response.headers['Accept'] = "application/json";
        // final responseBody = await response.stream.bytesToString();
        print("here1");
        final data = json.decode(response.body);
        print('Response status: ${response.statusCode}');
        print('Response body: ${data}');
        print("here2");
        if (response.statusCode == 200) {
          _message = data['message'] ?? "Exporter profile created successfully";
          _profileCreationSuccess = true;

          final apiResponse = ApiResponse<ExporterModel>.fromJson(
            data,
            (json) => ExporterModel.fromJson(json),
          );

          _exporter = apiResponse.data;

          if (_exporter != null) {
            // ✅ Save exporter data to SharedPreferences
            await prefs.setString('exporter', json.encode(_exporter!.toJson()));
            await saveUserSession(
              UserSession(
                auth: userDataVar?.auth, // keep existing token
                exporter: _exporter, // add exporter info
              ),
            );

            // ✅ Add to user session
            // await saveUserSessionToPrefs(UserSession(exporter: _exporter));
            await updateUserSession(exporter: exporter);

            print("✅ Exporter created: ${_exporter!.exporterUniqueId}");
          } else {
            print("⚠️ No exporter data returned.");
          }

          notifyListeners();
        } else {
          print("Failed");
          _message = data['message'] ?? "Failed to create exporter";
          _profileCreationSuccess = false;
          notifyListeners();
        }
      }
    } on SocketException catch (_) {
      print('not connected');
      _message = 'No Internet connection';
      _profileCreationSuccess = false;
      notifyListeners();
    } catch (e) {
      print(e);
      _message = 'An error occurred';
      _profileCreationSuccess = false;
      notifyListeners();
    }
  }
}
