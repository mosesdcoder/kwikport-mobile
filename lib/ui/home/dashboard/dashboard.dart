import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/api/controller/contractsApi/publishedcontractsApi.dart';
import 'package:kwik_port/api/controller/home/dashboard_api.dart';
import 'package:kwik_port/api/model/dashboard_model.dart';
import 'package:kwik_port/api/model/userModel.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/main.dart';
import 'package:kwik_port/ui/home/contracts/available_contract_screen.dart';
import 'package:kwik_port/ui/home/contracts/contract_details_screen.dart';
import 'package:kwik_port/ui/home/contracts/contract_screen.dart';
import 'package:kwik_port/ui/home/contracts/request_contract_screen.dart';
import 'package:kwik_port/ui/home/dashboard/name_and_notif_headng.dart';
import 'package:kwik_port/ui/home/dashboard/notifcation/notification_screen.dart';
import 'package:kwik_port/ui/home/dashboard/procurement%20Agency/select_procurement_agency_screen.dart';
import 'package:kwik_port/ui/home/dashboard/wallet_balance_container.dart';
import 'package:kwik_port/utils/button/bottom_navigatior_bar.dart';
import 'package:kwik_port/utils/button/elavated_button.dart';
import 'package:kwik_port/utils/button/loading_dialog.dart';
import 'package:kwik_port/utils/containers/available_contract_container.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:provider/provider.dart';
import 'package:swipe_refresh/swipe_refresh.dart';

class Dashboard extends StatefulWidget {
  final KwikTicketModel? kwikticket;
  const Dashboard({super.key, this.kwikticket});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool notificationExist = true;
  int itemCount = 3;
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  final _controller = StreamController<SwipeRefreshState>.broadcast();
  Stream<SwipeRefreshState> get _stream => _controller.stream;

  void _scrollListener() {
    final api = Provider.of<GetContractApi>(context, listen: false);
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!api.loading && api.hasMore) {
        api.fetchContracts();
      }
    }
  }

  Future<void> _refresh() async {
    final api = Provider.of<GetContractApi>(context, listen: false);
    await api.fetchContracts();
    _controller.sink.add(SwipeRefreshState.hidden);
    // _controller.sink.add(SwipeRefreshState.hidden);
  }

  @override
  void initState() {
    super.initState();
    currentIndex = 1;
    notificationExist;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardApi>(context, listen: false).fetchDashboard();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final api = Provider.of<GetContractApi>(context, listen: false);
      api.fetchContracts(); // PageIndex=1, PageSize=20, version=1
      isLoading = true;
    });
    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    final contractProvider = Provider.of<GetContractApi>(context);
    final dashboardApi = Provider.of<DashboardApi>(context);
    final isLoading = dashboardApi.loading;
    final walletBalance = dashboardApi.data?.walletBalance ?? 0.0;
    final activeTickets = dashboardApi.activeKwikTicketsCount;
    final completed = dashboardApi.completedExportsCount;
    // final exports= dashboardApi.data?.exports ?? [];
    final user = dashboardApi.data?.userProfile;
    // final contractProvider = Provider.of<GetContractApi>(context);
    // final session = loadUserSessionFromPrefs();
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent going back
        return false;
      },
      child: Scaffold(
        extendBody: true,
        backgroundColor: colorCodes.whiteSmoke,
        body: ListView(
          shrinkWrap: true,
          physics: RangeMaintainingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 50.0),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SwipeRefresh.adaptive(
                // physics: NeverScrollableScrollPhysics(),
                stateStream: _stream,
                onRefresh: _refresh,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      nameAndNotifHeading(
                        context,
                        user != null
                            ? "${user.firstName.toUpperCase()} ${user.lastName.toUpperCase()}"
                            : "User",
                        notificationExist,
                        notificationFunc,
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            dashboardBalanceContainer(
                              walletBalance,
                              () {},
                              context,
                            ),
                            // SizedBox(width: 5),
                            Column(
                              children: [
                                activityProgressContainer(
                                  "assets/images/icons/kwik_tickets.png",
                                  "Active Kwiktickets",
                                  activeTickets.toString().padLeft(2, '0'),

                                  // "01",
                                  context,
                                ),
                                SizedBox(height: 5),
                                activityProgressContainer(
                                  "assets/images/icons/completed_ecport.png",
                                  "Completed Exports",
                                  completed.toString().padLeft(2, '0'),
                                  // "15",
                                  context,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 18),
                      if (widget.kwikticket != null) procurementContainer(),

                      if (widget.kwikticket != null) SizedBox(height: 25),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Quick Actions",
                          style: kwikTextStlye(
                            16.0,
                            FontWeight.w500,
                            colorCodes.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          quickActionsContainer(
                            "assets/images/icons/dashboard/fundwallet_acction.png",
                            "Fund Wallet",
                            () {},
                          ),
                          SizedBox(width: 20),
                          quickActionsContainer(
                            "assets/images/icons/dashboard/requestcontract_action.png",
                            "Request Contract",
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RequestContractScreen(),
                                ),
                              );
                              currentIndex = 2;
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Available Contracts",
                            style: kwikTextStlye(
                              16.0,
                              FontWeight.w500,
                              colorCodes.black,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              currentIndex = 2;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ContractScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "See All",
                              style: kwikTextStlye(
                                14.0,
                                FontWeight.w500,
                                colorCodes.azureBlue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 18),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 55.0),
                        child: SizedBox(
                          height: 210,
                          child: ListView.separated(
                            // padding: EdgeInsets.only(bottom: 30),
                            // physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            separatorBuilder:
                                (context, index) => SizedBox(width: 16),
                            itemCount:
                                contractProvider.contracts.length > 2
                                    ? 2
                                    : contractProvider.contracts.length,
                            itemBuilder: (ctx, index) {
                              final contract =
                                  contractProvider.contracts[index];
                              if (isLoading) {
                                return Center(child: kwikportloader());
                              } else if (contractProvider.contracts.isEmpty) {
                                return Text("No contracts available");
                              } else {
                                return avaiableontractContainerUpdated(
                                  contract.commodityImage,
                                  contract.commodityName,
                                  "assets/images/icons/tick-circle.png",
                                  contract.contractStatus == 0
                                      ? "Active"
                                      : "Closed",
                                  // "Open",
                                  "Grade A - Premium Quality",
                                  "assets/images/icons/Country.png",
                                  contract.destinationCountry,
                                  // "\$12,500",
                                  "\$${contract.totalAmount?.toStringAsFixed(2) ?? '0.00'}",
                                  () {
                                    currentIndex = 2;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ContractDetailsScreen(
                                              // contractId: export.id,
                                              // contractStatus: export.contractStatus,
                                              contract: contract,
                                            ),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Bottomnavigationbar(1),
      ),
    );
  }

  void notificationFunc() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotificationScreen()),
    );
    currentIndex = 1;
  }

  Widget procurementContainer() {
    return Container(
      height: 70,
      width: 390,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1.2, color: colorCodes.antiFlashWhite),
        borderRadius: BorderRadius.circular(6),
        color: colorCodes.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/clock_awaits.png",
                height: 40,
                width: 40,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Awaiting your action",
                    style: kwikTextStlye(
                      12.0,
                      FontWeight.w300,
                      colorCodes.graniteGrey,
                    ),
                  ),
                  // SizedBox(height: 3),
                  Text(
                    "Select procurement agency",
                    style: kwikTextStlye(
                      12.0,
                      FontWeight.w500,
                      colorCodes.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 23,
            // width: 58,
            child: elevatedbutton("Proceed", () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => SelectProcurementAgencyScreen(
                        kwikticket: widget.kwikticket,
                      ),
                ),
              );
            }, backgroundcolor: colorCodes.portlandOrange),
          ),
        ],
      ),
    );
  }
}
