import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kwik_port/api/controller/kwikTickets/get_kwik_ticket_api.dart';
import 'package:kwik_port/api/model/dashboard_model.dart';
import 'package:kwik_port/api/utils/money_util.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/main.dart';
import 'package:kwik_port/ui/home/exportfulfillment/KycVerification/fund_export_contract.dart';
import 'package:kwik_port/ui/home/exportfulfillment/export_fulfillment_screen.dart';
import 'package:kwik_port/ui/home/kwikticket/ticket_details_container.dart';
import 'package:kwik_port/utils/button/back_nav_header.dart';
import 'package:kwik_port/utils/button/bottom_navigatior_bar.dart';
import 'package:provider/provider.dart';
import 'package:swipe_refresh/swipe_refresh.dart';

class AllKwikTicketScreen extends StatefulWidget {
  final KwikTicketModel? kwikticket;
  final String? pendingKwikticketId;

  const AllKwikTicketScreen({
    super.key,
    this.kwikticket,
    this.pendingKwikticketId,
  });

  @override
  State<AllKwikTicketScreen> createState() => _AllKwikTicketScreenState();
}

enum KwikTicketStatusEnum {
  active(1),
  awaitingPayment(2),

  completed(3),
  expired(4),
  paid(5),
  cancelled(6);

  final int value;
  const KwikTicketStatusEnum(this.value);
}

class _AllKwikTicketScreenState extends State<AllKwikTicketScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _controller = StreamController<SwipeRefreshState>.broadcast();
  Stream<SwipeRefreshState> get _stream => _controller.stream;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Fetch contracts on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final api = Provider.of<GetKwikTicketApi>(context, listen: false);
      api.fetchKwikTickets(); // PageIndex=1, PageSize=20, version=1
      isLoading = true;
    });
    // _scrollController.addListener(_scrollListener);
  }

  Future<void> _refresh() async {
    final api = Provider.of<GetKwikTicketApi>(context, listen: false);
    setState(() {
      // selectedCategory = null; // Clear category filter
    });
    await api.fetchKwikTickets();
    _controller.sink.add(SwipeRefreshState.hidden);
    // _controller.sink.add(SwipeRefreshState.hidden);
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    // _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? statusFilter;
    final ticketProvider = Provider.of<GetKwikTicketApi>(context);
    final filteredTickets =
        ticketProvider.tickets.where((t) {
          // Adjust filtering based on your backend status codes
          switch (statusFilter) {
            case "awaiting":
              return t.kwikTicketStatus ==
                  KwikTicketStatusEnum.awaitingPayment.value;
            case "active":
              return t.kwikTicketStatus == KwikTicketStatusEnum.active.value;

            case "fulfilled":
              return t.kwikTicketStatus == KwikTicketStatusEnum.paid.value;
            default:
              return true;
          }
        }).toList();
    return Scaffold(
      extendBody: true,
      backgroundColor: colorCodes.whiteSmoke,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 42.0, bottom: 15),
          child: Text(
            "Kwiktickets",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24.0,
              fontWeight: FontWeight.w600,
              color: colorCodes.black,
            ),
          ),
        ),
      ),

      body:
      // ListView(
      //   children: [
      SizedBox(
        height: MediaQuery.of(context).size.height - 20,
        child: SwipeRefresh.adaptive(
          physics: const NeverScrollableScrollPhysics(),
          stateStream: _stream,
          onRefresh: _refresh,
          children: [
            Padding(
              // height: MediaQuery.of(context).size.height - 20,
              padding: EdgeInsets.only(
                left: 18,
                right: 18,
                top: 10,
                bottom: 55,
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Use a ListView to provide bounded height and scrolling
                  kwikticketTabBar(_tabController),
                  SizedBox(height: 21),
                  // The TabBarView should expand to fill available space
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 220, // adjust as needed for your layout
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildTicketList(ticketProvider, statusFilter: "awaiting"),
                        _buildTicketList(ticketProvider, statusFilter: "active"),
                        _buildTicketList(ticketProvider, statusFilter: "fulfilled"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      //   ],
      // ),
      bottomNavigationBar: Bottomnavigationbar(3),
    );
  }

  Widget kwikticketTabBar(_tabController) {
    return Container(
      height: 46,
      width: 390,
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),

      decoration: BoxDecoration(
        color: colorCodes.white,
        borderRadius: BorderRadius.circular(100),
      ),
      child: TabBar(
        // indicatorColor: colorCodes.teaGreen,
        // labelPadding: const EdgeInsets.symmetric(vertical: 12),
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
          // color: colorCodes
        ),

        // indicatorPadding: const EdgeInsets.symmetric(
        //   vertical: 4,
        //   horizontal: 4,
        // ),
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
          Tab(text: "Awaiting"),
          Tab(text: "Active"),

          Tab(text: "Fulfilled"),
        ],
      ),
    );
  }

  /// Ticket list for each tab
  Widget _buildTicketList(
    GetKwikTicketApi provider, {
    required String statusFilter,
  }) {
    print("Tickets fetched: ${provider.tickets.length}");
    for (var t in provider.tickets) {
      print("Ticket ID: ${t.uniqueId}, Status Value: ${t.kwikTicketStatus}");
    }
    print("Filtering for statusFilter = $statusFilter");
    for (var t in provider.tickets) {
      print("Ticket: ${t.uniqueId}, Status: ${t.kwikTicketStatus}");
    }
    if (provider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final filteredTickets =
        provider.tickets.where((t) {
          switch (statusFilter) {
            case "awaiting":
              return t.kwikTicketStatus ==
                  KwikTicketStatusEnum.awaitingPayment.value;
            case "active":
              return t.kwikTicketStatus == KwikTicketStatusEnum.active.value;
            case "fulfilled":
              return t.kwikTicketStatus == KwikTicketStatusEnum.paid.value;
            default:
              return true;
          }
        }).toList();

    // 🔥 Sort newest ticket on top
    // filteredTickets.sort((a, b) {
    //   final dateA = a.createdAt ?? DateTime(2000);
    //   final dateB = b.createdAt ?? DateTime(2000);
    //   return dateB.compareTo(dateA);
    // });
    // final allTickets = provider.tickets;

    // if (filteredTickets.isEmpty) {
    //   return const Center(child: Text("No tickets found"));
    // }
    // ✅ If no tickets match this category
    if (filteredTickets.isEmpty) {
      String emptyMessage;
      switch (statusFilter) {
        case "awaiting":
          emptyMessage = "No awaiting tickets";
          break;
        case "active":
          emptyMessage = "No active tickets";
          break;
        case "fulfilled":
          emptyMessage = "No fulfilled tickets";
          break;
        default:
          emptyMessage = "No tickets found";
      }
      
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: colorCodes.whiteSmoke,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.receipt_long_outlined,
                  size: 60,
                  color: colorCodes.graniteGrey.withOpacity(0.4),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                emptyMessage,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: colorCodes.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Your tickets will appear here once available',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: colorCodes.graniteGrey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemCount: filteredTickets.length,
      itemBuilder: (context, index) {
        final ticket = filteredTickets[index];
        final contract = ticket.contract;
        final buyerSpec = contract?.buyerSpecification;
        // final ticket = allTickets[index];
        // final contract = ticket.contract;
        // final buyerSpec = contract?.buyerSpecification;
        return ticketDetailContainer(
          ticket.uniqueId ?? "Unknown",
          ticket.exporter?.businessName ?? "",
          ticket.contract?.commodityName ?? "Unknown Commodity",
          (contract?.contractType == 1 ? "International Buyer" : "Local Buyer"),
          (ticket?.quantityToFulfill?.toString() ?? "0"),
          contract?.destinationCountry ?? "N/A",
          (ticket?.kwikTicketAmount?.toString() ?? ticket.kwikTicketAmount.toString()),
          (contract?.pricePerUnitInUSD)?.toString() ?? "N/A",
          (contract?.projectedIncome?.toString() ?? "N/A"),
          contract?.pricePerUnitInUSD ?? 0.0,
          DateFormat('yyyy-MM-dd').format(ticket.createdAt ?? DateTime.now()),
          ticket.kwikTicketStatus,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExportFulfillmentScreen(
                  kwikticket: ticket,
                  // kwikTicketId: ticket.id!,
                ),
              ),
            );
          },
          context,
        );
      },
    );
  }
}
