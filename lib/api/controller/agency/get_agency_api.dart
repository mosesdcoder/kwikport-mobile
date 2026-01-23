import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kwik_port/api/model/agency_model.dart';
import 'package:kwik_port/api/model/agency_fee_model.dart';
import 'package:kwik_port/api/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetAgencyApi extends ChangeNotifier {
  bool loading = false;
  bool hasMore = true;
  List<AgencyModel> agencies = [];
  int pageIndex = 1;
  final int pageSize = 10;

  fetchAgencies({
    required int tonnage,
    required int agencyType,
    bool loadMore = false,
  }) async {
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

        final newAgencies = await calculateAgencyFee(
          tonnage: tonnage,
          agencyType: agencyType,
          pageIndex: pageIndex,
          pageSize: pageSize,
        );

        debugPrint('📦 Fetching agencies page $pageIndex');

        if (newAgencies.isNotEmpty) {
          agencies.addAll(newAgencies);
          pageIndex++;
        } else {
          // ✅ No more pages
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

  Future<List<AgencyModel>> calculateAgencyFee({
    required int tonnage,
    required int agencyType,
    int pageIndex = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await HttpService.getRequest(
        '/Agency/calculate-agency-fee?tonnage=$tonnage&agencyType=$agencyType&pageIndex=$pageIndex&pageSize=$pageSize',
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body) as Map<String, dynamic>;
        debugPrint(
          'calculateAgencyFee response: ${response.statusCode} ${response.body}',
        );
        if (decoded['isSuccessful'] == true &&
            decoded['data'] != null &&
            decoded['data']['results'] != null) {
          final List<dynamic> results = decoded['data']['results'];
          return results.map((e) => AgencyModel.fromJson(e)).toList();
        }
      } else {
        debugPrint('calculateAgencyFee non-200: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error calculateAgencyFee: $e');
    }
    return [];
  }

  fetchAgenciesByStageType(int stageType, {required int tonnage}) async {
    try {
      loading = true;
      notifyListeners();

      // Always use calculateAgencyFee as the primary method
      final agenciesWithFees = await calculateAgencyFee(
        tonnage: tonnage,
        agencyType: stageType,
        pageIndex: 1,
        pageSize: 100, // Get all agencies with fees
      );

      agencies = agenciesWithFees;
      hasMore = false; // endpoint returns list for that stage — not paginated
      debugPrint(
        'Fetched ${agenciesWithFees.length} agencies with calculated fees for stageType $stageType',
      );
    } catch (e) {
      debugPrint('Error fetching agencies by stageType: $e');
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
