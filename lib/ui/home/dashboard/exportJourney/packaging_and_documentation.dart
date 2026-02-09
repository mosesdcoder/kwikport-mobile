import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kwik_port/api/controller/agency/export_stage_api.dart';
import 'package:kwik_port/api/controller/agency/get_agency_api.dart';
import 'package:kwik_port/api/controller/agency/selected_agency.dart';
import 'package:kwik_port/api/controller/home/dashboard_api.dart';
import 'package:kwik_port/api/model/dashboard_model.dart';
import 'package:kwik_port/api/utils/money_util.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/home/dashboard/exportJourney/export_journey_screen.dart';
import 'package:kwik_port/ui/home/dashboard/procurement%20Agency/agency_container.dart';
import 'package:kwik_port/ui/home/dashboard/procurement%20Agency/agency_details_dialog.dart';
import 'package:kwik_port/ui/home/dashboard/procurement%20Agency/agency_selection_confirmed_dialog.dart';
import 'package:kwik_port/utils/button/back_nav_header.dart';
import 'package:kwik_port/utils/button/bottom_navigatior_bar.dart';
import 'package:kwik_port/utils/button/loading_dialog.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:provider/provider.dart';

class PackagingAndDocumentation extends StatefulWidget {
  final KwikTicketModel? kwikticket;
  final int stageType;
  final String exporterContractId;
  final ExportSummaryModel exportData;

  const PackagingAndDocumentation({
    super.key,
    required this.kwikticket,
    required this.stageType,
    required this.exporterContractId,
    required this.exportData,
  });

  @override
  State<PackagingAndDocumentation> createState() =>
      _PackagingAndDocumentationState();
}

class _PackagingAndDocumentationState extends State<PackagingAndDocumentation> {
  // ✅ Get stage title based on stageType
  String _getStageTitle() {
    switch (widget.stageType) {
      case 1:
        return "Procurement";
      case 2:
        return "Packaging & Documentation";
      case 3:
        return "Logistics";
      case 4:
        return "Freight Forwarding";
      case 5:
        return "Final Export";
      default:
        return "Agency Selection";
    }
  }

  // ✅ Get agency selection label
  String _getAgencyLabel() {
    switch (widget.stageType) {
      case 1:
        return "Select Procurement Agency";
      case 2:
        return "Select Packaging Agency";
      case 3:
        return "Select Logistics Agency";
      case 4:
        return "Select Freight Forwarding Agency";
      case 5:
        return "Select Final Export Agency";
      default:
        return "Select Agency";
    }
  }

  // ✅ Get info text based on stage
  String _getInfoText() {
    switch (widget.stageType) {
      case 1:
        return "Your gross export earning will be credited to your KwikLC wallet. Agency fees for Procurement will be automatically deducted in USD before withdrawal becomes available.";
      case 2:
        return "Your gross export earning is already credited in your KwikLC wallet. Agency fees for Packaging, Quality & Documentation will be automatically deducted in USD before withdrawal becomes available.";
      case 3:
        return "Your gross export earning is already credited in your KwikLC wallet. Agency fees for Logistics will be automatically deducted in USD before withdrawal becomes available.";
      case 4:
        return "Your gross export earning is already credited in your KwikLC wallet. Agency fees for Freight Forwarding will be automatically deducted in USD before withdrawal becomes available.";
      case 5:
        return "Your gross export earning is already credited in your KwikLC wallet. Agency fees for Final Export will be automatically deducted in USD before withdrawal becomes available.";
      default:
        return "Select an agency to continue your export journey.";
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tonnage = widget.exportData.selectedCapacity?.toInt() ?? 0;

      if (tonnage <= 0) {
        print(
          "❌ Cannot fetch agencies: Invalid tonnage ($tonnage). selectedCapacity: ${widget.exportData.selectedCapacity}",
        );
        return; // ✅ Don't call API if tonnage is 0 or negative
      }

      print("🚚 Fetching agencies with tonnage: $tonnage");
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
              _getStageTitle(),
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      backgroundColor: colorCodes.whiteSmoke,
      body: ListView(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: 100,
        ),
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
                        _getStageTitle(),
                        style: kwikTextStlye(
                          14.0,
                          FontWeight.w600,
                          colorCodes.black,
                        ),
                      ),
                      Text(
                        _getInfoText(),
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
              _getAgencyLabel(),
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
                final serviceFeeInUSD =
                    agency.serviceFeeInUSD?.toString() ?? '0';
                final days = agency.numberOfDaysToDeliver?.toString() ?? '0';

                return procurementAgencyContainer(
                  "assets/images/icons/dashboard/procurement_agency_logo.png",
                  name,
                  rating,
                  MoneyUtils.formatMoney(
                    serviceFeeInUSD,
                    symbol: "\$",
                    decimalDigits: 2,
                  ),
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
                    // Select button - Show confirmation dialog FIRST

                    // ✅ Log values being displayed in the dialog
                    print("==========================================");
                    print("📋 Confirmation Dialog Data:");
                    print("   - Agency Name: ${agency.name}");
                    print("   - serviceFee (Naira): ${agency.serviceFee}");
                    print("   - serviceFeeInUSD: ${agency.serviceFeeInUSD}");
                    print("   - serviceFeeInUSD (variable): $serviceFeeInUSD");
                    print(
                      "   - Formatted USD Fee: ${MoneyUtils.formatMoney(serviceFeeInUSD, symbol: "\$", decimalDigits: 2)}",
                    );
                    print("   - Days: $days");
                    print("   - Stage: ${_getStageTitle()}");
                    print("==========================================");

                    final confirmed = await showDialog<bool>(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 48,
                                  color: colorCodes.yellowOrange,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Confirm Agency Selection',
                                  style: kwikTextStlye(
                                    18.0,
                                    FontWeight.w600,
                                    colorCodes.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Are you sure you want to select ${agency.name} as your agency for ${_getStageTitle()}?',
                                  style: kwikTextStlye(
                                    14.0,
                                    FontWeight.w400,
                                    colorCodes.jetBlack,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: colorCodes.paleCornflowerBlue
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Service Fee:',
                                            style: kwikTextStlye(
                                              12.0,
                                              FontWeight.w500,
                                              colorCodes.jetBlack,
                                            ),
                                          ),
                                          Text(
                                            MoneyUtils.formatMoney(
                                              serviceFeeInUSD,
                                              symbol: "\$",
                                              decimalDigits: 2,
                                            ),
                                            style: kwikTextStlye(
                                              12.0,
                                              FontWeight.w600,
                                              colorCodes.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Delivery Time:',
                                            style: kwikTextStlye(
                                              12.0,
                                              FontWeight.w500,
                                              colorCodes.jetBlack,
                                            ),
                                          ),
                                          Text(
                                            '$days days',
                                            style: kwikTextStlye(
                                              12.0,
                                              FontWeight.w600,
                                              colorCodes.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                            color: colorCodes.graniteGrey,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                        ),
                                        child: Text(
                                          'Cancel',
                                          style: kwikTextStlye(
                                            14.0,
                                            FontWeight.w600,
                                            colorCodes.graniteGrey,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              colorCodes.yellowOrange,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                        ),
                                        child: Text(
                                          'Confirm',
                                          style: kwikTextStlye(
                                            14.0,
                                            FontWeight.w600,
                                            colorCodes.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );

                    // If user cancelled, stop here
                    if (confirmed != true) {
                      print("❌ User cancelled agency selection");
                      return;
                    }

                    // User confirmed, now show loading and call API
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const LoadingDialog();
                        },
                      );
                    }

                    // ✅ Log the payload being sent
                    print("==========================================");
                    print("🚀 Calling select-agency API");
                    print("📋 Payload:");
                    print(
                      "   - exporterContractId: ${widget.exporterContractId}",
                    );
                    print("   - agencyId: ${agency.id}");
                    print("   - stageType: ${widget.stageType}");
                    print("   - Agency Name: ${agency.name}");
                    print("==========================================");

                    await exportStageApi.selectAgency(
                      exporterContractId: widget.exporterContractId,
                      agencyId: agency.id,
                      stageType: widget.stageType,
                    );

                    // Close loading dialog
                    if (context.mounted) {
                      Navigator.pop(context);
                    }

                    // Store selected agency in provider
                    if (context.mounted) {
                      context.read<SelectedAgencyProvider>().setSelectedAgency(
                        agency.id!,
                        agency.name!,
                      );

                      if (exportStageApi.success) {
                        print("✅ Agency selection successful!");

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AgencySelectionConfirmedDialog(
                              kwikticket: widget.kwikticket!,
                              exportData: widget.exportData,
                              serviceFee: MoneyUtils.formatMoney(
                                agency.serviceFeeInUSD ?? 0.0,
                                symbol: "\$",
                                decimalDigits: 2,
                              ),
                              totalcostTons:
                                  "${widget.exportData.selectedCapacity ?? 0} tons",
                              totalCost: MoneyUtils.formatMoney(
                                agency.serviceFeeInUSD ?? 0.0,
                                symbol: "\$",
                                decimalDigits: 2,
                              ),
                              agencyName: agency.name ?? 'Unnamed Agency',
                            );
                          },
                        );
                      } else {
                        print(
                          "❌ Agency selection failed: ${exportStageApi.message}",
                        );

                        // Show error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              exportStageApi.message ??
                                  'Failed to select agency',
                            ),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      }
                    }
                  },
                  context,
                );
              },
            ),
        ],
      ),
      // bottomNavigationBar: const Bottomnavigationbar(1),
    );
  }

  int daysToHours(int days) {
    return days * 24;
  }
}
