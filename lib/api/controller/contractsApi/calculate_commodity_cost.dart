import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kwik_port/api/model/dashboard_model.dart';
import 'package:kwik_port/api/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalculateCommodityCostApi extends ChangeNotifier {
  bool loading = false;
  String _message = '';
  String get message => _message;
  CommodityCostModel? commodityCost;

  Future<void> calculateCost({
    required String commodityId,
    required int units,
  }) async {
    if (loading) return;
    loading = true;
    notifyListeners();
    try {
      var result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('accessToken') ?? '';

        final body = {"commodityId": commodityId, "units": units};

        final response = await HttpService.postRequest(
          '/Commodity/calculate-commodity-cost',
          body,
          // headers: {'Authorization': 'Bearer $token'},
        );
        debugPrint("📤 Sending to API: $body");

        final data = json.decode(response.body);
        debugPrint("📦 Commodity Cost Response: $data");

        if (response.statusCode == 200 && data["isSuccessful"] == true) {
          commodityCost = CommodityCostModel.fromJson(data["data"]);

          _message =
              data["message"] ?? "Commodity cost calculated successfully!";
        } else {
          _message = data["message"] ?? "Failed to calculate commodity cost.";
        }
      }
    } catch (e) {
      print("Error calculating: $e");
      loading = false;
      _message = "Error  ";
      notifyListeners();
    } finally {
      loading = false;
      notifyListeners(); // 👈 CRUCIAL
    }
  }
}
