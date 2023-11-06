import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paulcha/login.dart';
import 'package:paulcha/onboarding2.dart';
import 'package:paulcha/services/local_storage.dart';
import 'widgets/GradientButton/GradientButton.dart';

class OnBoarding1 extends StatefulWidget {
  OnBoarding1({Key? key}) : super(key: key);

  @override
  State<OnBoarding1> createState() => _OnBoarding1State();
}

class _OnBoarding1State extends State<OnBoarding1> {
  onboardingShown() async {
    await LocalStorage().setBool("onboarded", true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onboardingShown();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Spacer(),
            Center(
              child: CircleAvatar(
                radius: 150,
                backgroundImage: AssetImage('assets/5.png'),
              ),
            ),
            SizedBox(height: 25),
            Text(
              "OUR VISION",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            Text(
              "To solve the food and money shortage problem in Nigeria, West Africa and the world.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 100),
            Container(
              width: 250,
              height: 50,
              child: Hero(
                tag: "Login",
                child: GradientButton(
                  title: "Next",
                  clrs: [Color(0xFF072A6C), Color(0xFF072A6C)],
                  onpressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                          child: OnBoarding2()),
                    );
                  },
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
