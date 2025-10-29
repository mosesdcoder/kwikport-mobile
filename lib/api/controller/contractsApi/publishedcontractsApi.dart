import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kwik_port/api/model/dashboard_model.dart';
import 'package:kwik_port/api/utils/utils.dart';

class GetContractApi extends ChangeNotifier {
  List<ContractModel> _contracts = [];
  List<ContractModel> get contracts => _contracts;

  bool _loading = false;
  bool get loading => _loading;

  String _message = '';
  String get message => _message;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  int _pageIndex = 1;
  final int _pageSize = 10;

  Future<void> fetchContracts({
    bool refresh = false,
    bool isActive = true,
    String? id,
  }) async {
    if (_loading) return;
    _loading = true;
    notifyListeners();
    try {
      var result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // final url = Uri.parse(
        //   '$baseUrl/v$version/Exporter/get-published-contracts?PageIndex=$pageIndex&PageSize=$pageSize',
        // );
        final response = await HttpService.getRequest(
          '/Contracts/get-contracts?PageIndex=$_pageIndex&PageSize=$_pageSize',
          // body,
        );
        final data = json.decode(response.body);
        print('Status: ${response.statusCode}, Body: $data');

        if (response.statusCode == 200 && data['isSuccessful'] == true) {
          final results = data['data']['results'] as List?;
          if (results != null && results.isNotEmpty) {
            final fetched =
                results.map((json) => ContractModel.fromJson(json)).toList();
            _contracts.addAll(fetched);
            _pageIndex++;
            _hasMore = fetched.length == _pageSize;
            _message = data['message'] ?? 'Contracts fetched successfully';
          } else {
            _hasMore = false;
            _message = 'No active contracts found.';
          }
        } else {
          //  _hasMore = false;
          _message = data['message'] ?? 'Failed to fetch contracts';
        }

        _loading = false;
        notifyListeners();
      } else {
        throw Exception('Failed to load contracts');
      }
    } catch (e) {
      print("Error fetching contracts: $e");
      _loading = false;
      _message = "Error loading contracts";
      notifyListeners();
    }
  }

  /// For manual reload (pull-to-refresh)
  Future<void> refreshContracts() async {
    await fetchContracts(refresh: true);
  }

  List<ContractModel> getContractsByCategory(int categoryId) {
    return _contracts.where((c) => c.contractCategory == categoryId).toList();
  }
}
