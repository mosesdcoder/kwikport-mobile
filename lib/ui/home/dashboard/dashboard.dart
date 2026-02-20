import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/api/controller/contractsApi/publishedcontractsApi.dart';
import 'package:kwik_port/api/controller/home/dashboard_api.dart';
import 'package:kwik_port/api/controller/kwikTickets/get_kwik_ticket_api.dart';
import 'package:kwik_port/api/model/dashboard_model.dart';
import 'package:kwik_port/api/model/userModel.dart';
import 'package:kwik_port/api/utils/money_util.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/main.dart';
import 'package:kwik_port/ui/home/contracts/available_contract_screen.dart';
import 'package:kwik_port/ui/home/contracts/contract_details_screen.dart';
import 'package:kwik_port/ui/home/contracts/contract_screen.dart';
import 'package:kwik_port/ui/home/contracts/request_contract_screen.dart';
import 'package:kwik_port/ui/home/dashboard/exportJourney/current_export_stage_screen.dart';
import 'package:kwik_port/ui/home/dashboard/exportJourney/export_journey_screen.dart';
import 'package:kwik_port/ui/home/dashboard/exportJourney/procurement_stage_screen.dart';
import 'package:kwik_port/ui/home/dashboard/myexports/my_exports_screen.dart';
import 'package:kwik_port/ui/home/dashboard/name_and_notif_headng.dart';
import 'package:kwik_port/ui/home/dashboard/notifcation/notification_screen.dart';
import 'package:kwik_port/ui/home/dashboard/procurement%20Agency/select_procurement_agency_screen.dart';
import 'package:kwik_port/ui/home/dashboard/wallet_balance_container.dart';
import 'package:kwik_port/ui/home/exportfulfillment/KycVerification/kyc_verification_screen.dart';
import 'package:kwik_port/ui/home/wallet/fund_wallet_screen.dart';
import 'package:kwik_port/ui/home/kwikticket/all_kwik_ticket_screen.dart';
import 'package:kwik_port/ui/home/kwikticket/save_pending_ticket.dart';
import 'package:kwik_port/utils/button/bottom_navigatior_bar.dart';
import 'package:kwik_port/utils/button/elavated_button.dart';
import 'package:kwik_port/utils/button/loading_dialog.dart';
import 'package:kwik_port/utils/containers/available_contract_container.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_refresh/swipe_refresh.dart';

class Dashboard extends StatefulWidget {
  final KwikTicketModel? kwikticket;
  final ExportSummaryModel? exports;
  const Dashboard({super.key, this.kwikticket, this.exports});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool notificationExist = true;
  bool showProcurement = true; // <--- add this
  DateTime? procurementShownTime;

  int itemCount = 3;
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  final _controller = StreamController<SwipeRefreshState>.broadcast();
  Stream<SwipeRefreshState> get _stream => _controller.stream;
  Future<void> _setProcurementShown(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showProcurement', value);
  }

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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadProcurementState();
      // _loadJourneyState();
      await _checkOngoingJourney();
      Provider.of<DashboardApi>(context, listen: false).fetchDashboard();
      // if (dashboardApi.data?.exports.isEmpty ?? true) {
      //   await completeJourney(); // clears SharedPreferences and UI state
      // }

      final api = Provider.of<GetContractApi>(context, listen: false);
      api.fetchContracts(); // PageIndex=1, PageSize=20, version=1
      isLoading = true;

      final ticketProvider = Provider.of<GetKwikTicketApi>(
        context,
        listen: false,
      );

      await ticketProvider.fetchKwikTickets(); // FIRST fetch

      _checkPendingTicket(ticketProvider);

      // Trigger fetch
      // await ticketProvider.fetchKwikTickets();
    });

    _scrollController.addListener(_scrollListener);
  }

  Future<void> _checkPendingTicket(GetKwikTicketApi ticketProvider) async {
    String? pendingTicketId = await getPendingTicket();
    if (pendingTicketId == null) return;

    if (ticketProvider.tickets.isEmpty) return;

    final KwikTicketModel? ticket = ticketProvider.tickets.firstWhere(
      (t) =>
          t.uniqueId == pendingTicketId &&
          t.kwikTicketStatus == KwikTicketStatusEnum.awaitingPayment.value,
      // orElse: () => null, // ← FIX
    );

    if (ticket == null) return;
    if (!mounted) return;

    Future.delayed(Duration(milliseconds: 80), () {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => AlertDialog(
              title: Text("Ticket Awaiting Payment"),
              content: Text("You have a ticket awaiting payment. Continue?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => AllKwikTicketScreen(
                              kwikticket: ticket,
                              pendingKwikticketId: ticket.uniqueId,
                            ),
                      ),
                    );
                  },
                  child: Text("Continue"),
                ),
              ],
            ),
      );
    });
  }

  Future<void> _startProcurementCountdown() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().millisecondsSinceEpoch;
    await prefs.setInt('procurementStartTime', now);
    await prefs.setBool('showProcurement', true);
  }

  Future<void> _saveProcurementVisibility(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('persistedProcurementVisible', value);
  }

  Future<void> _loadProcurementState() async {
    final prefs = await SharedPreferences.getInstance();
    final selected = prefs.getBool('procurementSelected') ?? false;
    final startTime = prefs.getInt('procurementStartTime');
    final inProgress = prefs.getBool('procurementInProgress') ?? false;
    final completed = prefs.getBool('procurementCompleted') ?? false;

    // Hide prompt immediately if user already selected an agency
    if (selected || inProgress) {
      setState(() => showProcurement = false);
      await prefs.setBool('showProcurement', false);
      return;
    }
    if (completed) {
      setState(() => showProcurement = false);
      return;
    }

    if (widget.kwikticket == null) {
      // No KwikTicket → never show
      setState(() => showProcurement = false);
      await prefs.setBool('showProcurement', false);
      return;
    }

    if (startTime == null) {
      // First time → show and start timer
      await prefs.setInt(
        'procurementStartTime',
        DateTime.now().millisecondsSinceEpoch,
      );
      await prefs.setBool('showProcurement', true);
      setState(() => showProcurement = true);
      return;
    }

    // Has timer → check if 24h passed
    final startDate = DateTime.fromMillisecondsSinceEpoch(startTime);
    final diff = DateTime.now().difference(startDate);

    if (diff >= const Duration(hours: 24)) {
      await prefs.setBool('showProcurement', false);
      setState(() => showProcurement = false);
    } else {
      setState(() => showProcurement = true);
      final remaining = const Duration(hours: 24) - diff;
      Timer(remaining, () async {
        if (mounted) {
          setState(() => showProcurement = false);
          await prefs.setBool('showProcurement', false);
        }
      });
    }
  }

  bool showContinueJourney = false;
  String? exportContractId;
  KwikTicketModel? kwikticket;

  // Start a new export journey
  Future<void> startNewJourney(String newExporterContractId) async {
    final prefs = await SharedPreferences.getInstance();

    // Clear any previous data
    await prefs.remove('activeExportContractId');
    await prefs.remove('journeyInProgress');

    // Save new journey details
    await prefs.setString('activeExportContractId', newExporterContractId);
    await prefs.setBool('journeyInProgress', true);

    // Update UI state
    setState(() {
      exportContractId = newExporterContractId;
      showContinueJourney = true;
    });
  }

  // Complete the current journey
  Future<void> completeJourney() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('activeExportContractId');
    await prefs.remove('journeyInProgress');

    // Update UI
    setState(() {
      // showContinueJourney = false;
      exportContractId = null;
    });
  }

  Future<void> _checkOngoingJourney() async {
    final prefs = await SharedPreferences.getInstance();

    final inProgress = prefs.getBool('journeyInProgress') ?? false;
    final contractId = prefs.getString('activeExportContractId');

    // Load saved ticket
    final ticketJson = prefs.getString('activeKwikTicket');
    KwikTicketModel? loadedTicket;

    if (ticketJson != null && ticketJson.isNotEmpty) {
      loadedTicket = KwikTicketModel.fromJson(jsonDecode(ticketJson));
    }

    // Check if the export is actually in the dashboard data and not completed
    final dashboardApi = Provider.of<DashboardApi>(context, listen: false);
    bool exportStillActive = false;

    if (contractId != null && dashboardApi.data?.exports != null) {
      exportStillActive = dashboardApi.data!.exports.any(
        (export) =>
            export.contractId == contractId &&
            export.exportContractStage !=
                'Payout', // Hide card when status is "Payout"
      );
    }

    // If export has reached "Payout" status, clear the journey data
    // if (!exportStillActive && inProgress) {
    //   await prefs.remove('activeExportContractId');
    //   await prefs.remove('journeyInProgress');
    //   await prefs.remove('activeKwikTicket');
    // }
    if (!exportStillActive && inProgress) {
      // Just hide UI — do NOT delete state
      setState(() {
        showContinueJourney = false;
      });
      return;
    }

    // RULE: show button ONLY if journey is in progress AND export is still active
    final shouldShowJourney =
        inProgress == true &&
        contractId != null &&
        loadedTicket != null &&
        exportStillActive;

    setState(() {
      showContinueJourney = shouldShowJourney;
      exportContractId = shouldShowJourney ? contractId : null;
      kwikticket = shouldShowJourney ? loadedTicket : null;
    });
  }

  // Future<void> _checkOngoingJourney() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final inProgress = prefs.getBool('journeyInProgress') ?? false;
  //   final contractId = prefs.getString('activeExportContractId');
  //   final ticketJson = prefs.getString('activeKwikTicket');

  //   KwikTicketModel? loadedTicket;

  //   if (ticketJson != null && ticketJson.isNotEmpty) {
  //     loadedTicket = KwikTicketModel.fromJson(jsonDecode(ticketJson));
  //   }

  //   setState(() {
  //     showContinueJourney = inProgress;
  //     exportContractId = contractId;
  //     kwikticket = loadedTicket; // ✅ FIXED
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final contractProvider = Provider.of<GetContractApi>(context);
    final dashboardApi = Provider.of<DashboardApi>(context);
    final isLoading = dashboardApi.loading;
    final walletBalance = dashboardApi.data?.walletBalance ?? 0.0;
    final kwikLCBalance = dashboardApi.data?.kwikLCBalance ?? 0.0;
    final totalExportContractBalance =
        dashboardApi.data?.totalExportContractBalance ?? 0.0;
    print('Total Export Contract Balance: $totalExportContractBalance');
    print('KwikTicket passed to MyExportsScreen: ${widget}');

    if (dashboardApi.data?.exports.isNotEmpty ?? false) {
      // Print all exports in chunks to avoid truncation
      final exportsJson =
          dashboardApi.data!.exports.map((e) => e.toJson()).toList();
      final exportsString = exportsJson.toString();
      const chunkSize = 800;
      for (var i = 0; i < exportsString.length; i += chunkSize) {
        final end =
            (i + chunkSize < exportsString.length)
                ? i + chunkSize
                : exportsString.length;
        print('dashboard data chunk: ${exportsString.substring(i, end)}');
      }
    } else {
      print('dashboard data: No exports available');
    }
    _resolveExport(DashboardApi dashboardApi) {
      if (exportContractId == null) return null;

      final exports = dashboardApi.data?.exports ?? [];
      if (exports.isEmpty) return null;

      for (final e in exports) {
        if (e.contractId == exportContractId) {
          return e;
        }
      }
      return null;
    }

    final activeTickets = dashboardApi.activeKwikTicketsCount;
    final activeExports = dashboardApi.activeExportsCount;
    // final activeContracts = dashboardApi.getActiveExportsCount;
    final exportWalletBalance =
        dashboardApi.data?.totalExportContractBalance ?? 0.0;
    final completed = dashboardApi.completedExportsCount;
    bool showBalance = true;

    // final exports= dashboardApi.data?.exports ?? [];
    final user = dashboardApi.data?.userProfile;
    final first = user?.firstName ?? "";
    final last = user?.lastName ?? "";
    final export = _resolveExport(dashboardApi);
    // final export = dashboardApi.data?.exports.firstWhere(
    //   (e) => e.contractId == exportContractId,
    //   orElse: () => throw Exception("Export not found"),
    // );
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent going back
        return false;
      },
      child: Scaffold(
        extendBody: true,
        backgroundColor: colorCodes.whiteSmoke,
        body:
            (dashboardApi.data?.userProfile == null)
                ? Center(child: kwikportloader())
                : ListView(
                  children: [
                    // Padding(
                    //   padding: EdgeInsets.symmetric(
                    //     horizontal: 10.0,
                    //     vertical: 50.0,
                    //   ),
                    //   child:
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
                                "$first $last".trim().isNotEmpty
                                    ? "${first.toUpperCase()} ${last.toUpperCase()}"
                                        .trim()
                                    : "User",
                                notificationExist,
                                notificationFunc,
                              ),
                              SizedBox(height: 30),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    dashboardBalanceContainer(
                                      showBalance == true
                                          ? "\$$totalExportContractBalance"
                                          : "••••••••",
                                      showBalance,
                                      () {
                                        setState(() {
                                          showBalance = !showBalance;
                                        });
                                      },
                                      context,
                                    ),
                                    // SizedBox(width: 5),
                                    Column(
                                      children: [
                                        activityProgressContainer(
                                          "assets/images/icons/kwik_tickets.png",
                                          "Kwiktickets",
                                          activeExports.toString().padLeft(
                                            2,
                                            '0',
                                          ),
                                          context,
                                          () {
                                            currentIndex = 1;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (_) => MyExportsScreen(
                                                      exports: widget.exports,
                                                    ),
                                              ),
                                            );
                                          },
                                        ),
                                        SizedBox(height: 5),
                                        activityProgressContainer(
                                          "assets/images/icons/completed_ecport.png",
                                          "Completed Exports",
                                          completed.toString().padLeft(2, '0'),
                                          //"15",
                                          context,
                                          () {
                                            currentIndex = 1;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (_) => MyExportsScreen(
                                                      exports: widget.exports,
                                                    ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 18),

                              // Procurement container
                              // if (showProcurement)
                              if (widget.kwikticket != null && showProcurement)
                                // procurementContainer(export),
                                procurementContainer(),
                              if (widget.kwikticket != null && showProcurement)
                                if (showProcurement) SizedBox(height: 25),
                              if (showContinueJourney == true &&
                                  widget.kwikticket != null
                              //     exportContractId != null
                              )
                                Container(
                                  height: 70,
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 8.0,
                                  ),
                                  decoration: BoxDecoration(
                                  // decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1.2,
                                      color: colorCodes.antiFlashWhite,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                    color: colorCodes.white,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/clock_awaits.png",
                                            height: 40,
                                            width: 40,
                                          ),
                                          const SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Export Journey In Progress",
                                                style: kwikTextStlye(
                                                  12.0,
                                                  FontWeight.w300,
                                                  colorCodes.graniteGrey,
                                                ),
                                              ),
                                              Text(
                                                "Continue your export journey",
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
                                        child: elevatedbutton(
                                          "Continue",
                                          () async {
                                            final dashboardApi =
                                                Provider.of<DashboardApi>(
                                                  context,
                                                  listen: false,
                                                );
                                            final exports =
                                                dashboardApi.data?.exports;
                                            print(
                                              'DEBUG: exportContractId: $exportContractId',
                                            );
                                            print(
                                              'DEBUG: kwikticket: $kwikticket',
                                            );
                                            print(
                                              'DEBUG: dashboardApi.data: ${dashboardApi.data}',
                                            );
                                            print(
                                              'DEBUG: dashboardApi.data?.exports: $exports',
                                            );
                                            if (exports == null ||
                                                exportContractId == null) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "Export data not available.",
                                                  ),
                                                ),
                                              );
                                              return;
                                            }
                                            final matches = exports.where(
                                              (e) =>
                                                  e.contractId ==
                                                  exportContractId,
                                            );
                                            final export =
                                                matches.isNotEmpty
                                                    ? matches.first
                                                    : null;
                                            if (export != null) {
                                              // Debug: Check kwikticket and commodity before navigation
                                              debugPrint(
                                                'Dashboard: kwikticket = $kwikticket',
                                              );
                                              debugPrint(
                                                'Dashboard: export.kwikTicket = \\${export.kwikTicket}',
                                              );
                                              debugPrint(
                                                'Dashboard: export.kwikTicket.commodity = \\${export.kwikTicket?.commodity}',
                                              );
                                              debugPrint(
                                                'Dashboard: export.kwikTicket.commodity.name = \\${export.kwikTicket?.commodity?.name}',
                                              );
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (
                                                        context,
                                                      ) => ExportJourneyScreen(
                                                        kwikticket:
                                                            export.kwikTicket,
                                                        exporterContractId:
                                                            exportContractId!,
                                                        exportData: export,
                                                      ),
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "Export not found.",
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          backgroundcolor:
                                              colorCodes.portlandOrange,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

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
                                    () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => FundWalletScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(width: 20),
                                  quickActionsContainer(
                                    "assets/images/icons/dashboard/requestcontract_action.png",
                                    "Request Contract",
                                    () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  RequestContractScreen(),
                                        ),
                                      );
                                      currentIndex = 2;
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                          builder:
                                              (context) => ContractScreen(),
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
                                      } else if (contractProvider
                                          .contracts
                                          .isEmpty) {
                                        return Text("No contracts available");
                                      } else {
                                        return avaiableontractContainerUpdated(
                                          contract.commodityImage ??
                                              "https://kwikport.s3.eu-west-3.amazonaws.com/commodity-images/cocoa.png",
                                          contract.commodityName,
                                          "assets/images/icons/tick-circle.png",
                                          "${contract.contractStatus}", //== 0
                                          // ? "Active"
                                          // : "Closed",
                                          // "Open",
                                          "Grade A - Premium Quality",
                                          "assets/images/icons/Country.png",
                                          contract.destinationCountry,
                                          // "\$12,500",
                                          "${MoneyUtils.formatMoney(contract.totalAmountInUSD, symbol: "\$", decimalDigits: 2)}",
                                          () {
                                            currentIndex = 2;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (
                                                      context,
                                                    ) => ContractDetailsScreen(
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
                              SizedBox(height: 18),

                              Padding(
                                padding: const EdgeInsets.only(bottom: 80.0),
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
                                      } else if (contractProvider
                                          .contracts
                                          .isEmpty) {
                                        return Text("No contracts available");
                                      } else {
                                        return avaiableontractContainerUpdated(
                                          contract.commodityImage ??
                                              "https://kwikport.s3.eu-west-3.amazonaws.com/commodity-images/cocoa.png",
                                          contract.commodityName,
                                          "assets/images/icons/tick-circle.png",
                                          "${contract.contractStatus}", //== 0
                                          // ? "Active"
                                          // : "Closed",
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
                                                    (
                                                      context,
                                                    ) => ContractDetailsScreen(
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
                          // ),
                        ],
                      ),
                    ),
                    // ),
                    //     ),
                    //   ],
                    // ),
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

  Widget procurementContainer(
    // exportData
  ) {
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
            child: elevatedbutton("Proceed", () async {
              // Navigate to agency selection, then refresh and hide prompt
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => SelectProcurementAgencyScreen(
                        // CurrentExportStageScreen(
                        kwikticket: widget.kwikticket,
                        // exportData: exportData,
                      ),
                ),
              );
              // Re-evaluate persisted state and hide immediately
              await _loadProcurementState();
              setState(() => showProcurement = false);
            }, backgroundcolor: colorCodes.portlandOrange),
          ),
        ],
      ),
    );
  }
}
