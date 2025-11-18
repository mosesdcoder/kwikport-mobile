// fund_wallet_model.dart
import 'dart:convert';

class FundWalletResponse {
  final bool isSuccessful;
  final String message;
  final String responseCode;
  final List<String> errors;
  final FundWalletData? data;

  FundWalletResponse({
    required this.isSuccessful,
    required this.message,
    required this.responseCode,
    required this.errors,
    this.data,
  });

  factory FundWalletResponse.fromJson(Map<String, dynamic> json) {
    return FundWalletResponse(
      isSuccessful: json['isSuccessful'] ?? false,
      message: json['message'] ?? '',
      responseCode: json['responseCode'] ?? '',
      errors: json['errors'] != null
          ? List<String>.from(json['errors'])
          : [],
      data: json['data'] != null ? FundWalletData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isSuccessful': isSuccessful,
      'message': message,
      'responseCode': responseCode,
      'errors': errors,
      'data': data?.toJson(),
    };
  }
}

class FundWalletData {
  final String paymentReference;
  final String authorizationUrl;
  final String provider;
  final String accessCode;

  FundWalletData({
    required this.paymentReference,
    required this.authorizationUrl,
    required this.provider,
    required this.accessCode,
  });

  factory FundWalletData.fromJson(Map<String, dynamic> json) {
    return FundWalletData(
      paymentReference: json['paymentReference'] ?? '',
      authorizationUrl: json['authorizationUrl'] ?? '',
      provider: json['provider'] ?? '',
      accessCode: json['accessCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentReference': paymentReference,
      'authorizationUrl': authorizationUrl,
      'provider': provider,
      'accessCode': accessCode,
    };
  }
}
