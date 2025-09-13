import 'package:flutter/material.dart';
import 'package:kwik_port/colors/color.dart';
import 'package:kwik_port/ui/onboarding/auth/login_screen.dart';
import 'package:kwik_port/ui/onboarding/auth/signup_screen.dart';
import 'package:kwik_port/utils/button/kwik_button.dart';
import 'package:kwik_port/utils/text/textstyle.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPage = 0;
  PageController _pageController = new PageController(
    initialPage: 0,
    // keepPage: true,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true,
      backgroundColor: colorCodes.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        // height: MediaQuery.of(context).size.height - 500,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: PageView(
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            onboardingView(
              'assets/images/onboardingImg.png',
              'Your Export Journey Starts Here',
              'Access verified export contracts. Choose your share based on what you can procure or supply. Earn in dollars. Track every step.',
            ),
            onboardingView(
              'assets/images/onboardingImg.png',
              'Generate your KwikTicket',
              'Generate a real export contract in your name. See your projected export earnings in dollars upfront. Your KwikTicket is personal, trackable, and shareable.',
            ),
            onboardingView(
              'assets/images/onboardingImg.png',
              'Choose how to fulfill your KwikTicket',
              'Fund the contract with capital (KwikProcure) or supply the goods yourself. You’re in charge of how you fulfill your export contract.',
            ),
            onboardingView(
              'assets/images/onboardingImg.png',
              'Payout Security',
              'Your Earnings Are Locked In. Once your contract is activated, your projected export earnings are instantly loaded into your KwikLC (dollar wallet).',
            ),
          ],
          onPageChanged: (value) => {setCurrentPage(value)},
        ),
      ),
    );
  }

  setCurrentPage(int value) {
    currentPage = value;
    setState(() {
      if (currentPage == 2) {
      } else {}
    });
  }

  AnimatedContainer getIndicator(pageNo) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: 8,
      width: (currentPage == pageNo) ? 24 : 8,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        color:
            (currentPage == pageNo)
                ? colorCodes.azureBlue
                : colorCodes.platinum,
      ),
    );
  }

  Widget onboardingView(img, title, subtitle) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),

      children: [
        Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  img,
                  // height: 430,
                  width: 430,
                ),
                
                
              ],
            ),
       Container(
        child:   Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  img,
                  // height: 430,
                  width: 430,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
            
                  children: List.generate(4, (index) => getIndicator(index)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 0,
                  ),
                  child: Column(
                    children: [
                      Text(
                        title,
                        style: kwikTextStlye(
                          32.0,
                          FontWeight.w700,
                          colorCodes.textBlack,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      // SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: kwikTextStlye(
                          16.0,
                          FontWeight.w500,
                          colorCodes.graniteGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 15),
                      kwikbutton('Become an Exporter', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignupScreen()),
                        );
                      }),
                      SizedBox(height: 10),
                      kwikbutton(
                        'Login',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                        textColor: colorCodes.textBlack,
                        backgroundcolor: colorCodes.white,
                        borderColor: colorCodes.darkGrey,
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
       )
          ],
        ),
      ],
    );
  }
}
