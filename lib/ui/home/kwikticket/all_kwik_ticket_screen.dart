import 'package:flutter/material.dart';
import 'package:kwik_port/api/controller/kwikTickets/get_kwik_ticket_api.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/main.dart';
import 'package:kwik_port/utils/button/back_nav_header.dart';
import 'package:kwik_port/utils/button/bottom_navigatior_bar.dart';
import 'package:provider/provider.dart';

class AllKwikTicketScreen extends StatefulWidget {
  const AllKwikTicketScreen({super.key});

  @override
  State<AllKwikTicketScreen> createState() => _AllKwikTicketScreenState();
}

class _AllKwikTicketScreenState extends State<AllKwikTicketScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Fetch contracts on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final api = Provider.of<GetKwikTicketApi>(context, listen: false);
      api.fetchKwikTickets(); // PageIndex=1, PageSize=20, version=1
      isLoading = true;
    });
    // _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    // _controller.close();
    super.dispose();
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
          child: Text(
            "Kwiktickets",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24.0,
              fontWeight: FontWeight.w600,
              color: colorCodes.black,
            ),
          ),
        ),
      ),

      body: ListView(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 55),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [kwikticketTabBar(_tabController)],
          ),
        ],
      ),
      bottomNavigationBar: Bottomnavigationbar(3),
    );
  }

  Widget kwikticketTabBar(_tabController) {
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
        tabs: [
          Tab(text: "Awaiting"),
          Tab(text: "Active"),
          Tab(text: "Fulfilled"),
        ],
      ),
    );
  }
}
