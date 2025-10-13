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
  String btnName = 'Next';

  PageController _pageController = new PageController(
    initialPage: 0,
    // keepPage: true,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true,
      backgroundColor: colorCodes.white, //Colors.transparent,
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage(
        //       "assets/images/onboardingImg.png",
        //       // height: 430,
        //       // width: 430,
        //     ),
        //   ),
        // ),
        height: MediaQuery.of(context).size.height,
        // height: MediaQuery.of(context).size.height - 500,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: PageView(
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            onboardingView(
              "assets/images/onboardingFrame 1.png",
              '',
              '',
              '',
              '',
              '',
            ),
            onboardingView(
              "assets/images/onboardingFrame 2.png",
              'How It Works',
              'Pick a KwikTicket. Your share of a real export contractency assigned',
              'Join with goods (Product Supply) or funds (KwikProcure)',
              'Verified agents handle documentation, logistics & delivery',
              'Earnings land in your KwikLC Walleterified agents handle documentation, logistics & delivery',
            ),
            onboardingView(
              "assets/images/onboardingFrame 3.png",
              'How It Works',
              'Real, verified contracts',
              'Trusted agents, no middlemen',
              'Track every step in-app',
              'Get paid in dollars',
            ),
            onboardingView(
              'assets/images/04- Onboarding V1.1 1.png',
              'Start Your First Export!',
              'Start your first export today and watch it go global.',
              '',
              '',
              '',
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
      if (currentPage == 3) {
        btnName = 'Create an account ';
      } else {
        btnName = 'Next';
      }
    });
  }

  void boardDialog() {
    if (currentPage == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignupScreen()),
      );
    } else {
      _pageController.animateToPage(
        currentPage + 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    }
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

  Widget onboardingDetailContainer(detail) {
    return Container(
      width: 370,
      height: 54,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      decoration: BoxDecoration(
        color: colorCodes.whiteSmoke,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            "assets/images/icons/dashboard/Checkbox (1).png",
            height: 16,
            width: 16,
          ),
          SizedBox(width: 5),
          SizedBox(
            width: 265,
            child: Text(
              detail,
              style: kwikTextStlye(12.0, FontWeight.w500, colorCodes.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget onboardingView(
    img,
    title,
    // subtitle,
    detailone,
    detailtwo,
    detailthree,
    detailfour,
  ) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      shrinkWrap: true,
      children: [
        Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Image.asset(
                    img,
                    // height: 480,
                    width: 430,
                  ),
                ],
              ),
            ),
            Positioned(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        if (currentPage == 0) {
                        } else {
                          _pageController.animateToPage(
                            currentPage - 1,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          );
                        }
                      },
                      child: Image.asset(
                        'assets/images/icons/button back.png',
                        height: 48,
                        width: 48,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        final lastpage = 3;
                        _pageController.animateToPage(
                          lastpage,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      },
                      child: Image.asset(
                        "assets/images/icons/skipButton (1).png",
                        height: 58,
                        width: 82,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              top: 340,
              right: 0,
              child: Container(
                height: 528,
                width: 430,
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                decoration: BoxDecoration(
                  color: colorCodes.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(60),
                    topLeft: Radius.circular(60),
                  ),
                ),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: List.generate(
                        4,
                        (index) => getIndicator(index),
                      ),
                    ),
                    SizedBox(height: 20),
                    currentPage == 0
                        ? Column(
                          children: [
                            Text(
                              "Welcome!",
                              style: kwikTextStlye(
                                32.0,
                                FontWeight.w700,
                                colorCodes.textBlack,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Export Made Simple",
                              style: kwikTextStlye(
                                22.0,
                                FontWeight.w600,
                                colorCodes.textBlack,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            Text(
                              "With KwikPort, anyone can join verified export deals, track progress, and earn in dollars.",
                              style: kwikTextStlye(
                                14.0,
                                FontWeight.w500,
                                colorCodes.graniteGrey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 100),
                          ],
                        )
                        : currentPage == 3
                        ? Column(
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
                            SizedBox(height: 10),

                            Container(
                              width: 390,
                              // height: 251,
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  width: 1.2,
                                  color: colorCodes.whiteSmoke,
                                ),
                                color: colorCodes.white,
                              ),
                              child: Column(
                                children: [
                                  onboardingDetailContainer(detailone),
                                  SizedBox(height: 5),
                                  // currentPage == 3
                                  //     ? Container()
                                  //     : onboardingDetailContainer(detailtwo),
                                  SizedBox(height: 5),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                          ],
                        )
                        : Column(
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
                            SizedBox(height: 10),

                            Container(
                              width: 390,
                              // height: 251,
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  width: 1.2,
                                  color: colorCodes.whiteSmoke,
                                ),
                                color: colorCodes.white,
                              ),
                              child: Column(
                                children: [
                                  onboardingDetailContainer(detailone),
                                  SizedBox(height: 5),
                                  // currentPage == 3
                                  //     ? Container()
                                  //     :
                                  onboardingDetailContainer(detailtwo),
                                  SizedBox(height: 5),
                                  // currentPage == 3
                                  //     ? Container()
                                  //     :
                                  onboardingDetailContainer(detailthree),
                                  SizedBox(height: 5),
                                  // currentPage == 3
                                  //     ? Container()
                                  //     :
                                  onboardingDetailContainer(detailfour),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                          ],
                        ),
                    kwikbutton(btnName, () {
                      boardDialog();
                    }),
                    currentPage == 3 ? SizedBox(height: 10) : Container(),
                    currentPage == 3
                        ? kwikbutton(
                          "Login",
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },
                          backgroundcolor: colorCodes.white,
                          textColor: colorCodes.black,
                          borderColor: colorCodes.darkGrey,
                        )
                        : Container(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
