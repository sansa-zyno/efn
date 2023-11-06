import 'dart:convert';
import 'package:boxicons/boxicons.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:paulcha/add_fund.dart';
import 'package:paulcha/constants/api.dart';
import 'package:paulcha/payment/withdraw_funds.dart';
import 'package:paulcha/services/http.service.dart';
import 'package:paulcha/widgets/menu.dart';

class DashBoard extends StatefulWidget {
  String username;
  DashBoard({required this.username, Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController? scrollController = ScrollController();
  List imgList = [
    "assets/7.jpeg",
    "assets/3.png",
    "assets/5.png",
  ];
  String link = "";
  String? refLink;
  String? partnerType;
  Map? totalBalance;
  Map? totalReferers;
  List? tableDatas;
  Future getDasboardData(username) async {
    final ref = await HttpService.post(Api.refLink, {"username": username});
    refLink = ref.data;
    final partner =
        await HttpService.post(Api.partnerType, {"username": username});
    switch (jsonDecode(partner.data)[0]["stage"]) {
      case "1":
        partnerType = "EFN Partner";
        setState(() {});
        break;
      case "2":
        partnerType = "Bronze Partner";
        setState(() {});
        break;
      case "3":
        partnerType = "Silver Partner";
        setState(() {});
        break;
      case "4":
        partnerType = "Gold Partner";
        setState(() {});
        break;
      case "5":
        partnerType = "Diamond Partner";
        setState(() {});
        break;
      case "6":
        partnerType = "Platinum Partner";
        setState(() {});
        break;
      default:
        partnerType = "Not registered";
        setState(() {});
    }

    final balance =
        await HttpService.post(Api.totalBalance, {"username": username});
    totalBalance = jsonDecode(balance.data)[0];
    setState(() {});
    final referers =
        await HttpService.post(Api.totalReferers, {"username": username});
    totalReferers = jsonDecode(referers.data)[0];
    setState(() {});
    final table = await HttpService.post(Api.tableData, {"username": username});
    tableDatas = jsonDecode(table.data);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDasboardData(widget.username).then((value) => link =
        "https://empowermentfoodnetwork.com/office/register.php?ref=${widget.username}${refLink!.substring(1, refLink!.length - 1)}");
  }

  @override
  Widget build(BuildContext context) {
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String Function(Match) mathFunc = (Match match) => '${match[1]},';
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: Container(),
        toolbarHeight: 120,
        flexibleSpace: Row(
          children: [
            Expanded(
              child: Stack(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      height: 300,
                    ),
                    items: imgList
                        .map(
                          (item) => Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    opacity: 10.0,
                                    image: AssetImage(item),
                                    fit: BoxFit.cover)),
                          ),
                        )
                        .toList(),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(30),
                      ),
                      //color: Color(0xFF072A6C),
                    ),
                    padding: EdgeInsets.all(15),
                    child: Column(children: [
                      Row(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              onTap: () {
                                _scaffoldKey.currentState!.openDrawer();
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50 / 2),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.menu,
                                    color: Color(0xFF072A6C),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      /*Text(
                        "Welcome ${widget.username}",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF072A6C)),
                      ),*/
                      /*SizedBox(
                        height: 5,
                      ),*/
                      /*Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Color(0xFF072A6C)),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        padding: EdgeInsets.all(8),
                        width: 250,
                        child: Text("User ID: EFN1"),
                      ),*/
                    ]),
                  ),
                ],
              ),
            )
          ],
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
      ),
      drawer: Menu(),
      body: ListView(
          controller: scrollController,
          physics: ClampingScrollPhysics(),
          children: [
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xFF072A6C),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 3,
                              offset: Offset(3, 10))
                        ]),
                    padding: EdgeInsets.all(15),
                    child: Column(children: [
                      Text(
                        "Balance",
                        style: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      totalBalance != null
                          ? Row(
                              children: [
                                Text(
                                  "NGN ${totalBalance != null ? totalBalance!["money"].replaceAllMapped(reg, mathFunc) : ""}",
                                  style: TextStyle(
                                      color: Colors.yellow,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )
                          : SpinKitFadingCircle(
                              color: Colors.white,
                            ),
                      SizedBox(
                        height: 35,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => WithdrawFund()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "Withdraw",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ]),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                          //color: Colors.deepOrange,
                          image: DecorationImage(
                              opacity: 10.0,
                              image: AssetImage("assets/6.png"),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 3,
                                offset: Offset(3, 10))
                          ]),
                      padding: EdgeInsets.all(15),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Boxicons.bxs_group,
                              color: Colors.deepOrange,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (ctx) => AddFund()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF072A6C),
                              border: Border.all(color: Colors.indigo),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 10, 30, 10),
                              child: Text(
                                "Fund",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      ]),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Center(
              child: Text(
                "Referral Link :",
                style: TextStyle(
                  color: Color(0xFF072A6C),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                padding: EdgeInsets.all(15),
                child: link != ""
                    ? Text(
                        link,
                        style:
                            TextStyle(color: Color(0xFF072A6C), fontSize: 16),
                      )
                    : LinearProgressIndicator(
                        color: Colors.blue,
                      ),
              ),
            ),
            SizedBox(height: 15),
            Center(
              child: InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: link)).then((_) =>
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Link copied to clipboard",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        backgroundColor: Colors.blue[400],
                      )));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF072A6C),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "Copy Referral Link",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          //border: Border.all(color: Color(0xFF072A6C)),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 10,
                                offset: Offset(2, 2))
                          ]),
                      padding: EdgeInsets.all(15),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Total Downlines",
                                style: TextStyle(
                                    color: Color(0xFF072A6C),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                            Icon(Boxicons.bxs_wallet, color: Colors.deepOrange)
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        totalReferers != null
                            ? Text("${totalReferers!["referer"]}",
                                style: TextStyle(
                                    color: Colors.cyan,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))
                            : SpinKitFadingCircle(
                                color: Colors.blue,
                              )
                      ]),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          // border: Border.all(color: Color(0xFF072A6C)),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 10,
                                offset: Offset(2, 2))
                          ]),
                      padding: EdgeInsets.all(15),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Partner Type",
                                style: TextStyle(
                                    color: Color(0xFF072A6C),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                            Icon(Boxicons.bxs_binoculars,
                                color: Colors.deepOrange)
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        partnerType != null
                            ? Text("$partnerType",
                                style: TextStyle(
                                    color: Colors.cyan,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))
                            : SpinKitFadingCircle(
                                color: Colors.blue,
                              )
                      ]),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          // border: Border.all(color: Color(0xFF072A6C)),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 10,
                                offset: Offset(2, 2))
                          ]),
                      padding: EdgeInsets.all(15),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "PV Balance",
                                style: TextStyle(
                                    color: Color(0xFF072A6C),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                            Icon(Boxicons.bxs_wallet_alt,
                                color: Colors.deepOrange)
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        totalBalance != null
                            ? Text("${totalBalance!["pv"]}",
                                style: TextStyle(
                                    color: Colors.cyan,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))
                            : SpinKitFadingCircle(
                                color: Colors.blue,
                              )
                      ]),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          //border: Border.all(color: Color(0xFF072A6C)),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 10,
                                offset: Offset(2, 2))
                          ]),
                      padding: EdgeInsets.all(15),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Referrer Username",
                                style: TextStyle(
                                    color: Color(0xFF072A6C),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                            Icon(Boxicons.bxs_group, color: Colors.deepOrange)
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        totalBalance != null
                            ? Text("${totalBalance!["referer"]}",
                                style: TextStyle(
                                    color: Colors.cyan,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))
                            : SpinKitFadingCircle(
                                color: Colors.blue,
                              )
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Earnings History",
                            style: TextStyle(
                                fontSize: 22,
                                color: Color(0xFF072A6C),
                                fontWeight: FontWeight.bold)),
                        Text("...",
                            style: TextStyle(
                                fontSize: 22, color: Color(0xFF072A6C)))
                      ],
                    ),
                    SizedBox(height: 20),
                    Divider(),
                    SizedBox(height: 15),
                    tableDatas != null
                        ? SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                                headingRowColor:
                                    MaterialStateProperty.resolveWith<Color?>(
                                        (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered))
                                    return Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.08);
                                  return Color(
                                      0xFF072A6C); // Use the default value.
                                }),
                                columns: [
                                  DataColumn(
                                      label: Text('No',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))),
                                  DataColumn(
                                      label: Text("Amount",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))),
                                  DataColumn(
                                      label: Text("Reason",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))),
                                  DataColumn(
                                      label: Text("Downline",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))),
                                  DataColumn(
                                      label: Text("Date",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))),
                                ],
                                rows: List<DataRow>.generate(
                                    tableDatas!.length,
                                    (index) => DataRow(cells: [
                                          DataCell(Text("${index + 1}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                          DataCell(Text(
                                              "\u20A6${tableDatas![index]["amount"]}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                          DataCell(Text(
                                              "${tableDatas![index]["reason"]}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                          DataCell(Text(
                                              "${tableDatas![index]["downliner"]}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                          DataCell(Text(
                                              "${tableDatas![index]["date"]}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                        ]))),
                          )
                        : LinearProgressIndicator(
                            color: Colors.blue,
                          )
                  ],
                ),
              ),
            ),
            SizedBox(height: 90),
          ]),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF072A6C),
          onPressed: () {
            scrollController!.animateTo(
              0,
              duration: Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
            );
          },
          child: Icon(Icons.arrow_upward)),
    );
  }
}
