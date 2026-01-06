import 'package:kwik_port/api/model/contract_data_response.dart';

class RequestContractResponse {
  final bool isSuccessful;
  final String message;
  final String responseCode;
  final List<dynamic> errors;
  final ContractDataResponse data;

  RequestContractResponse({
    required this.isSuccessful,
    required this.message,
    required this.responseCode,
    required this.errors,
    required this.data,
  });

  factory RequestContractResponse.fromJson(Map<String, dynamic> json) {
    return RequestContractResponse(
      isSuccessful: json['isSuccessful'],
      message: json['message'],
      responseCode: json['responseCode'],
      errors: json['errors'],
      data: ContractDataResponse.fromJson(json['data']),
    );
  }
}
