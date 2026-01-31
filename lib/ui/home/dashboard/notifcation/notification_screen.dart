import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kwik_port/api/controller/home/notification_api.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/services/signalr_service.dart';
import 'package:kwik_port/utils/button/bottom_navigatior_bar.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:provider/provider.dart';
import 'package:swipe_refresh/swipe_refresh.dart';
import 'package:kwik_port/api/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  StreamSubscription<Map<String, dynamic>>? _sub;

  final List<Map<String, dynamic>> _all = [];
  final List<Map<String, dynamic>> _exports = [];
  final List<Map<String, dynamic>> _transactions = [];
  final List<Map<String, dynamic>> _system = [];

  bool newNotification = false;
  final Set<String> _readIds = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initReadIds();
    _initSignalR();
    _fetchNotifications();
  }

  Future<void> _initReadIds() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _readIds.addAll(prefs.getStringList('read_notification_ids') ?? []);
    });
  }

  Future<void> _initSignalR() async {
    await SignalRService.connect();
    _sub = SignalRService.stream.listen((n) {
      _fetchNotifications();
      final type = (n['type'] ?? '').toString().toLowerCase();
      final item = {
        'title': n['title'] ?? 'Notification',
        'message': n['message'] ?? '',
        'sentAt': n['sentAt'] ?? '',
        'status': 'not',
        'type': type,
      };

      setState(() {
        _all.insert(0, item);
        if (type == 'exportcomplete' ||
            type == 'stageupdate' ||
            type == 'stageactivated') {
          _exports.insert(0, item);
        } else if (type == 'wallettransaction' ||
            type == 'payment' ||
            type == 'paymentreceived') {
          _transactions.insert(0, item);
        } else {
          _system.insert(0, item);
        }
        newNotification = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item['title']}: ${item['message']}'),
            duration: const Duration(seconds: 3),
            backgroundColor: colorCodes.azureBlue,
          ),
        );
      }
    });
  }

  Future<void> _fetchNotifications() async {
    try {
      final response = await HttpService.getRequest('/User/user-notification');
      final Map<String, dynamic> data = json.decode(response.body);
      final results =
          (data['data']?['results'] is List)
              ? data['data']['results'] as List
              : <dynamic>[];
      setState(() {
        _all.clear();
        _exports.clear();
        _transactions.clear();
        _system.clear();
        for (final n in results) {
          final type = (n['notificationType'] ?? '').toString();
          final mappedType =
              type == 'StageUpdate'
                  ? 'exports'
                  : type == 'Payment'
                  ? 'transactions'
                  : 'system';
          final id = (n['id'] ?? n['notificationId'] ?? '').toString();
          final item = {
            'id': id,
            'title': n['subject'] ?? 'Notification',
            'message': n['message'] ?? '',
            'sentAt': n['sentAt'] ?? '',
            'status':
                (() {
                  final s = (n['status'] ?? '').toString().toLowerCase();
                  if (id.isNotEmpty && _readIds.contains(id)) return 'read';
                  return s == 'sent' ? 'not' : 'read';
                })(),
            'type': mappedType,
          };
          _all.add(item);
          if (mappedType == 'exports') {
            _exports.add(item);
          } else if (mappedType == 'transactions') {
            _transactions.add(item);
          } else {
            _system.add(item);
          }
        }
      });
    } catch (e) {
      // Error handling
    }
  }

  Future<void> _markAsRead(Map<String, dynamic> notification) async {
    final id = (notification['id'] ?? '').toString();
    setState(() {
      notification['status'] = 'read';
      if (id.isNotEmpty) {
        _readIds.add(id);
      }
      newNotification = false;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('read_notification_ids', _readIds.toList());

    if (id.isNotEmpty) {
      try {
        await HttpService.postRequest('/User/notification/read', {'id': id});
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    SignalRService.disconnect();
    _tabController.dispose();
    super.dispose();
  }

  String get _exportCount =>
      _exports.where((n) => n['status'] == 'not').length.toString();
  String get _transactionCount =>
      _transactions.where((n) => n['status'] == 'not').length.toString();
  String get _systemCount =>
      _system.where((n) => n['status'] == 'not').length.toString();

  void _showNotificationOverlay(Map<String, dynamic> notification) {
    _markAsRead(notification);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _NotificationOverlay(notification: notification),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notificationApi = Provider.of<NotificationApi>(context);

    final exportCount = notificationApi.countByType("Export").toString();
    final transactionCount =
        notificationApi.countByType("Transaction").toString();
    final systemCount = notificationApi.countByType("System").toString();
    return Scaffold(
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(160.0),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 50,
            bottom: 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Image.asset(
                      'assets/images/icons/button back.png',
                      height: 48,
                      width: 48,
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      'Notifications',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                      ).copyWith(color: colorCodes.black),
                    ),
                  ),
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: colorCodes.white,
                      border: Border.all(
                        width: 1.5,
                        color: colorCodes.antiFlashWhite,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/images/icons/notification.png',
                          color: colorCodes.black,
                          height: 24,
                          width: 24,
                        ),
                        if (newNotification)
                          Positioned(
                            top: 12,
                            right: 15,
                            child: CircleAvatar(
                              radius: 3.0,
                              backgroundColor: colorCodes.portlandOrange,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 17),
              _notificationTabBar(
                _tabController,
                _exportCount,
                _transactionCount,
                _systemCount,
                (index) {
                  setState(() {
                    newNotification = false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: colorCodes.whiteSmoke,
      body: RefreshIndicator(
        onRefresh: _fetchNotifications,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 18,
            right: 18,
            top: 10,
            bottom: 70,
          ),
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildList(_all),
              _buildList(_exports),
              _buildList(_transactions),
              _buildList(_system),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Bottomnavigationbar(1),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: colorCodes.graniteGrey,
            ),
            const SizedBox(height: 12),
            Text(
              'No notifications yet',
              style: kwikTextStlye(
                16.0,
                FontWeight.w500,
                colorCodes.graniteGrey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 40),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final n = items[i];
        return _NotificationCard(
          notification: n,
          onTap: () => _showNotificationOverlay(n),
        );
      },
    );
  }

  Widget _notificationTabBar(
    TabController controller,
    String exportNotif,
    String transactionNotif,
    String systemNotif,
    Function(int) onTap,
  ) {
    return Container(
      height: 58,
      width: 395,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      decoration: BoxDecoration(
        color: colorCodes.white,
        borderRadius: BorderRadius.circular(100),
      ),
      child: TabBar(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        labelPadding: const EdgeInsets.symmetric(horizontal: 1),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: colorCodes.white,
        labelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
        ),
        unselectedLabelColor: colorCodes.black,
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
        ),
        indicatorPadding: const EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 5,
        ),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: colorCodes.frenchSkyBlue),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              colorCodes.jordyBlue,
              colorCodes.azureBlue,
              colorCodes.azureBlue,
            ],
          ),
          color: colorCodes.white,
        ),
        controller: controller,
        tabs: [
          const Tab(text: 'All'),
          _buildTabWithBadge('Exports', exportNotif, newNotification),
          _buildTabWithBadge('Transactions', transactionNotif, newNotification),
          _buildTabWithBadge('System', systemNotif, newNotification),
        ],
      ),
    );
  }

  Widget _buildTabWithBadge(String label, String count, bool showBadge) {
    return Tab(
      child: SizedBox(
        width: 91,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Align(alignment: Alignment.center, child: Text(label)),
            if (showBadge && count.isNotEmpty && count != '0')
              Positioned(
                top: 5,
                right: 6,
                child: Container(
                  height: 14,
                  width: 15,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colorCodes.portlandOrange,
                    borderRadius: BorderRadius.circular(600),
                  ),
                  child: Text(
                    count,
                    style: kwikTextStlye(
                      8.0,
                      FontWeight.w700,
                      colorCodes.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final Map<String, dynamic> notification;
  final VoidCallback onTap;

  const _NotificationCard({required this.notification, required this.onTap});

  String _timeAgo(String sentAt) {
    try {
      final dt = DateTime.parse(sentAt).toLocal();
      final diff = DateTime.now().difference(dt);
      if (diff.inDays > 0) return '${diff.inDays}d ago';
      if (diff.inHours > 0) return '${diff.inHours}h ago';
      if (diff.inMinutes > 0) return '${diff.inMinutes}min ago';
      return 'Just now';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUnread = notification['status'] == 'not';

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colorCodes.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isUnread ? colorCodes.frenchSkyBlue : colorCodes.antiFlashWhite,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    notification['title'] ?? 'Notification',
                    style: kwikTextStlye(
                      14.0,
                      isUnread ? FontWeight.w600 : FontWeight.w500,
                      colorCodes.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isUnread)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: CircleAvatar(
                      radius: 4,
                      backgroundColor: colorCodes.portlandOrange,
                    ),
                  ),
              ],
            ),
            Text(
              notification['message'] ?? '',
              style: kwikTextStlye(
                12.0,
                FontWeight.w400,
                colorCodes.graniteGrey,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              _timeAgo(notification['sentAt'] ?? ''),
              style: kwikTextStlye(
                11.0,
                FontWeight.w400,
                colorCodes.graniteGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationOverlay extends StatelessWidget {
  final Map<String, dynamic> notification;

  const _NotificationOverlay({required this.notification});

  String _timeAgo(String sentAt) {
    try {
      final dt = DateTime.parse(sentAt).toLocal();
      final diff = DateTime.now().difference(dt);
      if (diff.inDays > 0) return '${diff.inDays} days ago';
      if (diff.inHours > 0) return '${diff.inHours} hours ago';
      if (diff.inMinutes > 0) return '${diff.inMinutes} minutes ago';
      return 'Just now';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder:
          (context, scrollController) => Container(
            decoration: BoxDecoration(
              color: colorCodes.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        height: 4,
                        width: 40,
                        decoration: BoxDecoration(
                          color: colorCodes.antiFlashWhite,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      notification['title'] ?? 'Notification',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ).copyWith(color: colorCodes.black),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _timeAgo(notification['sentAt'] ?? ''),
                      style: kwikTextStlye(
                        12.0,
                        FontWeight.w400,
                        colorCodes.graniteGrey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorCodes.whiteSmoke,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colorCodes.antiFlashWhite),
                      ),
                      child: Text(
                        notification['message'] ?? '',
                        style: kwikTextStlye(
                          14.0,
                          FontWeight.w400,
                          colorCodes.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorCodes.azureBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Close',
                          style: kwikTextStlye(
                            14.0,
                            FontWeight.w600,
                            colorCodes.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
