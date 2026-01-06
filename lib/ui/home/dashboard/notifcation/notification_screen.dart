import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/services/signalr_service.dart';
import 'package:kwik_port/ui/home/dashboard/notifcation/notification_container.dart';
import 'package:kwik_port/utils/button/bottom_navigatior_bar.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initSignalR();
  }

  Future<void> _initSignalR() async {
    await SignalRService.connect();
    _sub = SignalRService.stream.listen((n) {
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
        if (type == 'exportcomplete' || type == 'stageupdate' || type == 'stageactivated') {
          _exports.insert(0, item);
        } else if (type == 'wallettransaction' || type == 'payment' || type == 'paymentreceived') {
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
    return Scaffold(
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(160.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 10),
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
                      border: Border.all(width: 1.5, color: colorCodes.antiFlashWhite),
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
      body: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18, top: 10, bottom: 70),
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
      bottomNavigationBar: Bottomnavigationbar(1),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.notifications_none, size: 64, color: colorCodes.graniteGrey),
            const SizedBox(height: 12),
            Text(
              'No notifications yet',
              style: kwikTextStlye(16.0, FontWeight.w500, colorCodes.graniteGrey),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: colorCodes.white,
      ),
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: 40),
        separatorBuilder: (_, __) => const SizedBox(height: 15),
        itemCount: items.length,
        itemBuilder: (_, i) {
          final n = items[i];
          return notificationContainer(
            n['status'] ?? 'not',
            n['title'] ?? 'Notification',
            _timeAgo(n['sentAt'] ?? ''),
            n['message'] ?? '',
            '',
            '',
            '',
          );
        },
      ),
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
        indicatorPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
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
          _buildTabWithBadge('Exports', exportNotif),
          _buildTabWithBadge('Transactions', transactionNotif),
          _buildTabWithBadge('System', systemNotif),
        ],
      ),
    );
  }

  Widget _buildTabWithBadge(String label, String count) {
    return Tab(
      child: SizedBox(
        width: 91,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Align(alignment: Alignment.center, child: Text(label)),
            if (count.isNotEmpty && count != '0')
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
                    style: kwikTextStlye(8.0, FontWeight.w700, colorCodes.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
