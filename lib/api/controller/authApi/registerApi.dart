import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kwik_port/api/model/signupResponse.dart';
import 'package:kwik_port/api/model/userModel.dart';
import 'package:kwik_port/api/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Registerapi extends ChangeNotifier {
  bool _registrationSuccess = false;
  bool get registrationSuccess => _registrationSuccess;
  bool _resgistrationSuccess2 = false;
  bool get registrationSuccess2 => _resgistrationSuccess2;

  String _message = '';
  String get message => _message;
  String _sessionHash = ''; // ✅ add this
  String get sessionHash => _sessionHash;

  registerApi(
    firstName,
    lastName,
    otherNames,
    email,
    phoneNumber,
    String password,
    BuildContext context,
  ) async {
    try {
      var result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var body = {
          "firstName": firstName,
          "lastName": lastName,
          "otherNames": otherNames,
          "email": email,
          "phoneNumber": phoneNumber,
          "password": password,
        };
        print(body);
        final response = await HttpService.registerPostRequest(
          '/Access/signup',
          body,
        );
        print("here1");
        final data = json.decode(response.body);
        print('Response status: ${response.statusCode}');
        print('Response body: ${data}');
        print("here2");
        // ✅ Parse into ApiResponse<SignupData>
        final apiResponse = ApiResponse.fromJson(
          data,
          (json) => SignupData.fromJson(json),
        );
        if (response.statusCode == 200) {
          print("Success");
          //   var data = jsonDecode(response.body);
          _message = data['message'];
          _registrationSuccess = true;

          final signupResponse = SignupResponse.fromJson(data);

          if (signupResponse.isSuccessful) {
            final session = UserSession(
              firstName: firstName,
              lastName: lastName,
              otherNames: otherNames,
              phoneNumber: phoneNumber,
              email: email,
            );

            await saveUserSession(session);
            _message = signupResponse.message;
            _registrationSuccess = true;
            print("Signup message: ${data['message']}");

            // ✅ Check if OTP or related info is present
            if (data['data'] != null) {
              print("Signup data: ${data['data']}");
            }

            // ✅ Save identifier/sessionHash for OTP verify
            if (apiResponse.data != null) {
              _sessionHash =
                  apiResponse.data!.identifier ?? ''; // ✅ store in variable

              final prefs = await SharedPreferences.getInstance();
              await prefs.setString("sessionHash", _sessionHash);

              print("Session hash saved: $_sessionHash");
              // final prefs = await SharedPreferences.getInstance();
              // await prefs.setString(
              //   "sessionHash",
              //   apiResponse.data!.identifier,
              // );
              // print("Session hash saved: ${apiResponse.data!.identifier}");
            }
          } else {
            _message =
                apiResponse.message.isNotEmpty
                    ? apiResponse.message
                    : "Signup failed";
            _registrationSuccess = false;
            print("Signup error message: $_message");
          }

          notifyListeners();
        } else {
          var data = jsonDecode(response.body);
          _message = data['message'] ?? 'An error occurred';
          _registrationSuccess = false;
          print(_message);
          notifyListeners();
        }
        notifyListeners();
      } else {
        print('Check your Network');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
