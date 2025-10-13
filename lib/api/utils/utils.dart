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

const String baseUrl = 'http://api-user.kwikports.com/v1';

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
    // static Future<AuthData?> _refreshToken() async {
    if (_refreshCompleter != null) {
      // Wait for the ongoing refresh to complete
      return _refreshCompleter!.future;
    }

    // Lock the refresh process
    _refreshCompleter = Completer();

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final refreshToken = await getRefreshTokenFromLogin();
      if (refreshToken == null) {
        throw Exception('Refresh token not found');
      }

      final url = Uri.parse('$baseUrl/refresh-token');
      final response = await http.post(
        url,
        body: json.encode({'refreshToken': refreshToken}),
        headers: {'Content-Type': 'application/json'},
      );

      printRequestInfo('POST', url, response.statusCode, response.body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final newTokens = {
          'accessToken': data['data']['accessToken'],
          'refreshToken': data['data']['refreshToken'],
        };
        // Update tokens in user data
        /// Save back into SharedPreferences
        final String? userModelPref = prefs.getString('userModelData');
        if (userModelPref != null) {
          Map<String, dynamic> userData = json.decode(userModelPref);
          userData['token'] = newTokens['accessToken'];
          userData['refreshToken'] = newTokens['refreshToken'];
          userData['accessTokenExpiresAt'] =
              data['data']['accessTokenExpiresAt'];
          userData['refreshTokenExpiresAt'] =
              data['data']['refreshTokenExpiresAt'];
          await prefs.setString('userModelData', json.encode(userData));
        }

        _refreshCompleter?.complete({
          // 'accessToken': data['accessToken'],
          // 'refreshToken': data['refreshToken'],
          'accessToken': data['data']['accessToken'],
          'refreshToken': data['data']['refreshToken'],
        });

        return {
          // 'accessToken': data['accessToken'],
          // 'refreshToken': data['refreshToken'],
          'accessToken': data['data']['accessToken'],
          'refreshToken': data['data']['refreshToken'],
        };
      } else {
        // Handle refresh token failure
        _refreshCompleter?.complete(null);
        _refreshCompleter = null;

        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );

        final context = navigatorKey.currentState?.overlay?.context;
        if (context != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Session Ended"),
              backgroundColor: Colors.red,
            ),
          );
        }

        throw Exception('Failed to refresh token: ${response.body}');
      }
    } catch (e) {
      _refreshCompleter?.completeError(e);
      rethrow;
    } finally {
      // Clear the lock
      _refreshCompleter = null;
    }
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
