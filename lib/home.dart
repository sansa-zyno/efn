import 'dart:io';
import 'package:flutter/material.dart';
import 'package:paulcha/activate.dart';
import 'package:paulcha/add_fund.dart';
import 'package:paulcha/apply_incentives.dart';
import 'package:paulcha/dashboard.dart';
import 'package:paulcha/market/my_orders.dart';
import 'package:paulcha/payment/withdraw_funds.dart';
import 'package:paulcha/profile/edit_profile_setup.dart';
import 'package:boxicons/boxicons.dart';
import 'package:paulcha/services/appbackground.service.dart';
import 'package:upgrader/upgrader.dart';
import 'package:double_back_to_close/double_back_to_close.dart';

class Home extends StatefulWidget {
  String username;
  Home({required this.username, Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int pageIndex;
  late Widget _showPage;
  late DashBoard _dashboard;
  late AddFund _addFund;
  late WithdrawFund _withdrawFund;

  //navbar
  Widget _pageChooser(int page) {
    switch (page) {
      case 0:
        return _dashboard;

      case 1:
        return _addFund;

      case 2:
        return _withdrawFund;
      default:
        return new Container(
            child: new Center(
          child: new Text(
            'No Page found by page thrower',
            style: new TextStyle(fontSize: 30),
          ),
        ));
    }
  }

  /* bg() async {
    await Future.delayed(Duration(seconds: 30), () async {
      await AppbackgroundService().startBg();
    });
  }*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dashboard = DashBoard(username: widget.username);
    _addFund = AddFund();
    _withdrawFund = WithdrawFund();
    pageIndex = 0;
    _showPage = _pageChooser(pageIndex);
    //bg();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DoubleBack(
        message: "Press back again to close",
        child: Scaffold(
          body: UpgradeAlert(
              upgrader: Upgrader(
                dialogStyle: Platform.isIOS
                    ? UpgradeDialogStyle.cupertino
                    : UpgradeDialogStyle.material,
              ),
              child: _showPage),
          bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.blue,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    size: 25,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.add,
                    size: 25,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Boxicons.bx_wallet,
                    size: 25,
                  ),
                  label: '',
                ),
              ],
              showSelectedLabels: false,
              showUnselectedLabels: false,
              currentIndex: pageIndex,
              selectedItemColor: Colors.yellow,
              unselectedItemColor: Colors.white,
              onTap: (int tappedIndex) {
                setState(() {
                  pageIndex = tappedIndex;
                  _showPage = _pageChooser(pageIndex);
                });
              }),
        ),
      ),
    );
  }
}
