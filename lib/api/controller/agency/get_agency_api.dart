import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kwik_port/api/model/agency_model.dart';
import 'package:kwik_port/api/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetAgencyApi extends ChangeNotifier {
  bool loading = false;
  bool hasMore = true;
  List<AgencyModel> agencies = [];
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

            if (newAgencies.isNotEmpty) {
              agencies.addAll(newAgencies.map((e) => AgencyModel.fromJson(e)));
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
          // agencies = List<Map<String, dynamic>>.from(data['data']);
          // final data = decoded['data'];

          if (data['data'] is List) {
            final List<dynamic> agencyList = data['data'];
            agencies = agencyList.map((e) => AgencyModel.fromJson(e)).toList();
            hasMore =
                false; // endpoint returns list for that stage — not paginated
          }
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

  /// GET /Agency/agencies/{stageType}
  // Future<void> fetchAgenciesByStageType(int stageType) async {
  //   if (loading) return;
  //   loading = true;
  //   notifyListeners();

  //   try {
  //     final response = await HttpService.getRequest('/Agency/agencies/$stageType');
  //     final decoded = json.decode(response.body);
  //     print('GET agencies by stageType $stageType status ${response.statusCode} body $decoded');

  //     final apiResp = ApiResponse.fromJson(decoded, (json) => json);
  //     if (response.statusCode == 200 && apiResp.isSuccessful) {
  //       final data = decoded['data'];
  //       if (data is List) {
  //         agencies = data.map((e) => AgencyModel.fromJson(e)).toList();
  //         hasMore = false; // endpoint returns list for that stage — not paginated
  //       } else {
  //         agencies = [];
  //       }
  //       message = apiResp.message;
  //     } else {
  //       agencies = [];
  //       message = apiResp.message.isNotEmpty ? apiResp.message : 'Failed to fetch agencies by stage';
  //     }
  //   } catch (e, st) {
  //     print('Error fetching agencies by stageType: $e\n$st');
  //     agencies = [];
  //     message = 'Error fetching agencies';
  //   } finally {
  //     loading = false;
  //     notifyListeners();
  //   }
  // }
  /// Optional: Reset pagination manually
  void resetPagination() {
    pageIndex = 1;
    hasMore = true;
    agencies.clear();
    notifyListeners();
  }
}
