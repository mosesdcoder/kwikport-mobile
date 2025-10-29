import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/api/model/dashboard_model.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/main.dart';
import 'package:kwik_port/ui/home/contracts/contract_details_delivered_screen.dart';
import 'package:kwik_port/utils/button/back_nav_header.dart';
import 'package:kwik_port/utils/button/bottom_navigatior_bar.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/contract_detail_heading_and_subtitle.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

class ContractDetailsScreen extends StatefulWidget {
  final ContractModel contract;
  // final int contractStatus;
  // final String? contractId; // or String depending on your backend response

  const ContractDetailsScreen({
    super.key,
    // required this.contractId,
    // required this.contractStatus,
    required this.contract,
  });

  @override
  State<ContractDetailsScreen> createState() => _ContractDetailsScreenState();
}

class _ContractDetailsScreenState extends State<ContractDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String contractId;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // contractId = widget.contractId!;
    // Optional: if you plan to fetch contract details from API
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<ContractDetailsApi>(context, listen: false)
    //       .fetchContractDetails(widget.contractId);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: colorCodes.whiteSmoke,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(85.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 42.0, bottom: 15),
          child: backNavRow(
            context,
            "Contract details",
            func: () {
              Navigator.pop(context);
              currentIndex = 2;
            },
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 55),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 360,
                width: 390,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: colorCodes.white,
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Image.network(
                          widget.contract.commodityImage ??
                              "https://kwikport.s3.eu-west-3.amazonaws.com/commodity-images/cocoa.png",
                          height: 238,
                          width: 342,
                        ),
                        Positioned(
                          top: 35,
                          right: 17,
                          // bottom: 0,
                          // left: 0,
                          child: Container(
                            height: 25,
                            width: 48,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                width: 1.2,
                                color: HexColor("#95D6AC"),
                              ),
                              color: colorCodes.pigmentGreen,
                            ),
                            child: Text(
                              "${widget.contract.contractStatus}",
                              // ? "Active"
                              // : "Closed",
                              style: kwikTextStlye(
                                10.0,
                                FontWeight.w500,
                                colorCodes.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 19),
                    Text(
                      widget.contract.commodityName,
                      style: kwikTextStlye(
                        24.0,
                        FontWeight.w600,
                        colorCodes.black,
                      ),
                    ),
                    Text(
                      "Grade A - Premium Quality",
                      style: kwikTextStlye(
                        12.0,
                        FontWeight.w300,
                        colorCodes.graniteGrey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),

              Container(
                height: 78,
                width: 390,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: colorCodes.white,
                ),
                child: contractDetailsTabBar(_tabController),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 410,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Container(
                      height: 576,
                      width: 390,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 24,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.2,
                          color: colorCodes.antiFlashWhite,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        color: colorCodes.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Allocated",
                            style: kwikTextStlye(
                              12.0,
                              FontWeight.w600,
                              colorCodes.jetBlack,
                            ),
                          ),
                          SizedBox(height: 4),
                          LinearProgressIndicator(
                            backgroundColor: HexColor("#D6E7FF"),
                            minHeight: 8,
                            value: 0.21,
                            borderRadius: BorderRadius.circular(12),
                            color: colorCodes.azureBlue,
                          ),
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w500,
                                    color: colorCodes.graniteGrey,
                                  ),

                                  children: [
                                    TextSpan(text: "20 tons"),
                                    TextSpan(text: " / "),
                                    TextSpan(text: "100 tons"),
                                  ],
                                ),
                              ),
                              Text(
                                "20% left",
                                style: kwikTextStlye(
                                  12.0,
                                  FontWeight.w500,
                                  colorCodes.graniteGrey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          SizedBox(
                            width: 358,
                            child: Divider(
                              thickness: 1.2,
                              color: HexColor("#E7E7E7"),
                            ),
                          ),
                          SizedBox(height: 32),

                          contractDetailHeadingAndSubtitle(
                            "Contract ID",
                            "Commodity",
                            widget.contract.contractId,
                            widget.contract.commodityName,
                          ),

                          SizedBox(height: 20),
                          contractDetailHeadingAndSubtitle(
                            "Buyer",
                            "${widget.contract.buyerSpecification?.buyerName ?? "N/A"}",
                            "Destination",
                            widget.contract.destinationCountry,
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total contract value",
                                style: kwikTextStlye(
                                  12.0,
                                  FontWeight.w300,
                                  colorCodes.graniteGrey,
                                ),
                              ),
                              Text(
                                "Gross Value",
                                style: kwikTextStlye(
                                  12.0,
                                  FontWeight.w300,
                                  colorCodes.graniteGrey,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${widget.contract.totalAmount}",
                                style: kwikTextStlye(
                                  14.0,
                                  FontWeight.w600,
                                  colorCodes.black,
                                ),
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/images/icons/Trending up.png",
                                    height: 16,
                                    width: 16,
                                  ),
                                  Text(
                                    "${widget.contract.projectedIncome}",
                                    style: kwikTextStlye(
                                      14.0,
                                      FontWeight.w600,
                                      colorCodes.pigmentGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Contract type",
                                style: kwikTextStlye(
                                  12.0,
                                  FontWeight.w300,
                                  colorCodes.graniteGrey,
                                ),
                              ),
                              Text(
                                "Status",
                                style: kwikTextStlye(
                                  12.0,
                                  FontWeight.w300,
                                  colorCodes.graniteGrey,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.contract.contractType == 1
                                    ? "International Buyer"
                                    : "Local Buyer", //  "Freight on board (FOB)",
                                style: kwikTextStlye(
                                  14.0,
                                  FontWeight.w600,
                                  colorCodes.black,
                                ),
                              ),
                              Container(
                                height: 24,
                                width: 64,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1.2,
                                    color: colorCodes.mediumSeaGreen,
                                  ),
                                  borderRadius: BorderRadius.circular(22),
                                  color: colorCodes.aeroblue,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/icons/tick-circle.png",
                                      height: 16,
                                      width: 16,
                                    ),
                                    Text(
                                      widget.contract.contractStatus == 0
                                          ? "Open"
                                          : "Closed",
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
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          height: 172,
                          width: 390,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 24,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: colorCodes.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Buyer Specifications",
                                style: kwikTextStlye(
                                  14.0,
                                  FontWeight.w600,
                                  colorCodes.black,
                                ),
                              ),
                              SizedBox(height: 10),
                              contractDetailHeadingAndSubtitletwo(
                                "Moisture Content",
                                "Bean Count",
                                "${widget.contract.buyerSpecification?.moistureContent ?? "N/A"}", //   "≤7.5%",
                                "${widget.contract.buyerSpecification?.commodityCountPerMeasurement ?? "N/A"}",
                              ),
                              SizedBox(height: 10),
                              contractDetailHeadingAndSubtitletwo(
                                "Buyer",
                                "Destination",

                                widget.contract.buyerSpecification?.buyerName ??
                                    "N/A",
                                widget.contract.destinationCountry,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 71,
                          width: 390,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 15,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: colorCodes.white,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Price Per Ton (Naira)",
                                    style: kwikTextStlye(
                                      12.0,
                                      FontWeight.w300,
                                      colorCodes.graniteGrey,
                                    ),
                                  ),
                                  Text(
                                    "Buyer price Per Ton (USD)",
                                    style: kwikTextStlye(
                                      12.0,
                                      FontWeight.w300,
                                      colorCodes.graniteGrey,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${widget.contract.buyerSpecification?.buyerPricePerUnit ?? "N/A"}",
                                    style: TextStyle(
                                      fontFamily: "",
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: colorCodes.black,
                                    ),
                                  ),

                                  Text(
                                    "${widget.contract.pricePerUnitInUSD}",
                                    style: kwikTextStlye(
                                      14.0,
                                      FontWeight.w600,
                                      colorCodes.pigmentGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        kwikbutton("View Contract Details", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ContractDetailsDeliveredScreen(
                                    contract: widget.contract,
                                  ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 50),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Bottomnavigationbar(2),
    );
  }

  Widget contractDetailsTabBar(_tabController) {
    return Container(
      height: 50,
      width: 179,
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),

      decoration: BoxDecoration(
        color: colorCodes.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(width: 1.2, color: colorCodes.antiFlashWhite),
      ),
      child: TabBar(
        // indicatorColor: colorCodes.teaGreen,
        // labelPadding: const EdgeInsets.symmetric(vertical: 12),
        indicatorSize: TabBarIndicatorSize.tab,

        labelColor: colorCodes.white,
        labelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelColor: colorCodes.black,
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          // color: colorCodes
        ),

        // indicatorPadding: const EdgeInsets.symmetric(
        //   vertical: 4,
        //   horizontal: 4,
        // ),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: colorCodes.frenchSkyBlue),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              colorCodes.jordyBlue,
              colorCodes.azureBlue,
              colorCodes.azureBlue,
            ],
          ),
          color: colorCodes.white,
        ),
        controller: _tabController,
        tabs: [Tab(text: "Overview"), Tab(text: "Details")],
      ),
    );
  }
}
