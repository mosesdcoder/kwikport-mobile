import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
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
    final amountsone = ["₦10,000", "₦25,000", "₦50,000"];
    final valuesone = ["10000", "25000", "50000"];
    final amountstwo = ["₦100,000", "₦250,000", "₦500,000"];
    final valuestwo = ["100000", "250000", "500000"];
    int selectedIndex = -1;
    final NumberFormat currencyFormat = NumberFormat("#,###");

    return Scaffold(
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 42.0, bottom: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: backNavRow(context, "Fund your wallet"),
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
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 88,

                        width: 390,
                        decoration: BoxDecoration(
                          // color: backgroundColor,
                          borderRadius: BorderRadius.circular(10),

                          gradient: LinearGradient(
                            colors: [
                              HexColor("#243285"),
                              HexColor("#061042"),

                              // colorCodes.eigengrau,
                            ],

                            stops: [0.39, 0.50],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              right: 0,
                              bottom: 1,
                              // left: 1,
                              child: Image.asset(
                                "assets/images/icons/Union (2).png",
                                height: 216,
                                width: 216,
                              ),
                            ),
                            Positioned(
                              child: Image.asset(
                                "assets/images/Group 3016006.png",
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    "assets/images/Group 3016006.png",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12.0,
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 25,
                                      width: 103,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.white24,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.white38,
                                          width: 1.3,
                                        ),
                                      ),
                                      child: Text(
                                        "Current Balance",
                                        style: kwikTextStlye(
                                          10.0,
                                          FontWeight.w500,
                                          colorCodes.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "₦$walletBalance",
                                      style: kwikTextStlye(
                                        20.0,
                                        FontWeight.w600,
                                        colorCodes.white,
                                        fontFamily: "",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20.0),
                      fundWalletColumn(
                        "Enter Amount",
                        "",

                        fundAccountfield,
                        "₦1000",
                        (value) {
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
                        },
                      ),
                      SizedBox(height: 15.0),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Quick Select",
                          style: kwikTextStlye(
                            14.0,
                            FontWeight.w500,
                            colorCodes.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(amountsone.length, (index) {
                          final isSelected = selectedIndex == index;

                          return quickSelectContainer(
                            amountsone[index],
                            isSelected,
                            () {
                              setState(() {
                                selectedIndex = index; // select this one
                              });

                              fundAccountfield.text = valuesone[index];
                            },
                          );
                        }),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(amountstwo.length, (index) {
                          final isSelected = selectedIndex == index;

                          return quickSelectContainer(
                            amountstwo[index],
                            isSelected,
                            () {
                              setState(() {
                                selectedIndex = index; // select this one
                              });

                              fundAccountfield.text = valuestwo[index];
                            },
                          );
                        }),
                      ),

                      SizedBox(height: 34.0),
                      kwikbutton(
                        "Continue",
                        buttonChild: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Continue",
                              style: kwikTextStlye(
                                16.0,
                                FontWeight.w600,
                                colorCodes.white,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.arrow_forward,
                              color: colorCodes.white,
                              size: 16,
                            ),
                          ],
                        ),
                        () async {
                          final parentContext = context;

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
                          showDialog(
                            context: parentContext,
                            barrierDismissible: false,
                            builder: (_) => kwikportloader(),
                          );

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
                              .fundWallet(
                                exporterId: exporterId,
                                amount: amount,
                              )
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
                        },
                      ),
                      SizedBox(height: 30.0),
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
                                    """•  All transactions are secured with encryption
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
                    ],
                  ),
                ],
              ),
    );
  }

  Widget quickSelectContainer(amount, isSelected, selctFunc) {
    return InkWell(
      onTap: selctFunc,
      child: Container(
        height: 35,
        width: 100,
        decoration: BoxDecoration(
          color: colorCodes.white,

          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1.0, color: colorCodes.antiFlashWhite),
        ),
        alignment: Alignment.center,
        child: Text(
          amount,
          style: kwikTextStlye(
            12.0,
            FontWeight.w500,
            colorCodes.black,
            fontFamily: "",
          ),
        ),
      ),
    );
  }
}
