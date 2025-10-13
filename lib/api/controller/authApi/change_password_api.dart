import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kwik_port/api/utils/utils.dart';

class ChangePasswordApi extends ChangeNotifier {
  bool loading = false;
  String _message = '';
  String get message => _message;
  bool _success = false;
  bool get success => _success;

  changePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
    BuildContext context,
  ) async {
    if (loading) return;

    loading = true;
    notifyListeners();

    try {
      // Check internet
      var result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Make the API call
        var body = {
          "currentPassword": currentPassword,
          "newPassword": newPassword,
          "confirmPassword": confirmPassword,
        };
        final response = await HttpService.postRequest(
          '/Access/change-password',
          body,

          // requireAuth: true, // ensures token is added
        );

        final data = json.decode(response.body);
        debugPrint("🔐 Change Password Response: $data");

        if (response.statusCode == 200 && data["isSuccessful"] == true) {
          _success = true;
          _message = data["message"] ?? "Password changed successfully";
        } else {
          _success = false;
          _message = data["message"] ?? "Failed to change password";
        }
      }
    } catch (e) {
      debugPrint("Error changing password: $e");
      _success = false;
      _message = "Error: $e";
    }

    loading = false;
    notifyListeners();
  }
}
