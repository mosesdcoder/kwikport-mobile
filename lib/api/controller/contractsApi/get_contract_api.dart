// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:kwik_port/api/model/contractModel.dart';
// import 'package:kwik_port/api/model/dashboard_model.dart';
// import 'package:kwik_port/api/utils/utils.dart';

// class GetContractApi extends ChangeNotifier {
//   List<ContractModel> _contracts = [];
//   List<ContractModel> get contracts => _contracts;

//   bool _loading = false;
//   bool get loading => _loading;

//   String _message = '';
//   String get message => _message;

//   bool _hasMore = true;
//   bool get hasMore => _hasMore;

//   int _pageIndex = 1;
//   final int _pageSize = 10;

//   /// Fetch contracts (with pagination and optional refresh)
//  fetchContracts({
//     bool refresh = false,
//     bool isActive = true,
//     String? id,
//   }) async {
//     if (_loading) return;

//     // Reset when refreshing
//     if (refresh) {
//       _pageIndex = 1;
//       _contracts.clear();
//       _hasMore = true;
//     }

//     _loading = true;
//     notifyListeners();

//     try {
//       var result = await InternetAddress.lookup('google.com');
//       if (result.isEmpty || result[0].rawAddress.isEmpty) {
//         throw Exception('No internet connection');
//       }

//       final String queryParams = Uri(
//         queryParameters: {
//           if (id != null) 'Id': id,
//            'IsActive': isActive.toString(),
//           'PageIndex': _pageIndex.toString(),
//           'PageSize': _pageSize.toString(),
//         },
//       ).query;

//       final response = await HttpService.getRequest(
//         '/Contract/get-contracts?$queryParams',
//       );

//       final data = json.decode(response.body);
//       print('📩 Status: ${response.statusCode}, Body: $data');

//       if (response.statusCode == 200 && data['isSuccessful'] == true) {
//         final results = data['data']['results'] as List?;
//         if (results != null && results.isNotEmpty) {
//           final fetched = results
//               .map((json) => ContractModel.fromJson(json))
//               .toList();

//           _contracts.addAll(fetched);
//           _pageIndex++;
//           _hasMore = fetched.length == _pageSize;
//           _message = data['message'] ?? 'Contracts fetched successfully';
//         } else {
//           _hasMore = false;
//           _message = 'No more contracts available';
//         }
//       } else {
//         _message = data['message'] ?? 'Failed to fetch contracts';
//       }
//     } catch (e, st) {
//       print("❌ Error fetching contracts: $e\n$st");
//       _message = "Error loading contracts";
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }

//   /// Manual reload (pull-to-refresh)
//   Future<void> refreshContracts() async {
//     await fetchContracts(refresh: true);
//   }
// }
