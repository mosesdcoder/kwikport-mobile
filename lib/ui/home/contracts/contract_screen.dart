import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/home/contracts/contract_details_screen.dart';
import 'package:kwik_port/ui/home/contracts/filter_contract_dialog.dart';
import 'package:kwik_port/ui/home/contracts/filter_result_screen.dart';
import 'package:kwik_port/utils/button/bottom_navigatior_bar.dart';
import 'package:kwik_port/utils/containers/available_contract_container.dart';
import 'package:kwik_port/utils/containers/contract_category_container.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

class ContractScreen extends StatefulWidget {
  const ContractScreen({super.key});

  @override
  State<ContractScreen> createState() => _ContractScreenState();
}

class _ContractScreenState extends State<ContractScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int itemCount = 3;

  List categoryIcon = [
    "assets/images/icons/cate_1.png",
    "assets/images/icons/cate_2.png",
    "assets/images/icons/cate_3.png",
    "assets/images/icons/cate_3.png",
  ];
  List category = ["Agriculture", "Cosmectics", "Textile", "Textile"];
  List count = ["5", "2", "4", "4"];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent going back
        return false;
      },
      child: Scaffold(
        extendBody: true,
        backgroundColor: colorCodes.whiteSmoke,
        body: ListView(
          shrinkWrap: true,
          physics: RangeMaintainingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0),
          children: [
            SizedBox(
              // height: MediaQuery.of(context).size.height - 30,
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 60,
                    child: Column(
                      children: [
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
                                (context, index) => SizedBox(width: 12),
                            itemCount: category.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return contractCategoryContainer(
                                categoryIcon[index],
                                category[index],
                                count[index],
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
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              SizedBox(
                                height: 320 * itemCount.toDouble(),
                                child: ListView.separated(
                                  separatorBuilder:
                                      (context, index) => SizedBox(height: 16),
                                  itemCount: itemCount,
                                  itemBuilder: (ctx, index) {
                                    return avaiableontractContainer(
                                      "assets/images/cocoa.png",
                                      "Cocoa Bean",
                                      "assets/images/icons/tick-circle.png",
                                      "Open",
                                      "100 tons",
                                      "assets/images/icons/Country.png",
                                      "Argentina",
                                      "20 tons",
                                      "100 tons",
                                      "20%",
                                      "\$12,500",
                                      "assets/images/icons/Trending up.png",
                                      "15.5%",
                                      () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    ContractDetailsScreen(),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              ListView(),
                              ListView(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // FilterResultScreen(),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Bottomnavigationbar(2),
      ),
    );
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
        tabs: [Tab(text: "All"), Tab(text: "Open"), Tab(text: "Closed")],
      ),
    );
  }
}
