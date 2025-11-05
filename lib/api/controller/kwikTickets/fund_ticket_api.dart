import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kwik_port/api/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class FundKwikticketApi extends ChangeNotifier {
  bool loading = false;
  String _message = '';
  String get message => _message;
  bool? isSuccessful;
  String? authorizationUrl;
  String? provider;
  String? paymentReference;

  Future<void> fundTicket({
    required String kwikTicketId,
    required String exporterId,
    required int fundingMethod,
  }) async {
    if (loading) return;
    loading = true;
    notifyListeners();

    try {
      // Check Internet
      var result = await InternetAddress.lookup('google.com');
      if (result.isEmpty || result[0].rawAddress.isEmpty) {
        throw Exception('No internet connection');
      }

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      if (token.isEmpty) {
        _message = "Authentication expired. Please log in again.";
        isSuccessful = false;
        loading = false;
        notifyListeners();
        return;
      }

      final body = {
        "kwikTicketId": kwikTicketId,
        "exporterId": exporterId,
        "fundingMethod": fundingMethod,
      };

      final response = await HttpService.postRequest(
        '/KwikTicket/fund-ticket', // ✅ adjust version as needed
        body,
        // headers: {
        //   'Authorization': 'Bearer $token',
        //   'Accept': 'application/json',
        // },
      );

      final data = json.decode(response.body);
      debugPrint("💳 Fund Ticket Response: $data");

      if (response.statusCode == 200 && data["isSuccessful"] == true) {
        isSuccessful = true;
        _message = data["message"] ?? "Payment link generated successfully";
        authorizationUrl = data["data"]["authorizationUrl"];
        paymentReference = data["data"]["paymentReference"];
        provider = data["data"]["provider"];
        print("objectMESAGE: $_message");
        debugPrint("kwikTicketId: $kwikTicketId, exporterId: $exporterId");
      } else {
        isSuccessful = false;
        _message = data["message"] ?? "Failed to fund ticket";
        print("objectMESAGE: $_message");
        debugPrint("kwikTicketId: $kwikTicketId, exporterId: $exporterId");
      }
    } catch (e) {
      _message = "Error funding ticket: $e";
      isSuccessful = false;
    }

    loading = false;
    notifyListeners();
  }

  // Future<void> openPaymentPage(String url) async {
  //   final Uri uri = Uri.parse(url);
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri, mode: LaunchMode.externalApplication);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
}
