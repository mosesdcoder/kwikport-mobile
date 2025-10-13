import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:kwik_port/api/utils/utils.dart';

class ResetPasswordApi extends ChangeNotifier {
  String _message = '';
  String get message => _message;

  bool _success = false;
  bool get success => _success;

  resetPassword(
    String otp,
    String sessionHash,
    String email,
    String password,
    String confirmPassword,
    BuildContext context,
  ) async {
    try {
      var result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final body = {
          "otp": otp,
          "sessionHash": sessionHash,
          "email": email,
          "password": password,
          "confirmPassword": confirmPassword,
        };
        final response = await HttpService.postRequest(
          '/Access/reset-password',
          body,
        );
        final data = json.decode(response.body);

        if (response.statusCode == 200 && data['isSuccessful'] == true) {
          _message = data['message'] ?? "Password reset successful";
          _success = true;
        } else {
          _message = data['message'] ?? "Password reset failed";
          _success = false;
        }
        notifyListeners();
      }
    } on SocketException {
      _message = "No Internet connection";
      _success = false;
      notifyListeners();
    } catch (e) {
      _message = "Error: ${e.toString()}";
      _success = false;
      notifyListeners();
    }
  }
}
