import 'package:flutter/material.dart';
import 'dart:async';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/api/controller/contractsApi/calculate_commodity_cost.dart';
import 'package:kwik_port/api/controller/kwikTickets/create_kwikticket_api.dart';
import 'package:kwik_port/api/model/dashboard_model.dart';
import 'package:kwik_port/api/model/userModel.dart';
import 'package:kwik_port/api/utils/money_util.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/main.dart';
import 'package:kwik_port/ui/home/contracts/kwikticket_created_successfully.dart';
import 'package:kwik_port/ui/home/kwikticket/save_pending_ticket.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:kwik_port/utils/textFields/goods_volume_field.dart';
import 'package:kwik_port/utils/toast.dart';
import 'package:provider/provider.dart';

class GenerateContractTicketDialog extends StatefulWidget {
  final ContractModel contract;
  // final generateFunc;
  const GenerateContractTicketDialog({
    super.key,
    required this.contract,
    // required this.generateFunc,
  });

  @override
  State<GenerateContractTicketDialog> createState() =>
      _GenerateContractTicketDialogState();
}

class _GenerateContractTicketDialogState
    extends State<GenerateContractTicketDialog> {
  late TextEditingController volumeController;
  Timer? _debounce;
  double? totalCost;
  bool isLoading = false;

  void _onVolumeChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 2000), () async {
      final text = volumeController.text.trim();
      if (text.isEmpty) return;

      final units = int.tryParse(text);
      if (units == null || units <= 0) return;

      setState(() {
        isLoading = true;
      });

      final costApi = Provider.of<CalculateCommodityCostApi>(
        context,
        listen: false,
      );

      await costApi.calculateCost(
        commodityId: widget.contract.commodityId ?? "",
        units: units,
      );

      if (!mounted) return;

      setState(() {
        totalCost = costApi.commodityCost?.totalCost?.toDouble() ?? 0.0;
        isLoading = false;
      });

      debugPrint("🧮 Units: $units → Total Cost: ₦$totalCost");
    });
  }

  @override
  void initState() {
    volumeController = TextEditingController(
      // text: "${widget.contract.totalQuantity}",
    );
    volumeController.addListener(_onVolumeChanged);
    // volumeController.addListener(validateVolume);
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    volumeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final costApi = Provider.of<CalculateCommodityCostApi>(
      context,
      listen: false,
    );
    final createTicketApi = Provider.of<CreateKwikticketApi>(
      context,
      listen: false,
    );
    return SizedBox(
      width: 390,
      child: Dialog(
        child: Container(
          height: 550,
          width: 390,
          decoration: BoxDecoration(
            color: colorCodes.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorCodes.antiFlashWhite, width: 1.2),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: Stack(
            children: [
              ListView(
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Generate kwikticket",
                            style: kwikTextStlye(
                              20.0,
                              FontWeight.w600,
                              colorCodes.black,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Image.asset(
                              "assets/images/icons/close-circle.png",
                              height: 24,
                              width: 24,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Image.network(
                        widget.contract.commodityImage ??
                            "https://kwikport.s3.eu-west-3.amazonaws.com/commodity-images/cocoa.png",
                        height: 52,
                        width: 52,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Agricultural Commodity ",
                        style: kwikTextStlye(
                          12.0,
                          FontWeight.w600,
                          colorCodes.graniteGrey,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        widget.contract.commodityName ?? "N/A",
                        style: kwikTextStlye(
                          20.0,
                          FontWeight.w600,
                          colorCodes.black,
                        ),
                      ),
                      SizedBox(height: 16),
                      goodsVolumnFieldColumn(
                        "",
                        volumeController,
                        suffixIcon: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                if (volumeController.text.isNotEmpty) {
                                  setState(() {
                                    volumeController.text =
                                        (double.parse(volumeController.text) + 1.0)
                                            .toString();
                                    print(volumeController.text);
                                  });
                                }
                              },
                              child: Image.asset(
                                "assets/images/icons/arrow-up.png",
                                height: 12,
                                width: 12,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (volumeController.text.isNotEmpty) {
                                  final volume = double.parse(
                                    volumeController.text,
                                  );
                                  if (volume == 1.0) {
                                  } else {
                                    setState(() {
                                      2 - 1;
                                      volumeController.text =
                                          (double.parse(volumeController.text) -
                                                  1.0)
                                              .toString();
                                    });
                                  }
                                }
                              },
                              child: Image.asset(
                                "assets/images/icons/arrow-down.png",
                                height: 12,
                                width: 12,
                              ),
                            ),
                          ],
                        ),
                        onchanged: (value) {
                          _onVolumeChanged();
                        },
                        enabled: !isLoading,
                      ),
                      SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: "",
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: colorCodes.mediumSeaGreen,
                            ),
                            children: [
                              TextSpan(text: " Available: "),
                              TextSpan(
                                text: "${(widget.contract.totalQuantity ?? 0) - (widget.contract.fulfilledQuantity ?? 0)} tons",
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      marketRateContainer(
                        "${MoneyUtils.formatMoney(widget.contract.pricePerUnitInNGN?.toStringAsFixed(2) ?? 'N/A') }",
                        "Total Cost (${volumeController.text}\u00A0tons)",
                        "${MoneyUtils.formatMoney(totalCost?.toStringAsFixed(2) ?? '0')}",
                        volumeController.text,
                      ),
                      SizedBox(height: 24),
                      kwikbutton("Generate Ticket", () async {
                        // Log all properties of userDataVar for debugging
                        debugPrint('userDataVar:');
                        debugPrint('  exporterId: \t\t${userDataVar?.exporterId}');
                        debugPrint('  exporterUniqueId: \t\t${userDataVar?.exporterUniqueId}');
                        debugPrint('  firstName: \t\t${userDataVar?.firstName}');
                        debugPrint('  lastName: \t\t${userDataVar?.lastName}');
                        debugPrint('  otherNames: \t\t${userDataVar?.otherNames}');
                        debugPrint('  email: \t\t${userDataVar?.email}');
                        debugPrint('  phoneNumber: \t\t${userDataVar?.phoneNumber}');
                        debugPrint('  image: \t\t${userDataVar?.image}');
                        debugPrint('  exporter: \t\t${userDataVar?.exporter}');
                        debugPrint('  auth: \t\t${userDataVar?.auth}');

                        if (volumeController.text.isNotEmpty) {
                          await createTicketApi
                              .createKwikTicket(
                                exportContractId: widget.contract.id,
                                exporterId:  userDataVar?.exporterId ?? "",
                                // peggedDollarValue:
                                //     widget.contract.projectedIncome ?? 0.0,
                                // badge: "Gold",
                                // deadline: DateTime.now().add(
                                //   Duration(
                                //     days: widget.contract.contractDuration ?? 0,
                                //   ),
                                // ),
                                kwikTicketAmount: totalCost ?? 0.0,
                                projectedIncomeInDollars:
                                    widget.contract.projectedIncome ?? 0.0,
                                // exporterId: widget.contract.exporterId ?? "N/A",
                              )
                              .then((newTicket) {
                                debugPrint('KwikTicket API response:');
                                debugPrint(newTicket != null ? newTicket.toString() : 'null');
                                if (createTicketApi.isSuccessful == true &&
                                    newTicket != null) {
                                  newTicket.quantityToFulfill = double.tryParse(
                                    volumeController.text,
                                  );
                                  savePendingTicket(newTicket.uniqueId!);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => KwikticketCreatedSuccessfully(
                                            kwikticket: newTicket,
                                          ),
                                    ),
                                  );
                                } else {
                                  showToastContainer(
                                    "Error",
                                    createTicketApi.message,
                                    colorCodes.mistyRose,
                                    colorCodes.portlandOrange,
                                    context,
                                  );
                                }
                              });
                        }

                        currentIndex = 3;
                      }),
                      SizedBox(height: 10),
                    ],
                  ),
                ],
              ),
              if (isLoading)
                Container(
                  color: Colors.white.withOpacity(0.7),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget marketRateContainer(pricePerTon, totalCost, totalCostPrice, volume) {
  return Container(
    height: volume == "" ? 92 : 130,
    width: 352,
    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 16),
    decoration: BoxDecoration(
      color: colorCodes.whiteSmoke,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Image.asset(
              "assets/images/icons/Trending up.png",
              height: 16,
              width: 16,
            ),
            SizedBox(width: 5),
            Text(
              "Current Market Rate",
              style: kwikTextStlye(14.0, FontWeight.w500, colorCodes.black),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Price per ton",
              style: kwikTextStlye(
                12.0,
                FontWeight.w300,
                colorCodes.black,
              ),
            ),
            Text(
              "${(pricePerTon)}",// pricePerTon}",
              style: kwikTextStlye(
                14.0,
                FontWeight.w600,
                colorCodes.black,
                fontFamily: "",
              ),
            ),
          ],
        ),
        volume == "" ? SizedBox() : SizedBox(height: 16),
        volume == ""
            ? SizedBox()
            : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  totalCost,
                  style: kwikTextStlye(
                    12.0,
                    FontWeight.w300,
                    colorCodes.textBlack,
                  ),
                ),
                Text(
                  totalCostPrice,
                  style: kwikTextStlye(
                    14.0,
                    FontWeight.w600,
                    colorCodes.textBlack,
                    fontFamily: "",
                  ),
                ),
              ],
            ),
      ],
    ),
  );
}
