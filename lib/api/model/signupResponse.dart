// models/auth_models.dart

class ApiResponse<T> {
  final bool isSuccessful;
  final String message;
  final String? responseCode;
  final List<String> errors;
  final T? data;

  ApiResponse({
    required this.isSuccessful,
    required this.message,
    required this.responseCode,
    required this.errors,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return ApiResponse<T>(
      isSuccessful: json['isSuccessful'] ?? false,
      message: json['message'] ?? '',
      responseCode: json['responseCode'] ?? '',
      errors:
          (json['errors'] as List?)?.map((e) => e.toString()).toList() ?? [],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}

class SignupResponse {
  final bool isSuccessful;
  final String message;
  final String responseCode;
  final List<String>? errors;
  final SignupData? data;

  SignupResponse({
    required this.isSuccessful,
    required this.message,
    required this.responseCode,
    this.errors,
    this.data,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      isSuccessful: json['isSuccessful'] ?? false,
      message: json['message'] ?? '',
      responseCode: json['responseCode'] ?? '',
      errors: json['errors'] != null ? List<String>.from(json['errors']) : null,
      data: json['data'] != null ? SignupData.fromJson(json['data']) : null,
    );
  }
}

class SignupData {
  final String username;
  final String identifier;

  SignupData({required this.username, required this.identifier});

  factory SignupData.fromJson(Map<String, dynamic> json) {
    return SignupData(
      username: json['username'] ?? '',
      identifier: json['identifier'] ?? '',
    );
  }
}

class AuthData {
  final String accessToken;
  final DateTime? accessTokenExpiresAt;
  final String refreshToken;
  final DateTime? refreshTokenExpiresAt;
  final bool mfaEnabled;
  final String? username;
  final String? identifier;

  AuthData({
    required this.accessToken,
    required this.refreshToken,
    this.accessTokenExpiresAt,
    this.refreshTokenExpiresAt,
    this.mfaEnabled = false,
    this.username,
    this.identifier,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      accessTokenExpiresAt:
          json['accessTokenExpiresAt'] != null
              ? DateTime.tryParse(json['accessTokenExpiresAt'])
              : null,
      refreshTokenExpiresAt:
          json['refreshTokenExpiresAt'] != null
              ? DateTime.tryParse(json['refreshTokenExpiresAt'])
              : null,
      mfaEnabled: json['mfaEnabled'] ?? false,
      username: json['username'],
      identifier: json['identifier'],
    );
  }

  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'refreshToken': refreshToken,
    'accessTokenExpiresAt': accessTokenExpiresAt?.toIso8601String(),
    'refreshTokenExpiresAt': refreshTokenExpiresAt?.toIso8601String(),
    'mfaEnabled': mfaEnabled,
    'username': username,
    'identifier': identifier,
  };
}
