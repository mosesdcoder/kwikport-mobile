import 'package:flutter/material.dart';
import 'package:kwik_port/api/model/dashboard_model.dart';
import 'package:kwik_port/api/model/signupResponse.dart';
import 'package:kwik_port/api/model/userModel.dart';
import 'dart:convert';
import 'dart:io';
import 'package:kwik_port/api/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateKwikticketApi extends ChangeNotifier {
  bool loading = false;
  String _message = '';
  String get message => _message;
  bool? isSuccessful;
  KwikTicketModel? _ticket;
  KwikTicketModel? get ticket => _ticket;
  createKwikTicket({
    required String exportContractId,
    required String exporterId,
    required double peggedDollarValue,
    required String badge,
    required DateTime deadline,
    required double kwikTicketAmount,
    required double projectedIncomeInDollars,
  }) async {
    if (loading) return null;
    loading = true;
    notifyListeners();

    try {
      // Check internet
      var result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Prepare request body
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('accessToken') ?? '';

        if (token.isEmpty) {
          _message = "Authentication expired. Please log in again.";
          isSuccessful = false;
          notifyListeners();
          return;
        }
        var body = {
          "exportContractId": exportContractId,
          "exporterId": exporterId,
          "peggedDollarValue": peggedDollarValue,
          "badge": badge,
          "deadline": deadline.toIso8601String(),
          "kwikTicketAmount": kwikTicketAmount,
          "projectedIncomeInDollars": projectedIncomeInDollars,
        };

        // Send POST request
        final response = await HttpService.postRequest(
          '/KwikTicket/create',
          body,
        );

        response.headers['Authorization'] = "Bearer $token";
        response.headers['Accept'] = "application/json";
        final data = json.decode(response.body);
        debugPrint("🎫 KwikTicket Response: $data");

        if (response.statusCode == 200 && data["isSuccessful"] == true) {
          isSuccessful = true;
          print("Access token from SharedPreferences: $token");

          _message = data["message"] ?? "Kwik ticket created successfully!";
          loading = false;
          notifyListeners();
          // final apiResponse = ApiResponse<KwikTicketModel>.fromJson(
          //   data,
          //   (json) => KwikTicketModel.fromJson(json),
          // );
          if (data["data"] != null) {
            _ticket = KwikTicketModel.fromJson(data["data"]);
          } else {
            _ticket = null;
          }

          // _ticket = apiResponse.data;
          if (_ticket != null) {
            // ✅ Save exporter data to SharedPreferences
            // await prefs.setString('exporter', json.encode(_ticket!.toJson()));
            // await saveUserSession(
            //   UserSession(
            //     auth: userDataVar?.auth, // keep existing token
            //     exporter: _ticket, // add exporter info
            //   ),
            // );

            // ✅ Add to user session
            // await saveUserSessionToPrefs(UserSession(exporter: _ticket));
            // await updateUserSession(exporter: exporter);

            print("✅  created: ${_ticket!.exportContractId}");
          } else {
            print("⚠️ No kwikticket data returned.");
          }
          return _ticket;
        } else {
          print("Access token from SharedPreferences: $token");

          isSuccessful = false;
          _message = data["message"] ?? "Ticket creation failed";
        }
      } else {
        throw Exception('Failed to load contracts');
      }
    } catch (e) {
      debugPrint("Error creating KwikTicket: $e");
      isSuccessful = false;
      _message = e.toString();
    }

    loading = false;
    notifyListeners();
    return null;
  }
}
