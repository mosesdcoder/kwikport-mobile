import 'package:flutter/material.dart';

class FundWalletBottomsheet extends StatefulWidget {
  const FundWalletBottomsheet({super.key});

  @override
  State<FundWalletBottomsheet> createState() => _FundWalletBottomsheetState();
}

class _FundWalletBottomsheetState extends State<FundWalletBottomsheet> {
  @override
  Widget build(BuildContext context) {
    return Container(height: MediaQuery.of(context).size.height);
  }
}
