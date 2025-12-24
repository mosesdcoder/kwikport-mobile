import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kwik_port/api/utils/utils.dart';

class NotificationApi extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  List<dynamic> _notifications = [];
  List<dynamic> get notifications => _notifications;
  int _pageIndex = 1;
  final int _pageSize = 10;
  Future<void> fetchNotifications({bool refresh = false}) async {
    if (_isLoading) return;

    if (refresh) {
      _pageIndex = 1;
      _notifications.clear();
      _hasMore = true;
      _error = null;
    }
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isEmpty || result[0].rawAddress.isEmpty) {
        throw Exception('No internet connection');
      }

      final response = await HttpService.getRequest(
        '/User/user-notification?PageIndex=$_pageIndex&PageSize=$_pageSize',
      );
      final data = json.decode(response.body);
      print('Status: ${response.statusCode}, Body: $data');

      if (response.statusCode == 200 && data['isSuccessful'] == true) {
        final results = data['data'] as List?;
        // if (jsonData['isSuccessful'] == true && jsonData['data'] != null) {
        //   // Assuming data is a list of notifications
        //   _notifications = List<dynamic>.from(jsonData['data']);
        // } else {
        //   _error = jsonData['message'] ?? 'No notifications found';
        // }
        if (results != null && results.isNotEmpty) {
          _notifications.addAll(
            results.map((n) => n as Map<String, dynamic>).toList(),
          );
          _pageIndex++;
          _hasMore = results.length == _pageSize;
        } else {
          _hasMore = false;
        }
      } else {
        _error = 'Failed to fetch notifications: ${response.statusCode}';
      }
    } catch (e, st) {
      print('Notification fetch error: $e\n$st');
      _error = 'Error fetching notifications';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Manual refresh (pull-to-refresh)
  Future<void> refreshNotifications() async {
    await fetchNotifications(refresh: true);
  }

  /// Filter notifications by type
  List<Map<String, dynamic>> getNotificationsByType(String type) {
    return _notifications
        .where((n) => n['notificationType'] == type)
        .map((e) => e as Map<String, dynamic>)
        .toList();
  }

  /// Optional: count of notifications by type
  int countByType(String type) {
    return _notifications.where((n) => n['notificationType'] == type).length;
  }
}
