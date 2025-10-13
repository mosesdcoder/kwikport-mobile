import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kwik_port/api/utils/utils.dart';

class UpdateKwikTicketStatusApi extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  String _message = '';
  String get message => _message;
  bool? isSuccessful;

   updateKwikTicketStatus({
    required String kwikTicketId,
    required bool isActive,
    required BuildContext context,
  }) async {
    _loading = true;
    notifyListeners();

    final url = Uri.parse('$baseUrl/v1/KwikTicket/set-ticket-status');
    debugPrint('🔹 Updating ticket status: $kwikTicketId → $isActive');

    try {
      var result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var body = {"kwikTicketId": kwikTicketId, "isActive": isActive};
        final response = await HttpService.postRequest(
          '/KwikTicket/set-ticket-status',
          body,
        );
        debugPrint('📩 Response: ${response.body}');
        final data = jsonDecode(response.body);
        if (response.statusCode == 200 && data["isSuccessful"] == true) {
          isSuccessful = true;
          print("Kwik ticket: ${data['status']}");

          _message = data["message"] ?? "Kwik ticket updated successfully!";
          notifyListeners();
        } else {
          isSuccessful = false;
          print("Kwik ticket: ${data['status']}");

          _message = data["message"] ?? "Failed to update Kwik ticket!";
        }
      } else {
        throw Exception('Failed to update ticket status: No internet');
      }
    } catch (e) {
      debugPrint('⚠️ Error updating ticket status: $e');
    }

    _loading = false;
    notifyListeners();
  }
}
