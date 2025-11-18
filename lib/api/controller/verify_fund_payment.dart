import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kwik_port/api/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyFundPayment extends ChangeNotifier {
  bool loading = false;
  String _message = '';
  String get message => _message;
  String _status = '';
  String get status => _status;
  bool? isSuccessful;

  Future<void> verifyFundPayment({
    required String exporterId,
    required String referenceNumber,
  }) async {
    if (loading) return;
    loading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final body = {
        "exporterId": exporterId,
        "referenceNumber": referenceNumber,
      };

      final response = await HttpService.postRequest(
        '/KwikWallet/verify-payment',
        body,
      );

      final data = json.decode(response.body);
      debugPrint("✅ Verify Payment Response: $data");

      if (response.statusCode == 200 && data["isSuccessful"] == true) {
        isSuccessful = true;
        // _status = data["data"]["status"] ?? "";
        _message = data["message"] ?? "Payment verified successfully!";
      } else {
        isSuccessful = false;
        _message = data["message"] ?? "Payment verification failed.";
        // _status = data["data"]["status"] ?? "";
      }
    } catch (e) {
      _message = "Error verifying payment: $e";
      isSuccessful = false;
    }

    loading = false;
    notifyListeners();
  }
}
