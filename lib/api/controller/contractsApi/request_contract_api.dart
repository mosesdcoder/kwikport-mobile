import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kwik_port/api/model/request_contract_payload.dart';
import 'package:kwik_port/api/model/request_contract_response.dart';
import 'package:kwik_port/api/utils/utils.dart';

class RequestContractApi extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  RequestContractResponse? _contractResponse;
  RequestContractResponse? get contractResponse => _contractResponse;

  String? _error;
  String? get error => _error;

  Future<void> requestContract(RequestContractPayload payload) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await HttpService.postRequest(
        '/Contracts/request-contract',
        payload.toJson(),
      );

      if (response.statusCode == 200) {
        _contractResponse = RequestContractResponse.fromJson(json.decode(response.body));
      } else {
        _error = 'Failed to request contract: ${response.statusCode}';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
