import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kwik_port/api/controller/home/dashboard_api.dart';
import 'package:kwik_port/api/controller/kwikTickets/get_kwik_ticket_api.dart';
import 'package:kwik_port/api/model/dashboard_model.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/home/dashboard/exportJourney/export_journey_screen.dart';
import 'package:kwik_port/ui/home/dashboard/myexports/my_espoort_utils.dart';
import 'package:kwik_port/ui/home/kwikticket/ticket_details_container.dart';
import 'package:kwik_port/utils/button/bottom_navigatior_bar.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:provider/provider.dart';
import 'package:swipe_refresh/swipe_refresh.dart';

class MyExportsScreen extends StatefulWidget {
  const MyExportsScreen({super.key});

  @override
  State<MyExportsScreen> createState() => _MyExportsScreenState();
}

class _MyExportsScreenState extends State<MyExportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _controller = StreamController<SwipeRefreshState>.broadcast();
  Stream<SwipeRefreshState> get _stream => _controller.stream;
  Future<void> _refresh() async {
    _controller.sink.add(SwipeRefreshState.hidden);
    // _controller.sink.add(SwipeRefreshState.hidden);
  }

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardApi>(context, listen: false).fetchDashboard();
      isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardApi = Provider.of<DashboardApi>(context);
    final exports = dashboardApi.data?.exports ?? [];
    final activeTickets = dashboardApi.data?.exports.length ?? 0;
    final completed = dashboardApi.completedExportsCount;

    return Scaffold(
      extendBody: true,
      backgroundColor: colorCodes.whiteSmoke,
      body: ListView(
        // physics: NeverScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SwipeRefresh.adaptive(
              stateStream: _stream,
              onRefresh: _refresh,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 10.0,
                    right: 10,
                    top: 20.0,
                    bottom: 60,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Your Export Contracts",
                            style: kwikTextStlye(
                              22.0,
                              FontWeight.w600,
                              colorCodes.black,
                            ),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Image.asset(
                                  "assets/images/icons/search_icon_cont.png",
                                  height: 48,
                                  width: 48,
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: Image.asset(
                                  "assets/images/icons/settin_icon_cont.png",
                                  height: 48,
                                  width: 48,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      instructionContainer(
                        "Your Export Contracts",
                        "These are personalized contracts created after funding KwikTickets. Track your export journey, monitor progress, and view financial details.",
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          contractStatusContainer(
                            "assets/images/icons/Trending up (1).png",
                            "Active Contracts",
                            activeTickets.toString(),
                          ),
                          SizedBox(width: 20),
                          contractStatusContainer(
                            "assets/images/icons/note_gren.png",
                            "Completed",
                            completed.toString(),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      myexportTabbar(_tabController, activeTickets, completed),
                      SizedBox(height: 19),
                      SizedBox(
                        // height: 325 * dashboardApi.data?.exports.length??,
                        height:
                            (_tabController.index == 0
                                    ? exports
                                        .where((e) => e.completedAt == null)
                                        .length
                                    : 1
                                // exports
                                //     .where((e) => e.completedAt != null)
                                //     .length
                                )
                                .toDouble() *
                            458,
                        child: TabBarView(
                          controller: _tabController,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            _buildExportList(
                              dashboardApi,
                              statusFilter: "Active",
                            ), //
                            _buildExportList(
                              dashboardApi,

                              statusFilter: "Completed",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Bottomnavigationbar(2),
    );
  }

  double _getTabHeight(dashboardApi) {
    final activeTickets = dashboardApi.data?.exports.length ?? 0;
    final completed = dashboardApi.completedExportsCount;

    final index = _tabController?.index ?? 0;

    final itemCount = index == 0 ? activeTickets : completed;

    const double itemHeight = 458; // your card height
    const double minHeight = 200;

    return (itemCount * itemHeight).clamp(minHeight, 1000);
  }

  Widget _buildExportList(
    DashboardApi dashboardApi, {
    required String statusFilter,
  }) {
    final kwikTickets = dashboardApi.data?.kwikTickets ?? [];

    final exports = dashboardApi.data?.exports ?? [];
    // ✅ Filter exports by status
    // Filter by status
    final filteredExports =
        exports.where((e) {
          bool isActive = e.completedAt == null;
          if (statusFilter == "Active") return isActive;
          if (statusFilter == "Completed") return !isActive;
          return false;
        }).toList();

    if (dashboardApi.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (filteredExports.isEmpty) {
      print("No completed exports found for filter: $statusFilter");
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/icons/filter_result.png',
              height: 100,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No $statusFilter exports found.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemCount: filteredExports.length,
      itemBuilder: (context, index) {
        // final contract = export.contract;

        final export = filteredExports[index];
        final ticketsForExport =
            kwikTickets
                .where((ticket) => ticket.exportContractId == export.contractId)
                .toList();
        return exporttDetailContainer(
          // "", //
          export?.contractId ?? "Unknown",
          // "", //
          export?.commodityName ?? "Unknown Commodity",
          "", //
          //  (export?.contractType == 1 ? "International Buyer" : "Local Buyer"),
          "", //
          // (export?.fulfilledQuantity?.toString() ?? "0"),
          "", // export?.destinationCountry ?? "N/A",
          "", // (export?.totalAmountSpent?.toString() ?? ""),
          "", // // "", //          ticket.kwikTicketAmount.toString()),
          "", // (export?.buyerSpecification?.buyerName?.toString() ?? "N/A"),
          "", // (export?.exportCommission?.toString() ?? "N/A"),
          // "", // "", //   DateFormat('yyyy-MM-dd').format(ticket.createdAt ?? DateTime.now()),
          export.completedAt == null ? true : false,
          () {
            //viewexportFunc
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => ExportJourneyScreen(
                      exporterContractId: export.id ?? '',
                      kwikticket:
                          kwikTickets
                              .first, //export.kwikTicketId, // optional if exists
                    ),
              ),
            );
          },
          context,
        );
      },
    );
  }

  Widget myexportTabbar(_tabController, activeCount, completedCount) {
    return Container(
      height: 46,
      width: 390,
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),

      decoration: BoxDecoration(
        color: colorCodes.white,
        borderRadius: BorderRadius.circular(100),
      ),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,

        labelColor: colorCodes.white,
        labelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelColor: colorCodes.black,
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
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
        controller: _tabController,
        tabs: [
          Tab(text: "Active ($activeCount)"),
          Tab(text: "Completed ($completedCount)"),
        ],
      ),
    );
  }

  Widget contractStatusContainer(icon, status, contractcount) {
    return Container(
      width: 170,
      height: 76,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: colorCodes.white,
      ),
      padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(icon, height: 20, width: 20),
          SizedBox(width: 10),
          Text(
            status,
            style: kwikTextStlye(10.0, FontWeight.w500, colorCodes.black),
          ),
          SizedBox(width: 10),
          Container(
            width: 20,
            height: 20,
            padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorCodes.portlandOrange,
              shape: BoxShape.circle,
              // borderRadius: BorderRadius.circular(100),
              border: Border.all(width: 1, color: colorCodes.portlandOrange),
            ),
            child: Text(
              contractcount,
              style: kwikTextStlye(10.0, FontWeight.w400, colorCodes.white),
            ),
          ),
        ],
      ),
    );
  }
}
