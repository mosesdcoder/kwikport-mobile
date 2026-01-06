import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:kwik_port/api/model/transaction_model.dart';
import 'package:kwik_port/api/utils/utils.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/home/wallet/wallet_tabbar.dart';
import 'package:kwik_port/ui/home/wallet/transaction_detail_screen.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:kwik_port/utils/textFields/search_field.dart';

class WalletTransactionHistory extends StatefulWidget {
  const WalletTransactionHistory({super.key});

  @override
  State<WalletTransactionHistory> createState() =>
      _WalletTransactionHistoryState();
}

class _WalletTransactionHistoryState extends State<WalletTransactionHistory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController searcTransactioncontroller = TextEditingController();

  List<Transaction> allTransactions = [];
  List<Transaction> filteredTransactions = [];
  bool isLoading = true;
  String? errorMessage;

  final List<String> paymentTypes = [
    'All',
    'WalletTopup',
    'KwikTicketFunding',
    'KwikTicketFundingFromWallet',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: paymentTypes.length, vsync: this);
    _fetchTransactions();
    searcTransactioncontroller.addListener(_filterTransactions);
    _tabController.addListener(_filterTransactions);
  }

  Future<void> _fetchTransactions() async {
    try {
      final response = await HttpService.getRequest('/Payment/transactions');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final transactionResponse = TransactionResponse.fromJson(jsonData);
        setState(() {
          allTransactions = transactionResponse.data.results;
          _filterTransactions();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load transactions';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _filterTransactions() {
    if (!mounted) return;

    final selectedType = paymentTypes[_tabController.index];
    var filtered = selectedType == 'All'
        ? allTransactions
        : allTransactions.where((t) => t.paymentType == selectedType).toList();

    final query = searcTransactioncontroller.text;
    if (query.isNotEmpty) {
      filtered = filtered
          .where((t) =>
              t.paymentType.toLowerCase().contains(query.toLowerCase()) ||
              t.reference.toLowerCase().contains(query.toLowerCase()) ||
              t.paymentStatus.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    setState(() {
      filteredTransactions = filtered;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    searcTransactioncontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 513,
      width: 390,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
        color: colorCodes.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Transaction History",
              style: kwikTextStlye(16.0, FontWeight.w600, colorCodes.black),
            ),
          ),
          SizedBox(height: 10),
          searchFieldColumn(
            "",
            "",
            searcTransactioncontroller,
            "Search transactions...",
          ),
          SizedBox(height: 20),
          transactionHistoryTabBar(_tabController),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : errorMessage != null
                    ? Center(child: Text('Error: $errorMessage'))
                    : TabBarView(
                        controller: _tabController,
                        children: List.generate(
                          paymentTypes.length,
                          (index) => _buildTransactionList(),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    if (filteredTransactions.isEmpty) {
      return Center(
        child: Text(
          'No transactions found',
          style: kwikTextStlye(14.0, FontWeight.w400, colorCodes.graniteGrey),
        ),
      );
    }

    return ListView.builder(
      physics: ClampingScrollPhysics(),
      itemCount: filteredTransactions.length,
      itemBuilder: (context, index) {
        final transaction = filteredTransactions[index];
        final amountColor = _statusColor(transaction.paymentStatus);
        return transactionHistoryContainer(
          _paymentTypeLabel(transaction.paymentType),
          transaction.paymentStatus,
          _formatDate(transaction.createdAt),
          _formatTime(transaction.createdAt),
          _formatNaira(transaction.amount),
          amountColor,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TransactionDetailScreen(transaction: transaction),
              ),
            );
          },
        );
      },
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')} ${_getMonthName(dateTime.month)} ${dateTime.year}';
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'pm' : 'am'}';
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  Widget transactionHistoryContainer(
    String transactiontitle,
    String transactionStatus,
    String dateofTransaction,
    String timeofTransaction,
    String earning,
    Color earningColor,
    VoidCallback func,
  ) {
    final statusColor = _statusColor(transactionStatus);
    return InkWell(
      onTap: func,
      child: Container(
        height: 75,
        width: 352,
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          color: colorCodes.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 20.0,
              spreadRadius: 0.0,
              offset: Offset(0.0, 0.0),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: colorCodes.whiteSmoke,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Text(
                  '₦',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colorCodes.azureBlue,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transactiontitle,
                    style: kwikTextStlye(
                      14.0,
                      FontWeight.w500,
                      colorCodes.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        transactionStatus,
                        style: kwikTextStlye(
                          10.0,
                          FontWeight.w300,
                          statusColor,
                        ),
                      ),
                      SizedBox(width: 4),
                      Container(
                        height: 3,
                        width: 3,
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          "$dateofTransaction, $timeofTransaction",
                          style: kwikTextStlye(
                            10.0,
                            FontWeight.w300,
                            colorCodes.graniteGrey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
            Text(
              earning,
              style: kwikTextStlye(
                14.0,
                FontWeight.w600,
                earningColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    final normalized = status.toLowerCase();
    if (normalized.contains('success')) return colorCodes.mediumSeaGreen;
    if (normalized.contains('fail') || normalized.contains('declin')) {
      return Colors.redAccent;
    }
    if (normalized.contains('pending')) return Colors.orangeAccent;
    return colorCodes.black;
  }

  String _formatNaira(double amount) {
    final formatter = NumberFormat.currency(locale: 'en_NG', symbol: '₦');
    return formatter.format(amount);
  }

  String _paymentTypeLabel(String backendType) {
    switch (backendType) {
      case 'KwikTicketFunding':
        return 'Kwik Ticket Funding';
      case 'AgencyPayment':
        return 'Agency Payment';
      case 'WalletTopup':
        return 'Wallet Top-up';
      case 'Payout':
        return 'Payout';
      case 'KwikTicketFundingFromWallet':
        return 'Kwik Ticket Funding (Wallet)';
      default:
        return backendType.replaceAll(RegExp(r'([a-z])([A-Z])'), r'$1 $2');
    }
  }
}
