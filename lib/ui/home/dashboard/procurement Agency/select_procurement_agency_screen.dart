import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/api/controller/agency/get_agency_api.dart';
import 'package:kwik_port/api/model/dashboard_model.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/home/dashboard/procurement%20Agency/agency_container.dart';
import 'package:kwik_port/ui/home/dashboard/procurement%20Agency/confirm_agency_selection_dialog.dart';
import 'package:kwik_port/utils/button/back_nav_header.dart';
import 'package:kwik_port/utils/button/bottom_navigatior_bar.dart';
import 'package:kwik_port/utils/button/loading_dialog.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_refresh/swipe_refresh.dart';

class SelectProcurementAgencyScreen extends StatefulWidget {
  final KwikTicketModel? kwikticket;
  const SelectProcurementAgencyScreen({super.key, required this.kwikticket});

  @override
  State<SelectProcurementAgencyScreen> createState() =>
      _SelectProcurementAgencyScreenState();
}

class _SelectProcurementAgencyScreenState
    extends State<SelectProcurementAgencyScreen> {
  final ScrollController _scrollController = ScrollController();

  // int endTime = DateTime.now().millisecondsSinceEpoch + 86400000; // 24 hours

  int itemCount = 5;
  // List agencyName = [
  //   "AgriSource Hub Ltd.",
  //   "FarmLink Aggregators",
  //   "GreenGate Procurement",
  //   "AgroTrust Services",
  //   "HarvestPoint Aggregators",
  // ];
  // String reviewStar = '4.8';
  // String ratingStr = reviewStar.split('/')[0].replaceAll('(', '').trim();
  // double agencyrating = double.tryParse('4.8') ?? 0.0; // Safely parse rating
  final _controller = StreamController<SwipeRefreshState>.broadcast();
  Stream<SwipeRefreshState> get _stream => _controller.stream;
  void _scrollListener() {
    final agencyApi = Provider.of<GetAgencyApi>(context, listen: false);

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // near bottom → fetch more
      if (!agencyApi.loading && agencyApi.hasMore) {
        agencyApi.fetchAgencies(loadMore: true);
      }
    }
  }

  int endTime = 0;

  @override
  void initState() {
    super.initState();
    // Schedule the API call after the first build phase
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      final savedExportId = prefs.getString('activeExportContractId');
      final currentExportId = widget.kwikticket?.exportContractId;

      // 🧹 reset timer if this is a new export
      // if (savedExportId != currentExportId) {
      //   await prefs.remove('procurementStartTime');
      //   await prefs.setString('activeExportContractId', currentExportId ?? '');
      // }

      if (savedExportId == null || savedExportId != currentExportId) {
        await prefs.remove('procurementStartTime');
      }

      await prefs.setString('activeExportContractId', currentExportId ?? '');
      // start fresh if missing
      final startTime =
          prefs.getInt('procurementStartTime') ??
          DateTime.now().millisecondsSinceEpoch;
      await prefs.setInt('procurementStartTime', startTime);
      endTime = startTime + Duration(hours: 24).inMilliseconds;
      setState(() {});

      setState(() {});
      _fetchInitialAgency();
    });
    // _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _fetchInitialAgency() async {
    final agencyApi = Provider.of<GetAgencyApi>(context, listen: false);
    agencyApi.fetchAgenciesByStageType(2);
  }

  Future<void> _refresh() async {
    final api = Provider.of<GetAgencyApi>(context, listen: false);
    await api.fetchAgenciesByStageType(2);
    _controller.sink.add(SwipeRefreshState.hidden);
    // _controller.sink.add(SwipeRefreshState.hidden);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final agencyProvider = Provider.of<GetAgencyApi>(context);
    // final selectagencyPRovider = Provider.of<ExportStageApi>(context);

    return Scaffold(
      extendBody: true,
      backgroundColor: colorCodes.whiteSmoke,
      body: ListView(
        controller: _scrollController,
        // physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height - 20,

            child: SwipeRefresh.adaptive(
              stateStream: _stream,
              onRefresh: _refresh,

              children: [
                Padding(
                  // physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 70,
                    top: 40,
                  ),

                  child: Column(
                    children: [
                      backNavRow(
                        context,
                        "Select Procurement Agency",
                        fontSize: 18.0,
                        imgsize: 36.0,
                      ),
                      SizedBox(height: 31),
                      Image.asset(
                        "assets/images/icons/procuement_select_check.png",
                        height: 96,
                        width: 113,
                      ),
                      SizedBox(height: 31),
                      Text(
                        "Choose a procurement agency\nfor your export contract",
                        textAlign: TextAlign.center,
                        style: kwikTextStlye(
                          18.0,
                          FontWeight.w600,
                          colorCodes.black,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Your selection will be locked in 24 hours.",
                        style: kwikTextStlye(
                          14.0,
                          FontWeight.w300,
                          colorCodes.graniteGrey,
                        ),
                      ),
                      SizedBox(height: 17),
                      _infoBox(),
                      const SizedBox(height: 20),
                      _timerBox(),
                      const SizedBox(height: 20),
                      agencyProvider.loading
                          ? Center(child: kwikportloader())
                          : _buildAgencyList(
                            agencyProvider,
                            // selectagencyPRovider,
                          ),
                    ],
                  ),
                  // ),
                  // ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Bottomnavigationbar(1),
    );
  }

  int daysToHours(int days) {
    return days * 24;
  }

  Widget _buildAgencyList(
    GetAgencyApi agencyProvider,
    // ExportStageApi selectagencyPRovider,
  ) {
    if (agencyProvider.agencies.isEmpty) {
      return Center(
        child: Text(
          "No agencies available at the moment.",
          style: kwikTextStlye(14.0, FontWeight.w400, colorCodes.black),
        ),
      );
    }

    return SizedBox(
      height: 250 * 3.toDouble(),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemCount: agencyProvider.agencies.length,
        itemBuilder: (ctx, index) {
          final agency = agencyProvider.agencies[index];
          final name = agency.name;
          final rating = (agency.rating?.toDouble());
          final fee = agency.serviceFee.toString() ?? '0';
          final days = agency.numberOfDaysToDeliver.toString() ?? '-';

          return procurementAgencyContainer(
            "assets/images/icons/dashboard/procurement_agency_logo.png",
            name,
            rating,
            "\$$fee",
            "#62,000",
            "$days days",
            "${daysToHours(int.tryParse(days) ?? 0)}hours",
            "120 reviews",
            () {},
            () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return ConfirmAgencySelectionDialog(
                    serviceFee: "\$$fee",
                    totalcostTons:
                        widget.kwikticket?.quantityToFulfill, // "20.5",
                    totalCost:
                        "${widget.kwikticket?.kwikTicketAmount}", // "₦246,000,000",

                    agencyName: agency.name,
                    kwikticket: widget.kwikticket,
                    agencyId: agency.id,
                  );
                },
              );
              // Navigator.pop(context);
            },
          );
        },
      ),
    );
  }

  Widget _infoBox() {
    return Container(
      height: 119,
      width: 390,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: HexColor("#D0E1FB").withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 1.5, color: colorCodes.paleCornflowerBlue),
      ),
      child: Row(
        children: [
          Image.asset(
            "assets/images/icons/blue_info.png",
            height: 25,
            width: 25,
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 260,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Payment Information",
                  style: kwikTextStlye(
                    14.0,
                    FontWeight.w600,
                    colorCodes.bluetiful,
                  ),
                ),
                Text(
                  "Agency fees will be automatically deducted in USD from your KwikLC wallet balance. Your gross export earnings are already secured in your wallet.",
                  style: kwikTextStlye(
                    11.0,
                    FontWeight.w300,
                    colorCodes.bluetiful,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _timerBox() {
    return Container(
      height: 80,
      width: 390,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: colorCodes.floralWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 1.5, color: colorCodes.yellowOrange),
      ),
      child: Row(
        children: [
          Image.asset(
            "assets/images/icons/time_remaining_yellow.png",
            height: 34,
            width: 34,
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Time Remaining",
                  style: kwikTextStlye(
                    14.0,
                    FontWeight.w600,
                    colorCodes.rufous,
                  ),
                ),
                CountdownTimer(
                  endTime: endTime,
                  endWidget: const Text('00 : 00 : 00'),
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: colorCodes.rufous,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
