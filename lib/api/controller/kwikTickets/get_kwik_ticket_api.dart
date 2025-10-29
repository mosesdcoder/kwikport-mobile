import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kwik_port/api/model/dashboard_model.dart';
import 'package:kwik_port/api/model/signupResponse.dart';
import 'package:kwik_port/api/utils/utils.dart';

class GetKwikTicketApi extends ChangeNotifier {
  bool loading = false;
  bool hasMore = true;
  bool loadMore = false;
  // bool _hasMore = true;
  //   bool get hasMore => _hasMore;
  int pageIndex = 1;
  int pageSize = 10;
  String _message = '';
  String get message => _message;
  List<KwikTicketModel> _tickets = [];
  List<KwikTicketModel> get tickets => _tickets;

  fetchKwikTickets({
    int? newPageIndex,
    int? newPageSize,
    bool refresh = false,
  }) async {
    if (loading) return;
    if (!hasMore && loadMore) return;

    loading = true;
    notifyListeners();

    try {
      var result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Refresh handling
        if (refresh) {
          _tickets.clear();
          pageIndex = 1;
          hasMore = true;
        }

        // Use provided values or current ones
        final currentPage = newPageIndex ?? pageIndex;
        final currentSize = newPageSize ?? pageSize;

        final response = await HttpService.getRequest(
          '/KwikTicket/get-kwik-tickets?PageIndex=$currentPage&PageSize=$currentSize',
          // requiresAuth: true,
        );

        debugPrint('📡 Fetching KwikTickets page $currentPage');
        debugPrint('Status: ${response.statusCode}');
        debugPrint('Body: ${response.body}');

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          final apiResponse = ApiResponse.fromJson(
            data,
            // Map<String, dynamic>.from(data),
            (data) => Map<String, dynamic>.from(data),
          );

          if (apiResponse.isSuccessful && apiResponse.data != null) {
            final results = apiResponse.data?["results"];

            if (results is List && results.isNotEmpty) {
              final List<KwikTicketModel> fetched =
                  results
                      .map(
                        (e) => KwikTicketModel.fromJson(
                          Map<String, dynamic>.from(e),
                        ),
                      )
                      .toList();

              _tickets.addAll(fetched);
              pageIndex++;

              _message =
                  apiResponse.message.isNotEmpty
                      ? apiResponse.message
                      : 'Tickets fetched successfully';

              // if (fetched.isNotEmpty) {
              //   _tickets.addAll(fetched);
              //   pageIndex++;
              //   // _hasMore = fetched.length == _pageSize;
              //   _message =
              //       apiResponse.message.isNotEmpty
              //           ? apiResponse.message
              //           : 'Tickets fetched successfully';
              // } else {
              //   hasMore = false;
              //   _message = 'No tickets found';
              // }
            }
          } else {
            debugPrint("⚠️ No data found or request unsuccessful.");
            hasMore = false;
          }
        } else {
          debugPrint("⚠️ Failed with status: ${response.statusCode}");
          hasMore = false;
        }
      }
    } catch (e) {
      debugPrint("❌ Error fetching KwikTickets: $e");
    }

    loading = false;
    notifyListeners();
  }

  void resetTickets() {
    _tickets.clear();
    pageIndex = 1;
    hasMore = true;
    notifyListeners();
  }
}
