import 'package:flutter/material.dart';
import 'package:kwik_port/api/controller/agency/export_stage_api.dart';
import 'package:kwik_port/api/controller/agency/get_agency_api.dart';
import 'package:kwik_port/api/controller/agency/selected_agency.dart';
import 'package:kwik_port/api/controller/home/dashboard_api.dart';
import 'package:kwik_port/api/model/dashboard_model.dart';
import 'package:kwik_port/api/utils/money_util.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/home/dashboard/exportJourney/current_export_stage_screen.dart';
import 'package:kwik_port/ui/home/dashboard/procurement%20Agency/agency_container.dart';
import 'package:kwik_port/ui/home/dashboard/procurement%20Agency/agency_details_dialog.dart';
import 'package:kwik_port/ui/home/dashboard/procurement%20Agency/agency_selection_confirmed_dialog.dart';
import 'package:kwik_port/utils/button/back_nav_header.dart';
import 'package:kwik_port/utils/button/bottom_navigatior_bar.dart';
import 'package:kwik_port/utils/button/loading_dialog.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:provider/provider.dart';

class FreightForwardingScreen extends StatefulWidget {
  final KwikTicketModel? kwikticket;
  final int stageType;
  final String exporterContractId;
  final ExportSummaryModel exportData;

  const FreightForwardingScreen({
    super.key,
    required this.kwikticket,
    required this.stageType,
    required this.exporterContractId,
    required this.exportData,
  });

  @override
  State<FreightForwardingScreen> createState() => _FreightForwardingScreenState();
}

class _FreightForwardingScreenState extends State<FreightForwardingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tonnage = widget.kwikticket?.quantityToFulfill?.toInt() ?? 1;
      Provider.of<GetAgencyApi>(
        context,
        listen: false,
      ).fetchAgenciesByStageType(widget.stageType, tonnage: tonnage);
    });
  }

  @override
  Widget build(BuildContext context) {
    final agencyApi = Provider.of<GetAgencyApi>(context);
    final exportStageApi = Provider.of<ExportStageApi>(context, listen: false);

    return Scaffold(
      extendBody: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 42.0, bottom: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: backNavRow(
              context,
              "Freight Forwarding",
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      backgroundColor: colorCodes.whiteSmoke,
      body: ListView(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
            decoration: BoxDecoration(
              color: colorCodes.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                width: 1.5,
                color: colorCodes.paleCornflowerBlue,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/images/icons/dashboard/Frame 1000006029.png",
                  height: 20,
                  width: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Freight Forwarding",
                        style: kwikTextStlye(
                          14.0,
                          FontWeight.w600,
                          colorCodes.black,
                        ),
                      ),
                      Text(
                        "Select a reliable freight forwarding agency to manage international shipping and customs clearance. Agency fees will be automatically deducted in USD from your KwikLC wallet.",
                        textAlign: TextAlign.start,
                        style: kwikTextStlye(
                          12.0,
                          FontWeight.w300,
                          colorCodes.jetBlack,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Select Freight Forwarding Agency",
              style: kwikTextStlye(16.0, FontWeight.w600, colorCodes.black),
            ),
          ),
          const SizedBox(height: 20),
          if (agencyApi.loading) 
            const Center(child: CircularProgressIndicator()),
          if (!agencyApi.loading && agencyApi.agencies.isEmpty)
            Center(
              child: Text(
                'No agencies available at the moment.',
                style: kwikTextStlye(14.0, FontWeight.w400, colorCodes.black),
              ),
            ),
          if (!agencyApi.loading && agencyApi.agencies.isNotEmpty)
            ListView.separated(
              itemCount: agencyApi.agencies.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemBuilder: (ctx, index) {
                final agency = agencyApi.agencies[index];
                final name = agency.name ?? 'Unnamed';
                final rating = agency.rating?.toDouble() ?? 0.0;
                final fee = agency.serviceFee?.toString() ?? '0';
                final serviceFeeInUSD = agency.serviceFeeInUSD?.toString() ?? '0';
                final days = agency.numberOfDaysToDeliver?.toString() ?? '0';

                return procurementAgencyContainer(
                  "assets/images/icons/dashboard/procurement_agency_logo.png",
                  name,
                  rating,
                  MoneyUtils.formatMoney(serviceFeeInUSD, symbol: "\$", decimalDigits: 2),
                  MoneyUtils.formatMoney(fee, symbol: "₦", decimalDigits: 2),
                  "$days days",
                  "${daysToHours(int.tryParse(days) ?? 0)} hours",
                  "23 reviews",
                  agency,
                  () {
                    // View Details button
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AgencyDetailsDialog(agency: agency);
                      },
                    );
                  },
                  () async {
                    // Select button
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const LoadingDialog();
                      },
                    );

                    await exportStageApi.selectAgency(
                      exporterContractId: widget.exporterContractId,
                      agencyId: agency.id,
                      stageType: widget.stageType,
                    );

                    if (context.mounted) {
                      context
                          .read<SelectedAgencyProvider>()
                          .setSelectedAgency(agency.id!, agency.name!);
                      Navigator.pop(context);

                      if (exportStageApi.success) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AgencySelectionConfirmedDialog(
                              kwikticket: widget.kwikticket!,
                              exportData: widget.exportData,
                              serviceFee: MoneyUtils.formatMoney(serviceFeeInUSD, symbol: "\$", decimalDigits: 2),
                              totalcostTons: "${widget.kwikticket?.totalQuantity ?? '0'} tons",
                              totalCost: "₦${widget.kwikticket?.kwikTicketAmount ?? '0'}",
                              agencyName: agency.name ?? 'Unnamed Agency',
                            );
                          },
                        );
                      }
                    }
                  },
                );
              },
            ),
        ],
      ),
      bottomNavigationBar: const Bottomnavigationbar(1),
    );
  }

  int daysToHours(int days) {
    return days * 24;
  }
}
