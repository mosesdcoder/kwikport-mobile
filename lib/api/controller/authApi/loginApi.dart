import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kwik_port/api/controller/authApi/fetchExportProfileApi.dart';
import 'package:kwik_port/api/model/signupResponse.dart';
import 'package:kwik_port/api/model/userModel.dart';
import 'package:kwik_port/api/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginApi extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  String _wrongPassword = "no";
  String get wrongPassword => _wrongPassword;

  bool _deviceExist = false;
  bool get deviceExist => _deviceExist;

  String _message = '';
  String get message => _message;

  bool _networkIss = false;
  bool get networkIss => _networkIss;

  int _networkStatusCode = 0;
  int get networkStatusCode => _networkStatusCode;
  var _hasCompletedProfile;
  dynamic get hasCompletedProfile => _hasCompletedProfile;
  ExporterModel? _exporter;
  ExporterModel? get exporter => _exporter;
  login(String username, password, BuildContext context) async {
    try {
      var result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var body = {"username": username, "password": password};
        print(body);
        final response = await HttpService.loginPostRequest(
          '/Access/login',
          body,
        );
        final data = json.decode(response.body);
        print('Response status: ${response.statusCode}');
        print('Response body: ${data}');
        print("here2");
        if (response.statusCode == 200 && data['isSuccessful'] == true) {
          print("Success");
          _message = data['message'] ?? "Login successful";
          _isLoggedIn = true;

          // ✅ Parse into AuthData
          final apiResponse = ApiResponse<AuthData>.fromJson(
            data,
            (json) => AuthData.fromJson(json),
          );

          if (apiResponse.data != null) {
            final auth = apiResponse.data!;
            final prefs = await SharedPreferences.getInstance();
            final userData = data['data'];
            // final existingSession = await loadUserSessionFromPrefs();
            // await saveFullUserSession(
            //   auth: auth,
            //   firstName:
            //       userData?['firstName'] ?? existingSession?.firstName ?? '',
            //   lastName:
            //       userData?['lastName'] ?? existingSession?.lastName ?? '',
            //   otherNames:
            //       userData?['otherNames'] ?? existingSession?.otherNames ?? '',
            //   email: userData?['email'] ?? existingSession?.email ?? '',
            //   phoneNumber:
            //       userData?['phoneNumber'] ??
            //       existingSession?.phoneNumber ??
            //       '',
            //   exporter: _exporter,
            // );
            // final session = UserSession(auth: auth, exporter: _exporter);
            // await saveUserSession(session);

            // await saveUserSession(UserSession(auth: auth));
            // await updateUserSession(auth: apiResponse.data);

            // final sessionString = prefs.getString('userSession');
            // await loadUserSessionFromPrefs();
            // final apiResponsee = ApiResponse<ExporterModel>.fromJson(
            //   data,
            //   (json) => ExporterModel.fromJson(json),
            // );
            // 🔹 Fetch exporter after login
            // final exporter = await fetchExporterProfile();

            // 🔹 Save to user session
            // final session = UserSession(auth: auth, exporter: _exporter);
            // await saveUserSession(session);
            // _exporter = apiResponsee.data;
            // updateUserSession(exporter: _exporter);

            // if (sessionString != null) {
            //   userDataVar = UserSession.fromJson(json.decode(sessionString));
            //   print(
            //     "✅ Loaded session exporter ID: ${userDataVar?.exporter?.exporterUniqueId}",
            //   );
            // } else {
            //   print("⚠️ No saved user session found.");
            // }
            // print("object${userDataVar?.exporter?.exporterUniqueId}");

            // ✅ Store tokens and expiry
            await prefs.setString('accessToken', auth.accessToken);
            await prefs.setString('refreshToken', auth.refreshToken);
            await prefs.setString(
              'accessTokenExpiresAt',
              auth.accessTokenExpiresAt!.toIso8601String(),
            );
            await prefs.setString(
              'refreshTokenExpiresAt',
              auth.refreshTokenExpiresAt!.toIso8601String(),
            );

            // ✅ Store basic user info
            await prefs.setString('username', auth.username ?? '');
            await prefs.setString('identifier', auth.identifier ?? '');
            // ✅ Fetch Exporter Profile
            final fetcher = FetchExportProfileApi();
            final exporter = await fetcher.fetchProfile();

            if (exporter != null) {
              // await prefs.setString(
              //   'exporterUniqueId',
              //   exporter.exporterUniqueId ?? '',
              // );
              // await prefs.setString(
              //   'businessName',
              //   exporter.businessName ?? '',
              // );
              print("✅ Exporter Profile Saved: ${exporter.exporterUniqueId}");
            } else {
              print("⚠️ No exporter profile found");
            }
            if (apiResponse.data != null && exporter != null) {
              final auth = apiResponse.data!;

              await saveFullUserSession(
                auth: auth,
                firstName: userData?['firstName'],
                lastName: userData?['lastName'],
                otherNames: userData?['otherNames'],
                email: userData?['email'],
                phoneNumber: userData?['phoneNumber'],
                exporter: exporter,
              );
              print(
                "✅ Login complete — exporter ID: ${exporter.exporterUniqueId}",
              );
            } else {
              print(
                "⚠️ Missing auth or exporter data — session not saved fully",
              );
            }

            print("✅ Login successful — tokens & session saved");
          } else {
            _isLoggedIn = false;
            _message = "Invalid login response format.";
          }

          print("Login Successful ✅, Tokens stored");
          notifyListeners();
        } else {
          print("Failed");
          _message = data['message'] ?? "Invalid username or password";
          _isLoggedIn = false;
          notifyListeners();
        }
      }
    } on SocketException catch (_) {
      print('not connected');
      _message = 'No Internet connection';
      _isLoggedIn = false;
      notifyListeners();
    } catch (e) {
      print(e);
      _message = 'An error occurred';
      _isLoggedIn = false;
      notifyListeners();
    }
  }
}
