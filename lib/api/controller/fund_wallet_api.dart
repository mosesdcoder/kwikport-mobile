// fund_wallet_api.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kwik_port/api/model/wallet_model.dart';
import 'package:kwik_port/api/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FundWalletApi extends ChangeNotifier {
  bool loading = false;
  FundWalletResponse? fundWalletResponse;
  String _message = '';
  String get message => _message;
  bool? isSuccessful;
  String? authorizationUrl;
  String? provider;
  String? paymentReference;

  Future<void> fundWallet({
    required String exporterId,
    required double amount,
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
        var body = {"exporterId": exporterId, "amount": amount};
        final response = await HttpService.postRequest(
          '/KwikWallet/fund-wallet',
          body,
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          fundWalletResponse = FundWalletResponse.fromJson(data);
          isSuccessful = fundWalletResponse?.isSuccessful ?? false;
          _message = fundWalletResponse?.message ?? 'Success';

          // FIX: Save values
          paymentReference = fundWalletResponse?.data?.paymentReference;
          authorizationUrl = fundWalletResponse?.data?.authorizationUrl;
          provider = fundWalletResponse?.data?.provider;
        } else {
          isSuccessful = false;
          _message = 'Request failed with status: ${response.statusCode}';
        }
      }
    } catch (e) {
      debugPrint("Error funding KwikWallet: $e");
      isSuccessful = false;
      _message = e.toString();
    }

    loading = false;
    notifyListeners();
    return null;
  }
}
