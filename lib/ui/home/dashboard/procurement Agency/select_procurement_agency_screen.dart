import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/api/controller/agency/get_agency_api.dart';
import 'package:kwik_port/api/model/dashboard_model.dart';
import 'package:kwik_port/api/utils/money_util.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/home/dashboard/procurement%20Agency/agency_container.dart';
import 'package:kwik_port/ui/home/dashboard/procurement%20Agency/agency_details_dialog.dart';
import 'package:kwik_port/ui/home/dashboard/procurement%20Agency/confirm_agency_selection_dialog.dart';
import 'package:kwik_port/utils/button/back_nav_header.dart';
import 'package:kwik_port/utils/button/bottom_navigatior_bar.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectProcurementAgencyScreen extends StatefulWidget {
  final KwikTicketModel? kwikticket;
  final int agencyType;

  const SelectProcurementAgencyScreen({
    super.key,
    required this.kwikticket,
    this.agencyType = 1,
  });

  @override
  State<SelectProcurementAgencyScreen> createState() =>
      _SelectProcurementAgencyScreenState();
}

class _SelectProcurementAgencyScreenState
    extends State<SelectProcurementAgencyScreen> {
  final ScrollController _scrollController = ScrollController();
  int endTime = DateTime.now().millisecondsSinceEpoch;

  @override
  void initState() {
    super.initState();

    debugPrint('🎬 SelectProcurementAgencyScreen initialized');
    debugPrint('  - AgencyType: ${widget.agencyType}');
    debugPrint('  - KwikTicket exists: ${widget.kwikticket != null}');
    debugPrint('  - KwikTicket ID: ${widget.kwikticket?.id}');
    
    if (widget.kwikticket != null) {
      debugPrint('  - quantityToFulfill: ${widget.kwikticket!.quantityToFulfill}');
      debugPrint('  - totalQuantity: ${widget.kwikticket!.totalQuantity}');
      debugPrint('  - contract exists: ${widget.kwikticket!.contract != null}');
      if (widget.kwikticket!.contract != null) {
        debugPrint('  - contract.totalQuantity: ${widget.kwikticket!.contract!.totalQuantity}');
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      final savedExportId = prefs.getString('activeExportContractId');
      final currentExportId = widget.kwikticket?.exportContractId;

      if (savedExportId == null || savedExportId != currentExportId) {
        await prefs.remove('procurementStartTime');
      }

      await prefs.setString('activeExportContractId', currentExportId ?? '');

      final startTime =
          prefs.getInt('procurementStartTime') ??
          DateTime.now().millisecondsSinceEpoch;

      await prefs.setInt('procurementStartTime', startTime);

      setState(() {
        endTime = startTime + const Duration(hours: 24).inMilliseconds;
      });

      _fetchInitialAgency();
    });

    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final agencyApi = Provider.of<GetAgencyApi>(context, listen: false);

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!agencyApi.loading && agencyApi.hasMore) {
        final tonnage = _getTonnage();
        if (tonnage == null) {
          _showTonnageError();
          return;
        }
        agencyApi.fetchAgencies(
          tonnage: tonnage,
          agencyType: widget.agencyType,
          loadMore: true,
        );
      }
    }
  }

  Future<void> _fetchInitialAgency() async {
    debugPrint('📡 _fetchInitialAgency called');
    
    final agencyApi = Provider.of<GetAgencyApi>(context, listen: false);
    final tonnage = _getTonnage();
    
    debugPrint('  - Tonnage for API call: $tonnage');
    
    if (tonnage == null) {
      debugPrint('  ❌ Tonnage is null, showing error');
      _showTonnageError();
      return;
    }
    
    debugPrint('  ✅ Fetching agencies with tonnage: $tonnage, agencyType: ${widget.agencyType}');
    await agencyApi.fetchAgenciesByStageType(widget.agencyType, tonnage: tonnage);
    debugPrint('  - Fetch completed. Agencies count: ${agencyApi.agencies.length}');
  }

  Future<void> _refresh() async {
    final agencyApi = Provider.of<GetAgencyApi>(context, listen: false);
    final tonnage = _getTonnage();
    if (tonnage == null) {
      _showTonnageError();
      return;
    }
    await agencyApi.fetchAgenciesByStageType(widget.agencyType, tonnage: tonnage);
  }

  int? _getTonnage() {
    // Try multiple sources for tonnage with fallbacks
    final quantityToFulfill = widget.kwikticket?.quantityToFulfill;
    final totalQuantity = widget.kwikticket?.totalQuantity;
    final contractQuantity = widget.kwikticket?.contract?.totalQuantity;

    debugPrint('🔢 Tonnage calculation:');
    debugPrint('  - quantityToFulfill: $quantityToFulfill');
    debugPrint('  - totalQuantity: $totalQuantity');
    debugPrint('  - contract.totalQuantity: $contractQuantity');

    // Find the first non-null and non-zero value
    final tonnage = (quantityToFulfill != null && quantityToFulfill > 0)
        ? quantityToFulfill.toInt()
        : (totalQuantity != null && totalQuantity > 0)
            ? totalQuantity.toInt()
            : (contractQuantity != null && contractQuantity > 0)
                ? contractQuantity.toInt()
                : null;

    debugPrint('  - Final tonnage used: $tonnage');

    return tonnage;
  }

  void _showTonnageError() {
    debugPrint('⚠️ Showing tonnage error snackbar');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: Unable to determine tonnage for agency calculation'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final agencyProvider = Provider.of<GetAgencyApi>(context);
    
    debugPrint('🎨 Build called - loading: ${agencyProvider.loading}, agencies: ${agencyProvider.agencies.length}');

    if (agencyProvider.loading && agencyProvider.agencies.isEmpty) {
      return Scaffold(
        backgroundColor: colorCodes.whiteSmoke,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(85),
          child: AppBar(
            backgroundColor: colorCodes.whiteSmoke,
            elevation: 0,
            automaticallyImplyLeading: false,
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(left: 20, top: 42, bottom: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: backNavRow(
                  context,
                  "Select Agency",
                  fontSize: 18.0,
                  imgsize: 36.0,
                ),
              ),
            ),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    debugPrint('  ✅ Rendering full screen with ${agencyProvider.agencies.length} agencies');

    return Scaffold(
      backgroundColor: colorCodes.whiteSmoke,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85),
        child: AppBar(
          backgroundColor: colorCodes.whiteSmoke,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(left: 20, top: 42, bottom: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: backNavRow(
                context,
                "Select Agency",
                fontSize: 18.0,
                imgsize: 36.0,
              ),
            ),
          ),
        ),
      ),

      body: RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                  itemCount: agencyProvider.agencies.length + 5,
                  itemBuilder: (context, index) {
                    debugPrint('  📦 Building item $index of ${agencyProvider.agencies.length + 5}');
                    if (index == 0) {
                      debugPrint('    ➡️ Showing header');
                      return Column(
                        children: [
                          Center(
                            child: Image.asset(
                              "assets/images/icons/procuement_select_check.png",
                              height: 96,
                              width: 113,
                            ),
                          ),
                          const SizedBox(height: 31),
                          Text(
                            "Choose an agency\nfor your export contract",
                            textAlign: TextAlign.center,
                            style: kwikTextStlye(
                              18.0,
                              FontWeight.w600,
                              colorCodes.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Your selection will be locked in 24 hours.",
                            textAlign: TextAlign.center,
                            style: kwikTextStlye(
                              14.0,
                              FontWeight.w300,
                              colorCodes.graniteGrey,
                            ),
                          ),
                          const SizedBox(height: 17),
                        ],
                      );
                    }

                    if (index == 1) {
                      debugPrint('    ➡️ Showing infoBox');
                      try {
                        return _infoBox();
                      } catch (e, stack) {
                        debugPrint('    ❌ Error in _infoBox: $e');
                        debugPrint('    Stack: $stack');
                        return SizedBox(height: 100, child: Center(child: Text('Error in infoBox: $e')));
                      }
                    }
                    if (index == 2) {
                      debugPrint('    ➡️ Showing spacer 1');
                      return const SizedBox(height: 20);
                    }
                    if (index == 3) {
                      debugPrint('    ➡️ Showing timerBox');
                      try {
                        return _timerBox();
                      } catch (e, stack) {
                        debugPrint('    ❌ Error in _timerBox: $e');
                        debugPrint('    Stack: $stack');
                        return SizedBox(height: 100, child: Center(child: Text('Error in timerBox: $e')));
                      }
                    }
                    if (index == 4) {
                      debugPrint('    ➡️ Showing spacer 2');
                      return const SizedBox(height: 20);
                    }

                    final agencyIndex = index - 5;
                    debugPrint('    ➡️ Agency index: $agencyIndex');

                    if (agencyIndex >= agencyProvider.agencies.length) {
                      debugPrint('    ⚠️ AgencyIndex $agencyIndex >= agencies.length ${agencyProvider.agencies.length}');
                      return const SizedBox.shrink();
                    }

                    final agency = agencyProvider.agencies[agencyIndex];
                    debugPrint('    ✅ Rendering agency: ${agency.name}');
                    final serviceFeeNGN = agency.serviceFeePerTon ?? agency.serviceFee ?? 0;
                    final serviceFeeUSD =
                        agency.serviceFeePerTonInUSD ??
                        agency.serviceFeeInUSD ??
                        0;
                    final days = agency.numberOfDaysToDeliver ?? 0;
                    debugPrint(
                      'Rendering agency=${agency.name} serviceFeeUSD=$serviceFeeUSD serviceFeeNGN=$serviceFeeNGN',
                    );
                    final rating = agency.rating?.toDouble();

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: procurementAgencyContainer(
                        "assets/images/icons/dashboard/procurement_agency_logo.png",
                        agency.name,
                        agency.rating?.toDouble(),
                        MoneyUtils.formatMoney(serviceFeeUSD, symbol: "\$"),
                        MoneyUtils.formatMoney(
                          serviceFeeNGN,
                          symbol: "₦",
                          decimalDigits: 2,
                        ),
                        "$days days",
                        "${days * 24} hours",
                        rating != null
                            ? "${rating.toStringAsFixed(1)} stars"
                            : "No rating",
                        agency,
                        () {
                          showDialog(
                            context: context,
                            builder: (_) => AgencyDetailsDialog(agency: agency),
                          );
                        },
                        () {
                          debugPrint('🚀 SELECT BUTTON CLICKED for ${agency.name}');
                          
                          // Get tonnage from kwikticket with fallbacks
                          debugPrint('🔍 Checking kwikticket for tonnage:');
                          debugPrint('  - kwikticket exists: ${widget.kwikticket != null}');
                          debugPrint('  - quantityToFulfill: ${widget.kwikticket?.quantityToFulfill}');
                          debugPrint('  - totalQuantity: ${widget.kwikticket?.totalQuantity}');
                          debugPrint('  - contract exists: ${widget.kwikticket?.contract != null}');
                          debugPrint('  - contract.totalQuantity: ${widget.kwikticket?.contract?.totalQuantity}');
                          
                          final tonnage = widget.kwikticket?.quantityToFulfill ?? 
                                          widget.kwikticket?.totalQuantity ?? 
                                          widget.kwikticket?.contract?.totalQuantity ?? 
                                          0;
                          
                          // Calculate total cost based on tonnage
                          final serviceFeePerTon = agency.serviceFeePerTon ?? 0;
                          final serviceFeePerTonUSD = agency.serviceFeePerTonInUSD ?? 0;
                          final totalCostNGN = serviceFeePerTon * tonnage;
                          final totalCostUSD = serviceFeePerTonUSD * tonnage;
                          
                          debugPrint('🧮 Calculation for ${agency.name}:');
                          debugPrint('  - Tonnage: $tonnage');
                          debugPrint('  - Service fee per ton (NGN): $serviceFeePerTon');
                          debugPrint('  - Service fee per ton (USD): $serviceFeePerTonUSD');
                          debugPrint('  - Total cost (NGN): $totalCostNGN');
                          debugPrint('  - Total cost (USD): $totalCostUSD');
                          
                          final formattedServiceFee = MoneyUtils.formatMoney(
                            serviceFeePerTonUSD,
                            symbol: "\$",
                            decimalDigits: 2,
                          );
                          final formattedAgencyFee = MoneyUtils.formatMoney(
                            totalCostUSD,
                            symbol: "\$",
                            decimalDigits: 2,
                          );
                          
                          debugPrint('📦 Passing to Dialog:');
                          debugPrint('  - serviceFee: $formattedServiceFee');
                          debugPrint('  - totalcostTons: $tonnage');
                          debugPrint('  - totalCost: $totalCostNGN');
                          debugPrint('  - agencyFeeDisplay: $formattedAgencyFee');
                          debugPrint('  - agencyType: ${widget.agencyType}');
                          
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder:
                                (_) => ConfirmAgencySelectionDialog(
                                  serviceFee: formattedServiceFee,
                                  totalcostTons: tonnage,
                                  totalCost: totalCostNGN,
                                  agencyFeeDisplay: formattedAgencyFee,
                                  agencyName: agency.name,
                                  kwikticket: widget.kwikticket,
                                  agencyId: agency.id,
                                  agencyType: widget.agencyType,
                                ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

      //bottomNavigationBar: Bottomnavigationbar(1),
    );
  }

  Widget _infoBox() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: HexColor("#D0E1FB").withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 1.5, color: colorCodes.paleCornflowerBlue),
      ),
      child: Row(
        children: [
          Image.asset("assets/images/icons/blue_info.png", height: 25),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Agency fees will be deducted in USD from your KwikLC wallet.",
              style: kwikTextStlye(12.0, FontWeight.w400, colorCodes.bluetiful),
            ),
          ),
        ],
      ),
    );
  }

  Widget _timerBox() {
    return Container(
      padding: const EdgeInsets.all(15),
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
          ),
          const SizedBox(width: 10),
          Expanded(
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
                  endWidget: const Text("00 : 00 : 00"),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
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
