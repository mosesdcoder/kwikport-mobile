import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/main.dart';
import 'package:kwik_port/ui/home/kwikticket/all_kwik_ticket_screen.dart';
import 'package:kwik_port/ui/home/contracts/contract_screen.dart';
import 'package:kwik_port/ui/home/dashboard/dashboard.dart';
import 'package:kwik_port/ui/home/exportfulfillment/KycVerification/kyc_verification_screen.dart';
import 'package:kwik_port/ui/home/profile/profile_screen.dart';
import 'package:kwik_port/ui/home/wallet/wallet_screen.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

class Bottomnavigationbar extends StatefulWidget {
  const Bottomnavigationbar(int btmNavCurrentIndex, {super.key});
  // int btmNavCurrentIndex,
  @override
  State<Bottomnavigationbar> createState() => _BottomnavigationbarState();
}

class _BottomnavigationbarState extends State<Bottomnavigationbar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: 85,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        decoration: BoxDecoration(
          color: colorCodes.white,
          border: Border.all(color: colorCodes.antiFlashWhite),
          boxShadow: [
            BoxShadow(
              color: colorCodes.azureBlue.withOpacity(0.2),
              spreadRadius: 5.0,
              blurRadius: 8.0,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            btmNavCol(
              const Dashboard(),
              1,
              'home_enabled.png',
              'home.png',
              'Home',
            ),
            btmNavCol(
              const ContractScreen(),
              2,
              'contracts_enabled.png',
              'contracts.png',
              'Contracts',
            ),
            btmNavCol(
              const AllKwikTicketScreen(),
              3,
              'ticket_enabled.png',
              'ticket.png',
              'Kwiktickets',
            ),
            btmNavCol(
              const WalletScreen(),
              4,
              'wallet_enabled.png',
              'wallet.png',
              'Wallet',
            ),
            btmNavCol(
              const ProfileScreen(),
              5,
              'profile.png',
              'profile.png',
              'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget btmNavCol(location, indexId, img2, img1, screen) {
    return Expanded(
      // width: 65,
      child: InkWell(
        onTap: () {
          setState(() {
            currentIndex = indexId;
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => location),
          );
        },
        child:
            currentIndex == indexId
                ? Column(
                  children: [
                    Image.asset(
                      "assets/images/bottomNav/$img2",
                      height: 24,
                      width: 24,
                    ),
                    SizedBox(height: 4),
                    Text(
                      screen,
                      style: kwikTextStlye(
                        12.0,
                        FontWeight.w500,
                        colorCodes.azureBlue,
                      ),
                    ),
                  ],
                )
                : Column(
                  children: [
                    Image.asset(
                      "assets/images/bottomNav/$img1",
                      height: 24,
                      width: 24,
                    ),
                    SizedBox(height: 4),
                    Text(
                      screen,
                      style: kwikTextStlye(
                        12.0,
                        FontWeight.w300,
                        colorCodes.graniteGrey,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
