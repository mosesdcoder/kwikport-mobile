import 'dart:convert';

import 'package:kwik_port/api/model/contractModel.dart';
import 'package:kwik_port/api/model/signupResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

// models/user_session.dart (global session + convenience)
UserSession? userDataVar; // global
// var userDataVar = UserSession.fromJson(json as Map<String, dynamic>);
// var userDataVar = UserSession.fromJson(json as Map<String, dynamic>);

class UserSession {
  AuthData? auth;
  String? firstName;
  String? lastName;
  String? otherNames;
  String? email;
  String? phoneNumber;
  String? image;
  ExporterModel? exporter;
  // List<ContractModel>? contracts;

  UserSession({
    this.auth,
    this.firstName,
    this.lastName,
    this.otherNames,
    this.email,
    this.phoneNumber,
    this.image,
    this.exporter,
    // this.contracts,
  });

  Map<String, dynamic> toJson() => {
    'auth': auth?.toJson(),
    'firstName': firstName,
    'lastName': lastName,
    'otherNames': otherNames,
    'email': email,
    'phoneNumber': phoneNumber,
    'image': image,
    'exporter': exporter?.toJson(),
    // 'contracts': contracts?.map((c) => c.toJson()).toList(),
  };

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      auth: json['auth'] != null ? AuthData.fromJson(json['auth']) : null,
      firstName: json['firstName'],
      lastName: json['lastName'],
      otherNames: json['otherNames'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      exporter:
          json['exporter'] != null
              ? ExporterModel.fromJson(json['exporter'])
              : null,
      // contracts:
      //     json['contracts'] != null
      //         ? (json['contracts'] as List)
      //             .map((c) => ContractModel.fromJson(c))
      //             .toList()
      //         : null,
    );
  }
  UserSession copyWith({
    AuthData? auth,
    String? firstName,
    String? lastName,
    String? otherNames,
    String? email,
    String? phoneNumber,
    String? image,
    ExporterModel? exporter,
  }) {
    return UserSession(
      auth: auth ?? this.auth,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      otherNames: otherNames ?? this.otherNames,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      image: image ?? this.image,
      exporter: exporter ?? this.exporter,
    );
  }
}

// models/exporter_model.dart
class ExporterModel {
  final String id;
  final String exporterUniqueId;
  final String businessName;
  final String businessEmail;
  final String userId;
  final String logoUrl;
  final bool bvnVerified;
  final String city;
  final String country;
  final String state;
  final int approvalStatus;
  final String? approvalMessage;
  final String? createdBy;
  final String? createdByIp;
  final DateTime? createdDate;
  final String? modifiedBy;
  final String? modifiedByIp;
  final DateTime? modifiedDate;
  final bool isDeleted;

  ExporterModel({
    required this.id,
    required this.exporterUniqueId,
    required this.businessName,
    required this.businessEmail,
    required this.userId,
    required this.logoUrl,
    required this.bvnVerified,
    required this.city,
    required this.country,
    required this.state,
    required this.approvalStatus,
    this.approvalMessage,
    this.createdBy,
    this.createdByIp,
    this.createdDate,
    this.modifiedBy,
    this.modifiedByIp,
    this.modifiedDate,
    required this.isDeleted,
  });

  factory ExporterModel.fromJson(Map<String, dynamic> json) {
    return ExporterModel(
      id: json['id'] ?? '',
      exporterUniqueId: json['exporterUniqueId'] ?? '',
      businessName: json['businessName'] ?? '',
      businessEmail: json['businessEmail'] ?? '',
      userId: json['userId'] ?? '',
      logoUrl: json['logoUrl'] ?? '',
      bvnVerified: json['bvnVerified'] ?? false,
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      approvalStatus: json['approvalStatus'] ?? 0,
      approvalMessage: json['approvalMessage'],
      createdBy: json['createdBy'],
      createdByIp: json['createdByIp'],
      createdDate:
          json['createdDate'] != null
              ? DateTime.tryParse(json['createdDate'])
              : null,
      modifiedBy: json['modifiedBy'],
      modifiedByIp: json['modifiedByIp'],
      modifiedDate:
          json['modifiedDate'] != null
              ? DateTime.tryParse(json['modifiedDate'])
              : null,
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'exporterUniqueId': exporterUniqueId,
    'businessName': businessName,
    'businessEmail': businessEmail,
    'userId': userId,
    'logoUrl': logoUrl,
    'bvnVerified': bvnVerified,
    'city': city,
    'country': country,
    'state': state,
    'approvalStatus': approvalStatus,
    'approvalMessage': approvalMessage,
    'createdBy': createdBy,
    'createdByIp': createdByIp,
    'createdDate': createdDate?.toIso8601String(),
    'modifiedBy': modifiedBy,
    'modifiedByIp': modifiedByIp,
    'modifiedDate': modifiedDate?.toIso8601String(),
    'isDeleted': isDeleted,
  };
}

Future<void> saveAuthDataToPrefs(AuthData auth) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('authData', jsonEncode(auth.toJson()));
  await prefs.setString('accessToken', auth.accessToken);
  await prefs.setString('refreshToken', auth.refreshToken);

  if (auth.accessTokenExpiresAt != null) {
    await prefs.setString(
      'accessTokenExpiresAt',
      auth.accessTokenExpiresAt!.toIso8601String(),
    );
  }

  if (auth.refreshTokenExpiresAt != null) {
    await prefs.setString(
      'refreshTokenExpiresAt',
      auth.refreshTokenExpiresAt!.toIso8601String(),
    );
  }
}

Future<AuthData?> loadAuthDataFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonStr = prefs.getString('authData');
  if (jsonStr == null) return null;
  return AuthData.fromJson(json.decode(jsonStr));
}

// ---------------------------------------------------------
// 💾 SESSION MANAGEMENT
// ---------------------------------------------------------

Future<void> saveUserSession(UserSession session) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userSession', jsonEncode(session.toJson()));
  userDataVar = session; // instantly available globally
}

Future<UserSession?> loadUserSessionFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonStr = prefs.getString('userSession');
  if (jsonStr != null) {
    return userDataVar = UserSession.fromJson(jsonDecode(jsonStr));
  } else {
    return userDataVar = UserSession();
  }
}

/// Call once in main() → ensures userDataVar is initialized
Future<void> initUserSession() async {
  userDataVar = await loadUserSessionFromPrefs();
}

Future<void> updateUserSession({
  AuthData? auth,
  String? firstName,
  String? lastName,
  String? otherNames,
  String? email,
  String? phoneNumber,
  ExporterModel? exporter,
  // AuthData? auth,
  // ExporterModel? exporter,
  // String? firstName,
  // String? email,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final existing = userDataVar ?? UserSession();

  // final existing = await loadUserSessionFromPrefs();
  final updated = UserSession(
    auth: auth ?? existing.auth,
    firstName: firstName ?? existing.firstName,
    lastName: lastName ?? existing.lastName,
    otherNames: otherNames ?? existing.otherNames,
    email: email ?? existing.email,
    phoneNumber: phoneNumber ?? existing.phoneNumber,
    exporter: exporter ?? existing.exporter,
  );

  await prefs.setString('userSession', jsonEncode(updated.toJson()));
  userDataVar = updated;
  // await saveUserSession(updatedSession);
}

Future<void> clearUserSession() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('userSession');
  userDataVar = null;
}

/// ✅ Save everything after successful login
Future<void> saveFullUserSession({
  required AuthData auth,
  required String? firstName,
  required String? lastName,
  required String? otherNames,
  required String? email,
  required String? phoneNumber,
  required ExporterModel? exporter,
}) async {
  final session = UserSession(
    auth: auth,
    firstName: firstName,
    lastName: lastName,
    otherNames: otherNames,
    email: email,
    phoneNumber: phoneNumber,
    exporter: exporter,
  );

  await saveAuthDataToPrefs(auth);
  await saveUserSession(session);
  userDataVar = session;

  print('✅ Full user session saved: ${exporter?.exporterUniqueId}');
}
