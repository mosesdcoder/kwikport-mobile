import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:kwik_port/api/controller/home/dashboard_api.dart';
import 'package:kwik_port/api/controller/kwikTickets/fund_ticket_api.dart';
import 'package:kwik_port/api/controller/kwikTickets/update_kwikticket_status_api.dart';
import 'package:kwik_port/api/controller/kwikTickets/verify_payment.dart';
import 'package:kwik_port/api/model/dashboard_model.dart';
import 'package:kwik_port/api/utils/money_util.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/home/exportfulfillment/KycVerification/export_payment_confirmed.dart';
import 'package:kwik_port/ui/home/exportfulfillment/KycVerification/export_payment_containers.dart';
import 'package:kwik_port/ui/home/kwikticket/save_pending_ticket.dart';
import 'package:kwik_port/utils/button/back_nav_header.dart';
import 'package:kwik_port/utils/button/bottom_navigatior_bar.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/button/loading_dialog.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:kwik_port/utils/textFields/date_of_birth_field.dart';
import 'package:kwik_port/utils/textFields/nameField_column.dart';
import 'package:kwik_port/utils/textFields/phoneNumber_field.dart';
import 'package:kwik_port/utils/toast.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FundExportContract extends StatefulWidget {
  // final String url;
  final String kwikTicketId;
  // final String referenceNumber;
  final KwikTicketModel kwikticket;
  // final String paymentMethod;

  const FundExportContract({
    super.key,
    required this.kwikticket,
    // required this.url,
    required this.kwikTicketId,
    // required this.referenceNumber,
    // required this.paymentMethod,
  });

  @override
  State<FundExportContract> createState() => _FundExportContractState();
}

class _FundExportContractState extends State<FundExportContract> {
  bool selectKwikBalance = false;
  bool selectCardTransfer = false;
  bool selectBankTransfer = false;
  bool checkterms = false;
  TextEditingController cardHolderNamecontroller = TextEditingController();
  TextEditingController expDateController = TextEditingController();
  TextEditingController cvvcontroller = TextEditingController();
  TextEditingController cardnumbercontroller = TextEditingController();
  bool _isVisible = false;
  late WebViewController _controller;
  bool _isLoading = true;
  bool showWebView = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController();
  }

  Future<void> _verifyPayment(String ticketId, String reference) async {
    final fundTicketApi = Provider.of<FundKwikticketApi>(
      context,
      listen: false,
    );
    debugPrint("🔍 Verifying payment for $ticketId with ref $reference");

    final verifyApi = Provider.of<VerifyPaymentApi>(context, listen: false);

    setState(() => _isLoading = true);

    await verifyApi.verifyPayment(
      kwikTicketId: ticketId,
      referenceNumber: reference,
    );

    setState(() => _isLoading = false);

    if (verifyApi.isSuccessful == true) {
      print("Payment verified successfully ${verifyApi.message}");
      print("Payment status: ${verifyApi.status}");
      // final dashboardApi = Provider.of<DashboardApi>(context, listen: false);
      // await dashboardApi.fetchDashboard();
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
                (_) => ExportPaymentConfirmed(
                  kwikticket: widget.kwikticket,
                  referenceNumber: fundTicketApi.paymentReference!,
                  dateTime: formattedDateTime.toString(),
                  // amountPaid:widget.,
                  paymentMethod: fundTicketApi.provider!,
                  // exportData: export,
                ),
          ),
        );
        await clearPendingTicket();
      }
    } else {
      // ❌ Payment failed
      if (mounted) {
        setState(() {
          showWebView = false;
        });
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
  Widget build(BuildContext context) {
    final dashboardApi = Provider.of<DashboardApi>(context, listen: false);
    // final export = dashboardApi.data?.exports.firstWhere(
    //   (e) => e.contractId == exportContractId,
    //   orElse: () => throw Exception("Export not found"),
    // );
    final fundTicketApi = Provider.of<FundKwikticketApi>(
      context,
      listen: false,
    );
    return Scaffold(
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 42.0, bottom: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: backNavRow(
              context,
              "Fund your export contract",
              fontSize: 20.0,
            ),
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
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 40,
                  bottom: 65,
                ),
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 375,
                        width: 393,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          color: colorCodes.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "assets/images/icons/dashboard/Frame 1000006029 (3).png",
                                  height: 25,
                                  width: 25,
                                ),
                                SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Payment Summary",
                                      style: kwikTextStlye(
                                        14.0,
                                        FontWeight.w600,
                                        colorCodes.black,
                                      ),
                                    ),
                                    Text(
                                      widget.kwikticket.contract!.contractId,
                                      style: kwikTextStlye(
                                        14.0,
                                        FontWeight.w500,
                                        colorCodes.graniteGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              width: 353,
                              child: Divider(
                                color: colorCodes.gainsboro,
                                thickness: 1.1,
                              ),
                            ),
                            SizedBox(height: 11),
                            detailRow(
                              "Procurement amount",
                              "${MoneyUtils.formatMoney(widget.kwikticket.kwikTicketAmount)}",
                              // "₦${widget.kwikticket.kwikTicketAmount}",
                            ),
                            SizedBox(height: 11),
                            // detailRow("Platform fee", "#49,000"),
                            SizedBox(height: 11),
                            SizedBox(
                              width: 353,
                              child: Divider(
                                color: colorCodes.gainsboro,
                                thickness: 1.1,
                              ),
                            ),
                            SizedBox(height: 8),
                            // detailRow(
                            //   "Total to pay",
                            //   "${MoneyUtils.formatMoney(widget.kwikticket.kwikTicketAmount)}",
                            //   // "#${widget.kwikticket.kwikTicketAmount}",
                            //   fontSize: 14.0,
                            //   fontWeight: FontWeight.w600,
                            //   color: colorCodes.black,
                            //   fontsizetwo: 14.0,
                            //   fontWeighttwo: FontWeight.w600,
                            //   colortwo: colorCodes.azureBlue,
                            // ),
                            SizedBox(height: 30),
                            Container(
                              height: 90,
                              width: 352,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: colorCodes.mintCream,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  width: 1.5,
                                  color: colorCodes.aeroBlue,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/icons/dashboard/Frame 10000060299.png",
                                            height: 20,
                                            width: 20,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            "Projected Earnings",
                                            style: kwikTextStlye(
                                              12.0,
                                              FontWeight.w600,
                                              colorCodes.pigmentGreen,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "${MoneyUtils.formatMoney(widget.kwikticket.projectedIncomeInDollars, symbol: "\$", decimalDigits: 2)}",
                                        textAlign: TextAlign.start,
                                        style: kwikTextStlye(
                                          12.0,
                                          FontWeight.w600,
                                          colorCodes.pigmentGreen,
                                          fontFamily: "",
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),

                                  Text(
                                    "Estimated return on successful completion",
                                    style: kwikTextStlye(
                                      10.0,
                                      FontWeight.w500,
                                      colorCodes.mediumSeaGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Select Payment Method",
                          style: kwikTextStlye(
                            14.0,
                            FontWeight.w500,
                            colorCodes.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      paymentContainer(
                        "Kwik Balance",
                        "Available: ${MoneyUtils.formatMoney(dashboardApi.data?.walletBalance ?? 0.0)}",
                        selectKwikBalance,
                        () {
                          setState(() {
                            selectKwikBalance = true;
                            selectCardTransfer = false;
                            selectBankTransfer = false;
                          });
                        },
                        subtitlefontweight: FontWeight.w500,
                        subtitlecolor: colorCodes.pigmentGreen,
                      ),
                      SizedBox(height: 12),
                      paymentContainer(
                        "Direct funding",
                        "Visa, MasterCard, Transfer",

                        selectCardTransfer,
                        () {
                          setState(() {
                            selectCardTransfer = true;
                            selectKwikBalance = false;

                            selectBankTransfer = false;
                          });
                        },
                      ),

                      SizedBox(height: 12),

                      SizedBox(height: 20),
                      Container(
                        height: 100,
                        width: 390,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: colorCodes.mintCream,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            width: 1.5,
                            color: colorCodes.aeroBlue,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              selectBankTransfer == true
                                  ? "assets/images/icons/dashboard/check_shield.png"
                                  : "assets/images/icons/greenshipment.png",
                              height: 20,
                              width: 20,
                            ),
                            SizedBox(width: 8),
                            SizedBox(
                              width: 270,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    selectBankTransfer == true
                                        ? "256-bit SSL Encryption"
                                        : "Secure Payment",
                                    style: kwikTextStlye(
                                      14.0,
                                      FontWeight.w600,
                                      colorCodes.pigmentGreen,
                                    ),
                                  ),
                                  Text(
                                    selectBankTransfer == true
                                        ? "Your payment information is protected with bank-level security and PCI DSS compliance"
                                        : "Your payment is protected with 256-bit SSL encryption and PCI DSS compliance.",
                                    style: kwikTextStlye(
                                      12.0,
                                      FontWeight.w300,
                                      colorCodes.pigmentGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      selectBankTransfer == true
                          ? SizedBox(height: 20)
                          : SizedBox(width: 1),
                      selectBankTransfer == true
                          ? Container(
                            height: 100,
                            width: 390,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: colorCodes.mintCream,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                width: 1.5,
                                color: colorCodes.aeroBlue,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "assets/images/icons/Frame 1000006029 (4).png",
                                  height: 20,
                                  width: 20,
                                ),
                                SizedBox(width: 8),
                                SizedBox(
                                  width: 270,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Transaction Guarantee ",
                                        style: kwikTextStlye(
                                          14.0,
                                          FontWeight.w600,
                                          colorCodes.black,
                                        ),
                                      ),
                                      Text(
                                        "Your funds are secured and will only be released upon successful contract completion or refunded as per terms.",
                                        style: kwikTextStlye(
                                          12.0,
                                          FontWeight.w300,
                                          colorCodes.aluminium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                          : Container(),
                      SizedBox(height: 30),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                checkterms = !checkterms;
                              });
                            },
                            child:
                                checkterms == true
                                    ? Image.asset(
                                      "assets/images/icons/dashboard/Checkbox (1).png",
                                      height: 25,
                                      width: 25,
                                    )
                                    : Container(
                                      height: 20,
                                      width: 20,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: colorCodes.frenchSkyBlue,
                                          width: 1.5,
                                        ),

                                        color: colorCodes.white,
                                        borderRadius: BorderRadius.circular(
                                          6,
                                        ), // rounded corners
                                      ),
                                    ),
                          ),
                          SizedBox(width: 5),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 100,
                            child: RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w300,
                                  color: colorCodes.black,
                                ),
                                children: [
                                  TextSpan(text: "I agree to the "),
                                  TextSpan(
                                    text: "Terms and Conditions. ",
                                    style: TextStyle(
                                      color: colorCodes.azureBlue,
                                    ),
                                  ),
                                  TextSpan(text: "and "),
                                  TextSpan(
                                    text: "Privacy Policy.",
                                    style: TextStyle(
                                      color: colorCodes.azureBlue,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        " I understand that this payment will fund my export contract and acknowledge the associated risks and returns.",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                      kwikbutton(
                        "Pay ${MoneyUtils.formatMoney(widget.kwikticket.kwikTicketAmount)}",
                        () async {
                          if (checkterms == false) {
                            showToastContainer(
                              "Terms not accepted",
                              "Please agree to the terms and conditions to proceed.",
                              colorCodes.mistyRose,
                              colorCodes.portlandOrange,
                              context,
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return LoadingDialog();
                              },
                            );
                            if (selectKwikBalance == true) {
                              await fundTicketApi
                                  .fundTicket(
                                    kwikTicketId: widget.kwikticket.id,
                                    exporterId:
                                        widget.kwikticket.exporter?.id ?? "",
                                    fundingMethod: 1,
                                  )
                                  .then((_) {
                                    Navigator.pop(context);

                                    if (fundTicketApi.isSuccessful == true
                                    // &&   fundTicketApi.authorizationUrl !=
                                    //         null
                                    ) {
                                      debugPrint(
                                        "Fund Ticket id: ${widget.kwikticket.id}",
                                      );

                                      final reference =
                                          fundTicketApi.paymentReference ?? "";
                                      if (reference.isNotEmpty) {
                                        _verifyPayment(
                                          widget.kwikTicketId,
                                          fundTicketApi.paymentReference!,
                                        );
                                      }
                                    } else {
                                      showToastContainer(
                                        "Fund Ticket",
                                        fundTicketApi.message,
                                        colorCodes.mistyRose,
                                        colorCodes.portlandOrange,
                                        context,
                                      );
                                    }
                                  });
                            } else if (selectCardTransfer == true) {
                              await fundTicketApi
                                  .fundTicket(
                                    kwikTicketId: widget.kwikticket.id,
                                    exporterId:
                                        widget.kwikticket.exporter?.id ?? "",
                                    fundingMethod: 2,
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
                                              onPageStarted: (url) {
                                                setState(
                                                  () => _isLoading = true,
                                                );
                                                final uri = Uri.parse(url);
                                                final reference =
                                                    uri.queryParameters["reference"] ??
                                                    "";
                                                if (reference.isNotEmpty) {
                                                  _verifyPayment(
                                                    widget.kwikTicketId,
                                                    fundTicketApi
                                                        .paymentReference!,
                                                  );
                                                }
                                              },
                                              onPageFinished: (url) {
                                                debugPrint(
                                                  "✅ Finished loading: $url",
                                                );
                                                setState(
                                                  () => _isLoading = false,
                                                );
                                              },
                                            ),
                                          )
                                          ..loadRequest(
                                            Uri.parse(
                                              fundTicketApi.authorizationUrl!,
                                            ),
                                          );
                                  });
                              setState(() {
                                showWebView = true;
                              });
                            } else {
                              showToastContainer(
                                "Select Payment Method",
                                "Please select a payment method to proceed.",
                                colorCodes.mistyRose,
                                colorCodes.portlandOrange,
                                context,
                              );
                            }
                          }
                        },
                        fontFamily: "",
                        enabled:
                            (selectKwikBalance || selectCardTransfer) &&
                            checkterms, // Use enabled property
                      ),
                      SizedBox(height: 55),
                    ],
                  ),
                ],
              ),
      bottomNavigationBar: Bottomnavigationbar(3),
    );
  }

  Widget cardDetailsWidget(onPressedVisibility, _isvisible) {
    return Container(
      height: 350,
      width: 391,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: colorCodes.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                "assets/images/icons/dashboard/Frame 1000006029 (3).png",
                height: 25,
                width: 25,
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Card Details",
                    style: kwikTextStlye(
                      14.0,
                      FontWeight.w600,
                      colorCodes.black,
                    ),
                  ),
                  Text(
                    "Enter your card details below",
                    style: kwikTextStlye(
                      12.0,
                      FontWeight.w300,
                      colorCodes.graniteGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          kycphonenumberFieldColumn(
            "",
            cardnumbercontroller,
            title: "Card Number",
            hintText: "123 456 789 012 3456",
            suffixIcon: InkWell(
              highlightColor: Color(0xFF),
              onTap: onPressedVisibility,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  _isvisible == false
                      ? 'assets/images/icons/eye-slash.png'
                      : 'assets/images/icons/eye.png',
                  width: 24,
                  height: 24,
                  color: colorCodes.graniteGrey,
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 129,
                child: dateofbirthTxtField(
                  "Exp Date",
                  expDateController,
                  "",
                  () async {
                    var date = DateTime.now();
                    DateTime? dateofBirth = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().subtract(
                        Duration(days: 18 * 365),
                      ),
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now().subtract(
                        Duration(days: 18 * 365),
                      ),
                    );
                    if (dateofBirth != null) {
                      setState(() {
                        expDateController.text = DateFormat(
                          '/MM/yyyy',
                        ).format(dateofBirth);
                      });
                    }
                  },
                ),
              ),
              SizedBox(
                width: 129,
                child: kycnameFieldColumn(
                  "CVV",
                  "",
                  cvvcontroller,
                  hintText: "MM/YY",
                ),
              ),
            ],
          ),
          SizedBox(height: 15),

          kycnameFieldColumn(
            "Card Holder Name",
            "",
            cardHolderNamecontroller,
            hintText: "Peter Walker",
          ),
        ],
      ),
    );
  }

  Widget bankTransferWidget() {
    return Container(
      height: 925,
      width: 391,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
        color: colorCodes.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                "assets/images/icons/dashboard/Frame 1000006029 (3).png",
                height: 25,
                width: 25,
              ),
              SizedBox(width: 12),
              Text(
                "Bank Transfer Details",
                style: kwikTextStlye(14.0, FontWeight.w600, colorCodes.black),
              ),
            ],
          ),
          SizedBox(height: 24),
          Container(
            height: 130,
            width: 376,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            decoration: BoxDecoration(
              color: colorCodes.floralWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(width: 1.5, color: colorCodes.sunset),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/images/icons/redshipment.png",
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
                        "Manual Verification Required",
                        style: kwikTextStlye(
                          14.0,
                          FontWeight.w500,
                          colorCodes.sinopia,
                        ),
                      ),
                      Text(
                        "Transfer the exact amount to the account below. Include your contract reference in the transfer description for faster verification.",
                        style: kwikTextStlye(
                          12.0,
                          FontWeight.w300,
                          colorCodes.sinopia,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 390,
            width: 366,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
              border: Border.all(color: colorCodes.antiFlashWhite, width: 1.2),
              color: colorCodes.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Transfer to this account:",
                  style: kwikTextStlye(12.0, FontWeight.w600, colorCodes.black),
                ),
                SizedBox(height: 11),
                bankDetailColumn(
                  "Bank name",
                  "KwikTrade Commercial Bank",
                  () {},
                  suffix: SizedBox(width: 1),
                ),
                SizedBox(height: 10),
                bankDetailColumn("Account number", "0123456789", () {}),
                SizedBox(height: 8),
                bankDetailColumn(
                  "Account name",
                  "KwikTrade Escrow Services Limited",
                  () {},
                ),
                SizedBox(height: 8),
                bankDetailColumn("Amount", "#2,499,00.00", () {}),
                SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Transfer description",

                          style: kwikTextStlye(
                            12.0,
                            FontWeight.w300,
                            colorCodes.graniteGrey,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "CONTRACT-EX2024A7B9C",
                          style: kwikTextStlye(
                            12.0,
                            FontWeight.w600,
                            colorCodes.graniteGrey,
                            fontFamily: "",
                          ),
                        ),
                      ],
                    ),

                    InkWell(
                      onTap: () {},
                      child: Image.asset(
                        "assets/images/icons/copy_black.png",
                        height: 15,
                        width: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 125,
            width: 366,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: HexColor("#D0E1FB").withOpacity(0.3),
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
                  width: 245,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Processing Time",
                        style: kwikTextStlye(
                          14.0,
                          FontWeight.w500,
                          colorCodes.azureBlue,
                        ),
                      ),
                      Text(
                        "Bank transfers typically take 1-3 business days to process. We'll verify your payment and activate your contract within 24 hours of confirmation.",
                        textAlign: TextAlign.start,
                        style: kwikTextStlye(
                          12.0,
                          FontWeight.w300,
                          colorCodes.azureBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 155,
            width: 366,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
            decoration: BoxDecoration(
              border: Border.all(color: colorCodes.antiFlashWhite, width: 1.2),
              color: colorCodes.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "After transfer, you'll receive:",
                  style: kwikTextStlye(12.0, FontWeight.w600, colorCodes.black),
                ),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/images/icons/greenshipment.png",
                      height: 20,
                      width: 20,
                    ),
                    SizedBox(width: 8),

                    SizedBox(
                      width: 240,
                      child: Text(
                        "SMS confirmation when payment is received",
                        textAlign: TextAlign.start,
                        style: kwikTextStlye(
                          12.0,
                          FontWeight.w300,
                          colorCodes.graniteGrey,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/images/icons/greenshipment.png",
                      height: 20,
                      width: 20,
                    ),
                    SizedBox(width: 8),

                    SizedBox(
                      width: 240,
                      child: Text(
                        "Email with payment verification status",
                        style: kwikTextStlye(
                          12.0,
                          FontWeight.w300,
                          colorCodes.graniteGrey,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/images/icons/greenshipment.png",
                      height: 20,
                      width: 20,
                    ),
                    SizedBox(width: 8),

                    SizedBox(
                      width: 240,
                      child: Text(
                        "Contract activation notification",
                        style: kwikTextStlye(
                          12.0,
                          FontWeight.w300,
                          colorCodes.graniteGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
