import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kwik_port/api/model/kyc_verification_request.dart';
import 'package:kwik_port/api/model/signupResponse.dart';
import 'package:kwik_port/api/utils/utils.dart';

class SubmitKycApi extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  KycRequestPayload? kycRequestPayload;
KycRequestPayload ? get getKycRequestPayload => kycRequestPayload;


  String? _error;
  String? get error => _error;

  Future<void> submitKyc(KycRequestPayload  payload) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await HttpService.postRequest(
        '/KycProfile/create',
        payload.toJson(),
      );

      if (response.statusCode == 200) {
        final submitKycResponse = ApiResponse<KycRequestPayload>.fromJson(json.decode(response.body), (json) => KycRequestPayload.fromJson(json));
        kycRequestPayload = submitKycResponse.data;
      } else {
        _error = 'Failed to save kyc details: ${response.statusCode}';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
