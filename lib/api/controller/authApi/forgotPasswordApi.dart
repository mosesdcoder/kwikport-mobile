import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:kwik_port/api/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPasswordApi extends ChangeNotifier {
  String _message = '';
  String get message => _message;

  bool _success = false;
  bool get success => _success;

  String _sessionHash = '';
  String get sessionHash => _sessionHash;

  Future<void> forgotPassword(String email) async {
    try {
      var result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var body = {"email": email};
        print(body);
        final response = await HttpService.postRequestNoAuth(
          '/Access/forgot-password',
          body,
        );
        final data = json.decode(response.body);
        print('Response status: ${response.statusCode}');
        print('Response body: ${data}');
        if (response.statusCode == 200 && data['isSuccessful'] == true) {
          print("Success");
          _message = data['message'] ?? "OTP sent successfully";
          _sessionHash = data['data']?['sessionHash'] ?? '';

          _success = true;
          // print("OTP being sent: $code");
          
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('sessionHash', data['data']['sessionHash']);
          print("Email being sent: $email");
          print("SessionHash being sent: $sessionHash");

          // if (_sessionHash.isNotEmpty) {
          //   final prefs = await SharedPreferences.getInstance();
          //   await prefs.setString('sessionHash', _sessionHash);
          // }
        } else {
          print("Failed");
          _message = data['message'] ?? "Failed to send OTP";
          _success = false;
        }

        notifyListeners();
      }
    } on SocketException catch (_) {
      print('No Internet connection');
      _message = "No Internet connection";
      _success = false;
      notifyListeners();
    } catch (e) {
      print('Error: $e');
      _message = "Error: ${e.toString()}";
      _success = false;
      notifyListeners();
    }
  }
}
