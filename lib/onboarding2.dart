import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paulcha/login.dart';
import 'package:paulcha/services/local_storage.dart';
import 'widgets/GradientButton/GradientButton.dart';

class OnBoarding2 extends StatefulWidget {
  OnBoarding2({
    Key? key,
  }) : super(key: key);

  @override
  State<OnBoarding2> createState() => _OnBoarding2State();
}

class _OnBoarding2State extends State<OnBoarding2> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                backgroundImage: AssetImage('assets/4.png'),
              ),
            ),
            SizedBox(height: 25),
            Text(
              "OUR MISSION",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            Text(
              "Our mission is primarily to provide the platforms through which ordinary people can become food distributors at different levels and make money through a network marketing system that is safe and secured for profit making.",
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
                  title: "Proceed",
                  clrs: [Color(0xFF072A6C), Color(0xFF072A6C)],
                  onpressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                          child: Login()),
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
