import 'package:flutter/material.dart';
import 'package:kwik_port/api/controller/agency/get_agency_api.dart';
import 'package:kwik_port/api/model/dashboard_model.dart';
import 'package:kwik_port/api/model/export_substage_model.dart';
import 'package:kwik_port/api/utils/money_util.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/home/dashboard/exportJourney/journey_check_list.dart';
import 'package:kwik_port/ui/home/dashboard/procurement%20Agency/agency_container.dart';
import 'package:kwik_port/ui/home/dashboard/procurement%20Agency/agency_details_dialog.dart';
import 'package:kwik_port/ui/home/dashboard/procurement%20Agency/confirm_agency_selection_dialog.dart';
import 'package:kwik_port/utils/button/back_nav_header.dart';
import 'package:kwik_port/utils/button/bottom_navigatior_bar.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:provider/provider.dart';

class ProcurementStageScreen extends StatefulWidget {
  final List<SubStageInfo> substages;
  final KwikTicketModel? kwikticket;
  final String exporterContractId;

  const ProcurementStageScreen({
    super.key,
    required this.substages,
    required this.kwikticket,
    required this.exporterContractId,
  });

  @override
  State<ProcurementStageScreen> createState() => _ProcurementStageScreenState();
}

class _ProcurementStageScreenState extends State<ProcurementStageScreen> {
  @override
  void initState() {
    super.initState();
    final needsAgencySelection = widget.substages.isNotEmpty &&
        widget.substages.first.isCurrent == true &&
        widget.substages.first.isCompleted == false;
    
    if (needsAgencySelection) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final tonnage = widget.kwikticket?.quantityToFulfill?.toInt() ?? 1;
        Provider.of<GetAgencyApi>(context, listen: false)
            .fetchAgenciesByStageType(2, tonnage: tonnage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final agencyProvider = Provider.of<GetAgencyApi>(context);
    final needsAgencySelection = widget.substages.isNotEmpty &&
        widget.substages.first.isCurrent == true &&
        widget.substages.first.isCompleted == false;

    // If agency selection is needed, show only the agency selection UI
    if (needsAgencySelection) {
      return Scaffold(
        backgroundColor: colorCodes.whiteSmoke,
        appBar: AppBar(
          backgroundColor: colorCodes.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colorCodes.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Select Procurement Agency",
            style: kwikTextStlye(18.0, FontWeight.w500, colorCodes.black),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (agencyProvider.loading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (agencyProvider.agencies.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Text('No agencies available.', style: kwikTextStlye(14.0, FontWeight.w400, colorCodes.black)),
                  ),
                )
              else
                ...agencyProvider.agencies.map((agency) {
                  final serviceFeeNGN = agency.serviceFee ?? 0;
                  final serviceFeeUSD = agency.fee?.serviceFeePerTonInUSD ?? agency.serviceFeeInUSD ?? 0;
                  final days = agency.numberOfDaysToDeliver ?? 0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: procurementAgencyContainer(
                      "assets/images/icons/dashboard/procurement_agency_logo.png",
                      agency.name,
                      agency.rating?.toDouble(),
                      MoneyUtils.formatMoney(serviceFeeUSD, symbol: "\$", decimalDigits: 2),
                      MoneyUtils.formatMoney(serviceFeeNGN, symbol: "₦", decimalDigits: 2),
                      "$days days",
                      "${days * 24} hours",
                      "23 reviews",
                      agency,
                      () {
                        showDialog(context: context, builder: (_) => AgencyDetailsDialog(agency: agency));
                      },
                      () {
                        final tonnage = widget.kwikticket?.quantityToFulfill ?? 
                                        widget.kwikticket?.totalQuantity ?? 
                                        widget.kwikticket?.contract?.totalQuantity ?? 
                                        0;
                        final serviceFeePerTon = agency.serviceFeePerTon ?? 0;
                        final serviceFeePerTonUSD = agency.serviceFeePerTonInUSD ?? 0;
                        final totalCostNGN = serviceFeePerTon * tonnage;
                        final totalCostUSD = serviceFeePerTonUSD * tonnage;
                        
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (_) => ConfirmAgencySelectionDialog(
                            serviceFee: MoneyUtils.formatMoney(serviceFeePerTonUSD, symbol: "\$", decimalDigits: 2),
                            totalcostTons: tonnage,
                            totalCost: totalCostNGN,
                            agencyFeeDisplay: MoneyUtils.formatMoney(totalCostUSD, symbol: "\$", decimalDigits: 2),
                            agencyName: agency.name,
                            kwikticket: widget.kwikticket,
                            agencyId: agency.id,
                            agencyType: 2,
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
              const SizedBox(height: 120),
            ],
          ),
        ),
      );
    }

    // Otherwise, show the stage progress screen
    return Scaffold(
      backgroundColor: colorCodes.whiteSmoke,
      appBar: AppBar(
        backgroundColor: colorCodes.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorCodes.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Procurement Stage",
          style: kwikTextStlye(18.0, FontWeight.w500, colorCodes.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stage Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorCodes.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(width: 1.5, color: colorCodes.paleCornflowerBlue),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: colorCodes.paleCornflowerBlue.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text("1", style: kwikTextStlye(18.0, FontWeight.w600, colorCodes.paleCornflowerBlue)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text("Commodity Sourcing", style: kwikTextStlye(18.0, FontWeight.w600, colorCodes.black)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Track the progress of commodity sourcing and procurement for your export contract.",
                    style: kwikTextStlye(14.0, FontWeight.w400, colorCodes.graniteGrey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Substages Section
            Text("Stage Progress", style: kwikTextStlye(16.0, FontWeight.w600, colorCodes.black)),
            const SizedBox(height: 16),
            ...widget.substages.map((substage) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: journeyCheckList(
                substage.subStageName ?? "Unknown",
                substage.isCompleted ?? false,
                substage.isCurrent ?? false,
              ),
            )).toList(),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}
