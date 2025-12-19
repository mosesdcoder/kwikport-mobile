import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:kwik_port/api/controller/home/dashboard_api.dart';
import 'package:kwik_port/api/model/userModel.dart';
import 'package:kwik_port/api/model/dashboard_model.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/main.dart';
import 'package:kwik_port/ui/home/dashboard/name_and_notif_headng.dart';
import 'package:kwik_port/ui/home/dashboard/notifcation/notification_screen.dart';
import 'package:kwik_port/ui/home/dashboard/wallet_balance_container.dart';
import 'package:kwik_port/ui/home/exportfulfillment/KycVerification/kyc_verification_screen.dart';
import 'package:kwik_port/ui/home/wallet/fund_wallet_bottomsheet.dart';
import 'package:kwik_port/ui/home/wallet/fund_wallet_screen.dart';
import 'package:kwik_port/ui/home/wallet/wallet_balance_container.dart';
import 'package:kwik_port/ui/home/wallet/wallet_transaction_history.dart';
import 'package:kwik_port/utils/button/bottom_navigatior_bar.dart';
import 'package:provider/provider.dart';
import 'package:swipe_refresh/swipe_refresh.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool notificationExist = true;
  int itemCount = 3;
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  bool showKwikwalletBalance = false;
  bool showKwikexportBalance = false;

  final _controller = StreamController<SwipeRefreshState>.broadcast();
  Stream<SwipeRefreshState> get _stream => _controller.stream;
  Future<void> _refresh() async {
    final api = Provider.of<DashboardApi>(context, listen: false);
    await api.fetchDashboard();
    _controller.sink.add(SwipeRefreshState.hidden);
    // _controller.sink.add(SwipeRefreshState.hidden);
  }

  @override
  void initState() {
    super.initState();
    currentIndex = 4;
    notificationExist;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<DashboardApi>(context, listen: false).fetchDashboard();

      isLoading = true;
    });
    // _scrollController.addListener(_scrollListener);
  }

  int currentPage = 0;

  PageController _pageController = new PageController(
    initialPage: 0,
    // keepPage: true,
  );

  @override
  Widget build(BuildContext context) {
    final dashboardApi = Provider.of<DashboardApi>(context);
    final walletBalance = dashboardApi.data?.walletBalance ?? 0.0;
    final exportWalletBalance =
        dashboardApi.data?.totalExportContractBalance ?? 0.0;

    final user = dashboardApi.data?.userProfile;
    return Scaffold(
      extendBody: true,
      backgroundColor: colorCodes.whiteSmoke,
      body: SwipeRefresh.adaptive(
        // physics: NeverScrollableScrollPhysics(),
        stateStream: _stream,
        onRefresh: _refresh,
        children: [
          ListView(
            shrinkWrap: true,
            physics: RangeMaintainingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 50.0),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  nameAndNotifHeading2(
                    context,
                    user != null
                        ? "${user.firstName.toUpperCase()} ${user.lastName.toUpperCase()}"
                        : "User",
                    notificationExist,
                    notificationFunc,
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    height: 210, // * itemCount.toDouble(),
                    child: PageView(
                      controller: _pageController,
                      scrollDirection: Axis.horizontal,
                      // itemCount: 2,
                      // itemBuilder: (BuildContext context, int position) {
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: walletBalanceContainer(
                            showKwikwalletBalance == true
                                ? "\#${NumberFormat('#,##0.00').format(walletBalance)}"
                                : "••••••••",

                            "Kwik Balance",
                            colorCodes.eigengrau,
                            colorCodes.eigengrau,
                            HexColor("#061042"),
                            "assets/images/icons/dashboard/Union.png",
                            "2mins ago",
                            "${userDataVar?.exporter?.exporterUniqueId}",
                            // "******KWP-2024-001",
                            showKwikwalletBalance,
                            () {
                              setState(() {
                                showKwikwalletBalance = !showKwikwalletBalance;
                              });
                            },
                          ),
                        ),
                        walletBalanceContainer(
                          "\$${NumberFormat('#,##0.00').format(exportWalletBalance)}",
                          "Export Wallet",
                          colorCodes.blackPurple,
                          colorCodes.blackPurple,
                          colorCodes.eggPlantPurple,
                          "assets/images/icons/dashboard/Union (1).png",
                          "2mins ago",
                          "${userDataVar?.exporter?.exporterUniqueId}",
                          showKwikexportBalance,
                          () {},
                        ),
                      ],
                      // },
                      onPageChanged: (value) => {setCurrentPage(value)},
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: List.generate(2, (index) => getIndicator(index)),
                  ),
                  SizedBox(height: 19),
                  Container(
                    height: 94,
                    width: 390,
                    // padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: colorCodes.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        quickActionsContainer(
                          "assets/images/icons/add_funds.png",
                          "Add Funds",
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FundWalletScreen(),
                              ),
                            );
                          },
                          width: 70.0,
                        ),
                        quickActionsContainer(
                          "assets/images/icons/withdrawal.png",
                          "Withdrawal",
                          () {
                            KwikTicketModel kwikticket = KwikTicketModel(
                              id: "id",
                              uniqueId: "uniqueId",
                              kwikTicketAmount: 2000,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => KycVerificationScreen(
                                      kwikticket: kwikticket,
                                    ),
                              ),
                            );
                          },
                          width: 72.0,
                        ),
                        quickActionsContainer(
                          "assets/images/icons/request.png",
                          "Request",
                          () {},
                          width: 70.0,
                        ),
                        quickActionsContainer(
                          "assets/images/icons/scan.png",
                          "Scan",
                          () {},
                          width: 70.0,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 9),
                  WalletTransactionHistory(),
                ],
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Bottomnavigationbar(4),
    );
  }

  setCurrentPage(int value) {
    currentPage = value;
    setState(() {});
  }

  void notificationFunc() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotificationScreen()),
    );
    currentIndex = 1;
  }

  AnimatedContainer getIndicator(pageNo) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: 8,
      width: (currentPage == pageNo) ? 24 : 8,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        gradient: LinearGradient(
          colors:
              (currentPage == 1)
                  ? [HexColor("#0A0D1C"), HexColor("#061042")]
                  : [HexColor("#39052C"), HexColor("#39052C")],
        ),
        color: HexColor("#260A1F"),
      ),
    );
  }
}
