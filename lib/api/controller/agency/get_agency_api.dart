import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kwik_port/api/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetAgencyApi extends ChangeNotifier {
  bool loading = false;
  bool hasMore = true;
  List<dynamic> agencies = [];
  int pageIndex = 1;
  final int pageSize = 10;

  fetchAgencies({bool loadMore = false}) async {
    if (loading) return; // prevent duplicate calls
    if (!hasMore && loadMore) return; // no more pages

    loading = true;
    notifyListeners();

    try {
      var result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (!loadMore) {
          // If not loading more, reset state
          agencies.clear();
          pageIndex = 1;
          hasMore = true;
        }
        final response = await HttpService.getRequest(
          '/Agency/get-agencies?PageIndex=$pageIndex&PageSize=$pageSize',
          
        );
        final data = json.decode(response.body);
        print('📦 Fetching agencies page $pageIndex');
        print('Status: ${response.statusCode}, Body: $data');
        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data["isSuccessful"] == true &&
              data["data"] != null &&
              data["data"]["results"] != null) {
            final responseData = data["data"];
            final List<dynamic> newAgencies = data["data"]["results"];

            // ✅ This is the key fix
            // if (responseData["results"] != null &&
            //     responseData["results"] is List) {
            //   agencies = responseData["results"];
            // } else {
            //   agencies = [];
            // }
            if (newAgencies.isNotEmpty) {
              // ✅ Add new items to the list (pagination)
              agencies.addAll(newAgencies);
              pageIndex++;
            } else {
              // ✅ No more pages
              hasMore = false;
            }
          } else {
            // agencies = [];
            hasMore = false;
          }
        } else {
          // agencies = [];
          hasMore = false;
        }
      } else {
        throw Exception('Failed to load agencies');
      }
    } catch (e) {
      debugPrint("Error fetching agencies: $e");
      agencies = [];
    }

    loading = false;
    notifyListeners();
  }

  fetchAgenciesByStageType(int stageType) async {
    try {
      loading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final response = await HttpService.getRequest(
        '/Agency/agencies/$stageType',
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['isSuccessful'] == true) {
          agencies = List<Map<String, dynamic>>.from(data['data']);
        } else {
          agencies = [];
        }
      } else {
        agencies = [];
      }
    } catch (e) {
      print('Error fetching agencies by stageType: $e');
      agencies = [];
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  /// Optional: Reset pagination manually
  void resetPagination() {
    pageIndex = 1;
    hasMore = true;
    agencies.clear();
    notifyListeners();
  }
}
