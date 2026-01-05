import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:kwik_port/api/model/signupResponse.dart';
import 'package:kwik_port/api/model/userModel.dart';
import 'package:kwik_port/main.dart';
import 'package:kwik_port/ui/onboarding/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = 'https://api-user.kwikports.com/v1';
// const String baseUrl = 'https://localhost:7235/v1';

// http://api-user.kwikports.com/swagger/index.html
class HttpService {
  static Completer<Map<String, String>?>? _refreshCompleter; // Lock mechanism

  static Future<http.Response> _sendRequest(
    String method,
    String path,
    dynamic body, {
    bool requiresAuth = true,
    bool retryOn403 = true,
    bool retryOn401 = true,
    Map<String, String>? additionalHeaders,
  }) async {
    Uri url = Uri.parse('$baseUrl$path');
    Map<String, String> headers = {'Content-Type': 'application/json'};
    if (requiresAuth) {
      final accessToken = await getAccessTokenFromLogin();
      if (accessToken == null) {
        throw Exception('Access token not found');
      }
      headers['Authorization'] = 'Bearer $accessToken';
    }
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }
    final encodedBody = body != null ? json.encode(body) : null;

    http.Response response;
    switch (method) {
      case 'GET':
        response = await http.get(url, headers: headers);
        break;
      case 'POST':
        response = await http.post(url, body: encodedBody, headers: headers);
        break;
      case 'PATCH':
        response = await http.patch(url, body: encodedBody, headers: headers);
        break;
      case 'PUT':
        response = await http.put(url, body: encodedBody, headers: headers);
        break;
      case 'DELETE':
        response = await http.delete(url, body: encodedBody, headers: headers);
        break;
      default:
        throw Exception('Unsupported method');
    }

    printRequestInfo(method, url, response.statusCode, response.body);
    // Refresh flow on 403
    if (response.statusCode == 403 && retryOn403) {
      print("About to refresh token");
      // Token expired, refresh it and retry the request
      final newTokens = await _refreshToken();
      print(newTokens);

      if (newTokens != null) {
        headers['Authorization'] = 'Bearer ${newTokens['accessToken']}';
        switch (method) {
          case 'GET':
            response = await http.get(url, headers: headers);
            break;
          case 'POST':
            response = await http.post(
              url,
              body: encodedBody,
              headers: headers,
            );
            break;
          case 'PATCH':
            response = await http.patch(
              url,
              body: encodedBody,
              headers: headers,
            );
            break;
          case 'PUT':
            response = await http.put(url, body: encodedBody, headers: headers);
            break;
          case 'DELETE':
            response = await http.delete(
              url,
              body: encodedBody,
              headers: headers,
            );
            break;
        }
        printRequestInfo(method, url, response.statusCode, response.body);
      } else {
        throw Exception('Failed to refresh token');
      }
    }
    if (response.statusCode == 401 && retryOn401) {
      print("About to refresh token");
      // Token expired, refresh it and retry the request
      final newTokens = await _refreshToken();
      // final newAuthData = await _refreshToken();
      print(newTokens);

      if (newTokens != null) {
        // Update access token and retry
        // await updateAccessToken(
        // newTokens
        // newTokens['accessToken']!,
        // newTokens['refreshToken']!,
        // );
        // await updateAccessToken(newAuthData);
        headers['Authorization'] = 'Bearer ${newTokens['accessToken']}';
        switch (method) {
          case 'GET':
            response = await http.get(url, headers: headers);
            break;
          case 'POST':
            response = await http.post(
              url,
              body: encodedBody,
              headers: headers,
            );
            break;
          case 'PATCH':
            response = await http.patch(
              url,
              body: encodedBody,
              headers: headers,
            );
            break;
          case 'PUT':
            response = await http.put(url, body: encodedBody, headers: headers);
            break;
          case 'DELETE':
            response = await http.delete(
              url,
              body: encodedBody,
              headers: headers,
            );
            break;
        }
        printRequestInfo(method, url, response.statusCode, response.body);
      } else {
        throw Exception('Failed to refresh token');
      }
    }

    return response;
  }

  /// ========== TOKEN REFRESH ==========

  static Future<Map<String, String>?> _refreshToken() async {
    if (_refreshCompleter != null) {
      // Wait for ongoing refresh to complete
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer();

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refreshToken');
      final accessToken = prefs.getString('accessToken');

      if (refreshToken == null || accessToken == null) {
        debugPrint('⚠️ No valid tokens found — user must log in again.');
        _redirectToLogin();
        _refreshCompleter?.complete(null);
        return null;
      }

      final url = Uri.parse('$baseUrl/Access/refresh-token');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'token': accessToken, 'refreshToken': refreshToken}),
      );

      printRequestInfo('POST', url, response.statusCode, response.body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['isSuccessful'] == true && data['data'] != null) {
          final newTokens = {
            'accessToken': data['data']['accessToken'].toString(),
            'refreshToken': data['data']['refreshToken'].toString(),
          };

          // Save the new tokens locally
          await prefs.setString('accessToken', newTokens['accessToken']!);
          await prefs.setString('refreshToken', newTokens['refreshToken']!);

          // If you store userModelData, update it too
          final String? userModelPref = prefs.getString('userModelData');
          if (userModelPref != null) {
            Map<String, dynamic> userData = json.decode(userModelPref);
            userData['token'] = newTokens['accessToken'];
            userData['refreshToken'] = newTokens['refreshToken'];
            await prefs.setString('userModelData', json.encode(userData));
          }

          debugPrint('✅ Token refresh successful');
          _refreshCompleter?.complete(newTokens);
          return newTokens;
        } else {
          debugPrint('❌ Refresh failed: ${data['message']}');
          _redirectToLogin();
          _refreshCompleter?.complete(null);
          return null;
        }
      } else {
        debugPrint('❌ Refresh request failed: ${response.statusCode}');
        _redirectToLogin();
        _refreshCompleter?.complete(null);
        return null;
      }
    } catch (e) {
      debugPrint('❌ Exception during refresh: $e');
      _refreshCompleter?.completeError(e);
      _redirectToLogin();
      rethrow;
    } finally {
      _refreshCompleter = null;
    }
  }

  static void _redirectToLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    final context = navigatorKey.currentState?.overlay?.context;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Session expired, please log in again."),
          backgroundColor: Colors.red,
        ),
      );
    }

    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  static Future<void> updateAccessToken(AuthData authData) async {
    final prefs = await SharedPreferences.getInstance();

    // Save all relevant fields
    await prefs.setString('accessToken', authData.accessToken);
    await prefs.setString('refreshToken', authData.refreshToken);
    await prefs.setString(
      'accessTokenExpiresAt',
      authData.accessTokenExpiresAt?.toIso8601String() ?? '',
    );
    await prefs.setString(
      'refreshTokenExpiresAt',
      authData.refreshTokenExpiresAt?.toIso8601String() ?? '',
    );
    await prefs.setString('username', authData.username ?? '');
    await prefs.setString('identifier', authData.identifier ?? '');
  }

  static Future<String?> getAccessTokenFromLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  static Future<String?> getRefreshTokenFromLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  static Future<http.Response> getRequest(
    String path, [
    void Function(Map<String, dynamic>, {String? type})? updateData,
  ]) async {
    return await _sendRequest('GET', path, null, requiresAuth: true);
  }

  static Future<http.StreamedResponse> postMultipartRequest(
    String path,
    File image,
  ) async {
    final url = Uri.parse('$baseUrl$path');
    final accessToken = await getAccessTokenFromLogin();
    if (accessToken == null) {
      throw Exception('Access token not found');
    }

    final request =
        http.MultipartRequest('POST', url)
          ..headers['Authorization'] = 'Bearer $accessToken'
          ..headers['Content-Type'] = 'multipart/form-data'
          ..files.add(
            await http.MultipartFile.fromPath(
              'displayPicture',
              image.path,
              filename: 'displayPicture',
              contentType: MediaType('image', 'jpg'),
            ),
          );

    return await request.send();
  }

  static Future<http.StreamedResponse> postMultipartRequestWithFormData(
    String path,
    File media,
    Map<String, String> formData,
    String mediaType,
  ) async {
    final url = Uri.parse('$baseUrl$path');
    final accessToken = await getAccessTokenFromLogin();

    if (accessToken == null) {
      throw Exception('Access token not found');
    }

    // Determine the correct MIME type based on the mediaType
    String mimeType;
    if (mediaType == 'video') {
      mimeType = 'video/mp4';
    } else if (mediaType == 'image') {
      mimeType = 'image/jpeg';
    } else {
      throw Exception('Unsupported media type');
    }

    final request =
        http.MultipartRequest('POST', url)
          ..headers['Authorization'] = 'Bearer $accessToken'
          ..headers['Content-Type'] = 'multipart/form-data'
          ..files.add(
            await http.MultipartFile.fromPath(
              'media',
              media.path,
              contentType: MediaType.parse(mimeType),
            ),
          );

    formData.forEach((key, value) {
      request.fields[key] = value;
    });

    return await request.send();
  }

  static Future<http.Response> deleteRequest(
    String path,
    body,
    BuildContext context,
  ) async {
    return await _sendRequest('DELETE', path, body);
  }

  static Future<http.Response> deleteRequestWithoutBody(String path) async {
    return await _sendRequest('DELETE', path, null);
  }

  static Future<http.Response> getRequestNoAuth(String path) async {
    return await _sendRequest('GET', path, null, requiresAuth: false);
  }

  static Future<http.Response> loginPostRequest(
    String path,
    dynamic body,
  ) async {
    return await _sendRequest('POST', path, body, requiresAuth: false);
  }

  static Future<http.Response> postRequestNoAuth(
    String path,
    dynamic body,
  ) async {
    return await _sendRequest('POST', path, body, requiresAuth: false);
  }

  static Future<http.Response> postRequest(String path, dynamic body) async {
    return await _sendRequest('POST', path, body);
  }

  static Future<http.Response> patchRequest(String path, dynamic body) async {
    return await _sendRequest('PATCH', path, body);
  }

  static Future<http.Response> registerPostRequest(
    String path,
    dynamic body,
  ) async {
    return await _sendRequest('POST', path, body, requiresAuth: false);
  }

  static Future<http.Response> putRequest(String path, dynamic body) async {
    return await _sendRequest('PUT', path, body);
  }

  static void printRequestInfo(
    String method,
    Uri url,
    int statusCode,
    String responseBody,
  ) {
    print('Request Info:');
    print('Method: $method');
    print('URL: $url');
    print('Status Code: $statusCode');
    print('Response Body: $responseBody');
  }
}
