import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kwik_port/api/model/userModel.dart';
import 'package:kwik_port/api/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateUserApi extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  String _message = '';
  String get message => _message;
  bool _success = false;
  bool get success => _success;

  UserSession? updatedUser;

  Future<bool> updateUser({
    required String id,
    required String firstName,
    required String lastName,
    String? otherNames,
    String? phoneNumber,
    String? image,
    String? address,
    String? city,
    String? nationality,
    DateTime? dateOfBirth,
    required String email,
  }) async {
    try {
      _loading = true;
      notifyListeners();

      var result = await InternetAddress.lookup('google.com');
      if (result.isEmpty || result[0].rawAddress.isEmpty) {
        _message = 'No Internet Connection';
        _loading = false;
        notifyListeners();
        return false;
      }

      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      if (accessToken == null || accessToken.isEmpty) {
        _message = "User not authenticated";
        _loading = false;
        notifyListeners();
        return false;
      }

      final body = {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "otherNames": otherNames ?? "",
        "phoneNumber": phoneNumber ?? "",
        "image": image ?? "",
        "dateOfBirth": dateOfBirth?.toIso8601String(),
        "address": address ?? "",
        "city": city ?? "",
        "nationality": nationality ?? "",
      };

      print("🟢 UpdateUser Request: $body");

      final response = await HttpService.putRequest(
        '/Access/update-user',
        body,
      );

      print("🟢 UpdateUser Response: ${response.body}");

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['isSuccessful'] == true) {
        _message = data['message'] ?? "Profile updated successfully";
        _loading = false;
        _success = true;
        final userData = data['data'];
        if (userData != null) {
          final session = await loadUserSessionFromPrefs();
          final userData = data['data'];
          if (session != null) {
            // Update local session
            final updatedSession = session.copyWith(
              firstName: userData['firstName'] ?? session.firstName,
              lastName: userData['lastName'] ?? session.lastName,
              phoneNumber: userData['phoneNumber'] ?? session.phoneNumber,
              email: userData['email'] ?? session.email,
              // imageUrl: userData['imageUrl'] ?? session.imageUrl,
            );

            await saveUserSession(updatedSession);
            updatedUser = updatedSession;
            // session.firstName = data['data']['firstName'];
            // session.lastName = data['data']['lastName'];
            // session.phoneNumber = data['data']['phoneNumber'];
            // session.email = data['data']['email'];
            // await saveUserSession(session);
          }
          // await prefs.setString('firstName', userData['firstName'] ?? '');
          // await prefs.setString('lastName', userData['lastName'] ?? '');
          // await prefs.setString('phoneNumber', userData['phoneNumber'] ?? '');
          // await prefs.setString('imageUrl', userData['imageUrl'] ?? '');
        }
        notifyListeners();
        return true;
      } else {
        _success = false;
        _message = data['message'] ?? "Failed to update profile";
        _loading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _message = "Error: ${e.toString()}";
      _loading = false;
      notifyListeners();
      return false;
    }
  }
}
