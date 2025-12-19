import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kwik_port/api/controller/contractsApi/publishedcontractsApi.dart';
import 'package:kwik_port/api/model/contrat_enums.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/home/contracts/contract_details_screen.dart';
import 'package:kwik_port/ui/home/contracts/filter_contract_dialog.dart';
import 'package:kwik_port/ui/home/contracts/filter_result_screen.dart';
import 'package:kwik_port/utils/button/bottom_navigatior_bar.dart';
import 'package:kwik_port/utils/button/loading_dialog.dart';
import 'package:kwik_port/utils/containers/available_contract_container.dart';
import 'package:kwik_port/utils/containers/contract_category_container.dart';
import 'package:kwik_port/utils/text/textstyle.dart';
import 'package:provider/provider.dart';
import 'package:swipe_refresh/swipe_refresh.dart';

class ContractScreen extends StatefulWidget {
  const ContractScreen({super.key});

  @override
  State<ContractScreen> createState() => _ContractScreenState();
}

class _ContractScreenState extends State<ContractScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int itemCount = 3;
  bool isLoading = false;
  final _controller = StreamController<SwipeRefreshState>.broadcast();
  Stream<SwipeRefreshState> get _stream => _controller.stream;

  List categoryIcon = [
    "assets/images/icons/cate_1.png",
    "assets/images/icons/cate_2.png",
    "assets/images/icons/cate_3.png",
    "assets/images/icons/cate_3.png",
  ];
  // List category = ["Agriculture", "Cosmectics", "Textile", "Textile"];
  // List count = ["5", "2", "4", "4"];
  final ScrollController _scrollController = ScrollController();
  ContractCategory? selectedCategory;
  // @override
  // void initState() {
  //   super.initState();
  //   _tabController = TabController(length: 3, vsync: this);
  // }
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Fetch contracts on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final api = Provider.of<GetContractApi>(context, listen: false);
      api.fetchContracts(); // PageIndex=1, PageSize=20, version=1
      isLoading = true;
    });
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final api = Provider.of<GetContractApi>(context, listen: false);
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!api.loading && api.hasMore) {
        api.fetchContracts();
      }
    }
  }

  Future<void> _refresh() async {
    final api = Provider.of<GetContractApi>(context, listen: false);
    setState(() {
      selectedCategory = null; // Clear category filter
    });
    await api.fetchContracts();
    _controller.sink.add(SwipeRefreshState.hidden);
    // _controller.sink.add(SwipeRefreshState.hidden);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contractProvider = Provider.of<GetContractApi>(context);
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent going back
        return false;
      },
      child: Scaffold(
        extendBody: true,
        backgroundColor: colorCodes.whiteSmoke,
        body: ListView(
          // physics: NeverScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SwipeRefresh.adaptive(
                stateStream: _stream,
                onRefresh: _refresh,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 10.0,
                      right: 10,
                      top: 20.0,
                      bottom: 60,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Contracts",
                              style: kwikTextStlye(
                                24.0,
                                FontWeight.w600,
                                colorCodes.black,
                              ),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,

                                      builder: (BuildContext context) {
                                        return FilterContractDialog();
                                      },
                                    );
                                  },
                                  child: Image.asset(
                                    "assets/images/icons/search_icon_cont.png",
                                    height: 48,
                                    width: 48,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Image.asset(
                                    "assets/images/icons/settin_icon_cont.png",
                                    height: 48,
                                    width: 48,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        contractTabBar(_tabController),
                        SizedBox(height: 22),

                        Row(
                          children: [
                            Image.asset(
                              "assets/images/icons/popular_star.png",
                              height: 24,
                              width: 24,
                            ),
                            SizedBox(width: 4),
                            Text(
                              "Popular categories",
                              style: kwikTextStlye(
                                14.0,
                                FontWeight.w500,
                                colorCodes.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        SizedBox(
                          height: 45,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.separated(
                            separatorBuilder:
                                (context, index) => const SizedBox(width: 12),
                            itemCount: ContractCategory.values.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final category = ContractCategory.values[index];
                              final contractsByCat = contractProvider
                                  .getContractsByCategory(category.value);
                              final isSelected = selectedCategory == category;

                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    if (selectedCategory == category) {
                                      // tap again → clear filter
                                      selectedCategory = null;
                                    } else {
                                      selectedCategory = category;
                                    }
                                  });
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder:
                                  // (_) => FilterResultScreen(
                                  //           title: category.name,
                                  //           contracts: contractsByCat,
                                  //         ),
                                  //   ),
                                  // );
                                },
                                child: contractCategoryContainer(
                                  categoryIcon[index % categoryIcon.length],
                                  category.name,
                                  contractsByCat.length.toString(),
                                ),
                              );
                            },
                          ),
                        ),

                        SizedBox(height: 28),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Available Contracts",
                            style: kwikTextStlye(
                              16.0,
                              FontWeight.w500,
                              colorCodes.black,
                            ),
                          ),
                        ),
                        if (selectedCategory != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Text(
                                  "Showing: ",
                                  style: kwikTextStlye(
                                    14.0,
                                    FontWeight.w400,
                                    colorCodes.black,
                                  ),
                                ),
                                Text(
                                  selectedCategory!.name,
                                  style: kwikTextStlye(
                                    14.0,
                                    FontWeight.w600,
                                    colorCodes.azureBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        SizedBox(
                          height:
                              325 *
                              contractProvider.contracts.length.toDouble(),
                          child: TabBarView(
                            controller: _tabController,
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              _buildContractList(contractProvider), // All
                              _buildContractList(
                                contractProvider,
                                statusFilter: "Active",
                              ), // Open
                              _buildContractList(
                                contractProvider,
                                statusFilter: "Closed",
                              ), // Closed
                            ],
                          ),
                        ),
                        // FilterResultScreen(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Bottomnavigationbar(2),
      ),
    );
  }

  Widget _buildContractList(
    GetContractApi contractProvider, {
    String? statusFilter,
  }) {
    if (contractProvider.loading) {
      return Center(child: kwikportloader());
    } else if (contractProvider.contracts.isEmpty) {
      return const Center(child: Text("No contracts available"));
    } else {
      // ✅ Handle empty state
      if (contractProvider.contracts.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/icons/filter_result.png",
                  height: 96,
                  width: 113,
                ),
                const SizedBox(height: 16),
                Text(
                  contractProvider.message.isNotEmpty
                      ? contractProvider.message
                      : "No active contracts found.",
                  style: kwikTextStlye(
                    14.0,
                    FontWeight.w600,
                    colorCodes.graniteGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      }
      var filteredContracts =
          statusFilter == null
              ? contractProvider.contracts
              : contractProvider.contracts
                  .where((c) => c.contractStatus == statusFilter)
                  .toList();

      if (selectedCategory != null) {
        filteredContracts =
            filteredContracts
                .where((c) => c.contractCategory == selectedCategory!.value)
                .toList();
      }
      return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemCount: filteredContracts.length,
        itemBuilder: (_, index) {
          final contract = filteredContracts[index];
          var tonsRemaining =
              contract.totalQuantity! - contract.fulfilledQuantity!;
          var percentageLeft =
              (tonsRemaining / contract.totalQuantity! ?? 0) * 100;
          double progressValue = tonsRemaining / contract.totalQuantity!;

          return avaiableontractContainer(
            contract.commodityImage ?? "assets/images/cocoa.png",
            contract.commodityName,
            "assets/images/icons/tick-circle.png",
            contract.contractStatus, //== 0 ? "Active" : "Closed",
            contract.totalQuantity, // "100 tons",
            "assets/images/icons/Country.png",
            contract.destinationCountry,
            progressValue,
            "${tonsRemaining}", // "20 tons",
            "${contract.totalQuantity}", //100 tons",
            "${percentageLeft}% left",
            "${contract.totalAmount}",
            "assets/images/icons/Trending up.png",
            "${contract.profitRatio?.toStringAsFixed(2) ?? '0.00'}%",
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ContractDetailsScreen(
                        contract: contractProvider.contracts[index],

                        // contractId: contract.id,
                        // contractStatus: contract.contractStatus,
                      ),
                ),
              );
            },
          );
        },
      );
    }
  }

  Widget contractTabBar(_tabController) {
    return Container(
      height: 46,
      width: 390,
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),

      decoration: BoxDecoration(
        color: colorCodes.white,
        borderRadius: BorderRadius.circular(100),
      ),
      child: TabBar(
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
        ),

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
        tabs: [Tab(text: "All"), Tab(text: "Open"), Tab(text: "Closed")],
      ),
    );
  }
}
