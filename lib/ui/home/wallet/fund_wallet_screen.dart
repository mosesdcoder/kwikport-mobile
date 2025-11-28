import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kwik_port/api/controller/fund_wallet_api.dart';
import 'package:kwik_port/api/controller/home/dashboard_api.dart';
import 'package:kwik_port/api/controller/verify_fund_payment.dart';
import 'package:kwik_port/api/utils/loader.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/home/wallet/fund_wallet_confirmed.dart';
import 'package:kwik_port/utils/button/back_nav_header.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/button/loading_dialog.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:kwik_port/utils/textFields/und_tetfield.dart';
import 'package:kwik_port/utils/toast.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FundWalletScreen extends StatefulWidget {
  const FundWalletScreen({super.key});

  @override
  State<FundWalletScreen> createState() => _FundWalletScreenState();
}

class _FundWalletScreenState extends State<FundWalletScreen> {
  TextEditingController fundAccountfield = TextEditingController();
  late WebViewController _controller;
  bool showWebView = false;
  bool _isLoading = true;

  Future<void> _verifyPayment(String exporterId, String reference) async {
    final fundTicketApi = Provider.of<FundWalletApi>(context, listen: false);
    debugPrint("🔍 Verifying payment for $exporterId with ref $reference");

    final verifyApi = Provider.of<VerifyFundPayment>(context, listen: false);

    setState(() => _isLoading = true);

    await verifyApi.verifyFundPayment(
      exporterId: exporterId,
      referenceNumber: reference,
    );

    setState(() => _isLoading = false);

    if (verifyApi.isSuccessful == true) {
      print("Payment verified successfully ${verifyApi.message}");
      print("Payment status: ${verifyApi.status}");

      Provider.of<DashboardApi>(context, listen: false).fetchDashboard();

      if (mounted) {
        showToastContainer(
          "Payment Successful",
          verifyApi.message,
          colorCodes.pigmentGreen,
          colorCodes.mediumSeaGreen,
          context,
        );
        final now = DateTime.now();
        final formattedDateTime =
            "${now.day}-${now.month}-${now.year} ${now.hour}:${now.minute}";

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (_) => FundWalletConfirmed(
                  amountFunded: fundAccountfield.text.replaceAll(",", ""),
                  referenceNumber: fundTicketApi.paymentReference!,
                  dateTime: formattedDateTime.toString(),
                  // amountPaid:widget.,
                  paymentMethod: fundTicketApi.provider!,
                ),
          ),
        );
      }
    } else {
      // ❌ Payment failed
      if (mounted) {
        showToastContainer(
          "Payment Failed",
          verifyApi.message,
          colorCodes.mistyRose,
          colorCodes.portlandOrange,
          context,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardApi = Provider.of<DashboardApi>(context);
    final fundWalletApi = Provider.of<FundWalletApi>(context);
    final isLoading = dashboardApi.loading;
    final walletBalance = dashboardApi.data?.walletBalance ?? 0.0;
    
    final NumberFormat currencyFormat = NumberFormat("#,###");

    return Scaffold(
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 42.0, bottom: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: backNavRow(context, "Fund Wallet"),
          ),
        ),
      ),
      backgroundColor: colorCodes.whiteSmoke,
      body:
          (showWebView)
              ? Stack(
                children: [
                  if (_controller != null)
                    WebViewWidget(controller: _controller)
                  else
                    const Center(child: CircularProgressIndicator()),

                  if (_isLoading)
                    const Center(child: CircularProgressIndicator()),
                ],
              )
              : ListView(
                shrinkWrap: true,
                physics: RangeMaintainingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 50.0),
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 35.0),
                      Container(
                        height: 130,
                        width: 342,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: colorCodes.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            width: 1.5,
                            color: colorCodes.paleCornflowerBlue,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/images/icons/dashboard/Frame 1000006029.png",
                              height: 20,
                              width: 20,
                            ),
                            SizedBox(width: 5),
                            SizedBox(
                              width: 240,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Funding Tips",
                                    style: kwikTextStlye(
                                      14.0,
                                      FontWeight.w600,
                                      colorCodes.black,
                                    ),
                                  ),
                                  Text(
                                    """• All transactions are secured with bank-level encryption
• Minimum funding amount is ₦1,000
• No fees for bank transfers
• Funds reflect instantly in your wallet""",
                                    textAlign: TextAlign.start,
                                    style: kwikTextStlye(
                                      12.0,
                                      FontWeight.w300,
                                      colorCodes.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 55.0),
                      Text(
                        "Enter Amount",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: colorCodes.bluetiful,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      fundTextfield(fundAccountfield, "", (value) {
                        // Remove commas
                        String numericValue = value.replaceAll(",", "");

                        if (numericValue.isEmpty) {
                          fundAccountfield.value = TextEditingValue(
                            text: "",
                            selection: TextSelection.collapsed(offset: 0),
                          );
                          return;
                        }

                        // Format with commas
                        final newValue = currencyFormat.format(
                          int.parse(numericValue),
                        );

                        fundAccountfield.value = TextEditingValue(
                          text: newValue,
                          selection: TextSelection.collapsed(
                            offset: newValue.length,
                          ),
                        );
                      }),

                      SizedBox(height: 110.0),
                      kwikbutton("Continue", () async {
                        final parentContext = context;
                        showDialog(
                          context: parentContext,
                          barrierDismissible: false,
                          builder: (_) => kwikportloader(),
                        );
                        if (fundAccountfield.text.isEmpty) {
                          showToastContainer(
                            "Error",
                            "Please enter an amount",
                            colorCodes.sunset,
                            colorCodes.white,
                            context,
                          );
                          return;
                        }

                        final amount = double.parse(
                          fundAccountfield.text.replaceAll(",", ""),
                        );
                        final dashboardApi = Provider.of<DashboardApi>(
                          context,
                          listen: false,
                        );
                        final exporterId =
                            dashboardApi.data?.userProfile?.exporterId ?? "";
                        await fundWalletApi
                            .fundWallet(exporterId: exporterId, amount: amount)
                            .then((_) {
                              Navigator.pop(context);
                              _controller =
                                  WebViewController()
                                    ..setJavaScriptMode(
                                      JavaScriptMode.unrestricted,
                                    )
                                    ..setNavigationDelegate(
                                      NavigationDelegate(
                                        // },
                                        onPageStarted: (url) {
                                          setState(() => _isLoading = true);

                                          // final uri = Uri.parse(url);
                                          final uri = Uri.parse(url);
                                          final reference =
                                              uri.queryParameters["reference"] ??
                                              "";
                                          if (reference.isNotEmpty) {
                                            _verifyPayment(
                                              exporterId,
                                              fundWalletApi.paymentReference!,
                                            );
                                          } else {}
                                        },
                                        onPageFinished: (url) {
                                          debugPrint(
                                            "✅ Finished loading: $url",
                                          );

                                          setState(() => _isLoading = false);
                                        },
                                      ),
                                    )
                                    ..loadRequest(
                                      Uri.parse(
                                        fundWalletApi.authorizationUrl!,
                                      ),
                                    );
                              setState(() {
                                showWebView = true;
                              });
                            });
                      }),
                    ],
                  ),
                ],
              ),
    );
  }
}
