import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kwik_port/api/model/signupResponse.dart';
import 'package:kwik_port/api/model/userModel.dart';
import 'package:kwik_port/api/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyEmailApi extends ChangeNotifier {
  String _message = '';
  String get message => _message;
  bool _success = false;
  bool get success => _success;

  String _otpcode = '';
  String get otpcode => _otpcode;
  String _otpExpires = '';
  String get otpExpires => _otpExpires;

  verifyEmail(String code, email, BuildContext context) async {
    try {
      var result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        final sessionHash = prefs.getString('sessionHash') ?? '';

        if (sessionHash.isEmpty) {
          _message = "Session expired. Please sign up again.";
          _success = false;
          notifyListeners();
          return;
        }
        var body = {"code": code, "sessionHash": sessionHash, "email": email};
        print("Verify OTP Request body: $body");
        final response = await HttpService.postRequestNoAuth(
          '/Access/verify-otp',
          body,
        );
        print("Response status: ${response.statusCode}");
        final data = json.decode(response.body);
        print("Response body: $data");
        print("OTP request body: $body");

        if (response.statusCode == 200 && data['isSuccessful'] == true) {
          _otpcode = data['code'];
          final apiResponse = ApiResponse<AuthData>.fromJson(
            data,
            (json) => AuthData.fromJson(json),
          );

          if (apiResponse.isSuccessful && apiResponse.data != null) {
            _success = true;
            _message = apiResponse.message ?? "OTP verified successfully";

            final auth = apiResponse.data!;

            // ✅ Save tokens
            // await prefs.setString('accessToken', auth.accessToken);
            // await prefs.setString('refreshToken', auth.refreshToken);
            // await prefs.setString(
            //   'accessTokenExpiresAt',
            //   auth.accessTokenExpiresAt!.toIso8601String(),
            // );

            // await prefs.setString(
            //   'refreshTokenExpiresAt',
            //   auth.refreshTokenExpiresAt!.toIso8601String(),
            // );
            // ✅ Save tokens
            if (auth.accessToken != null) {
              await prefs.setString('accessToken', auth.accessToken!);
            }
            if (auth.refreshToken != null) {
              await prefs.setString('refreshToken', auth.refreshToken!);
            }
            if (auth.accessTokenExpiresAt != null) {
              await prefs.setString(
                'accessTokenExpiresAt',
                auth.accessTokenExpiresAt!.toIso8601String(),
              );
            }
            if (auth.refreshTokenExpiresAt != null) {
              await prefs.setString(
                'refreshTokenExpiresAt',
                auth.refreshTokenExpiresAt!.toIso8601String(),
              );
            }
            if (auth.username != null) {
              await prefs.setString('username', auth.username!);
            }
            if (auth.identifier != null) {
              await prefs.setString('identifier', auth.identifier!);
            }

            // ✅ Save user info
            // await prefs.setString('username', auth.username!);
            // await prefs.setString('identifier', auth.identifier!);

            // ✅ Save AuthData + Session
            // final auth = AuthData.fromJson(data['data']);
            await saveAuthDataToPrefs(auth);
            // await saveUserSessionToPrefs(UserSession(auth: auth));

            print("OTP Verified ✅, Tokens stored");
          } else {
            _success = false;
            _message = apiResponse.message ?? "Invalid OTP or session expired";
          }

          print("OTP Verified ✅, Tokens stored");
          notifyListeners();
        } else if (response.statusCode == 400) {
          _message = data['error']['message'] ?? 'Invalid OTP';
          print("Invalid OTP$_message");
          _success = false;
          notifyListeners();
        } else {
          _message = data['message'] ?? 'Invalid OTP or session expired';
          _success = false;
          notifyListeners();
        }
      }
    } catch (e) {
      print("Error in verifyOtpApi: ${e.toString()}");
    }
  }
}
