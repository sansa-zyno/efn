import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:paulcha/constants/api.dart';
import 'package:paulcha/services/http.service.dart';

class LatestNews extends StatefulWidget {
  const LatestNews({Key? key}) : super(key: key);

  @override
  State<LatestNews> createState() => _LatestNewsState();
}

class _LatestNewsState extends State<LatestNews> {
  List newsData = [];
  getNewsData() async {
    final response = await HttpService.get(Api.news);
    newsData = jsonDecode(response.data);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 90,
          flexibleSpace: SafeArea(
            child: Container(
              height: 90,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue[600],
                border: Border.all(
                  color: Colors.blue,
                  width: 1,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Latest News",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: newsData.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.fromLTRB(10, 5, 10, 30),
                itemBuilder: (ctx, index) => Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      child: Column(
                        children: [
                          Text(
                            "${newsData[index]["nhead"].toString().toUpperCase()}",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                                "https://empowermentfoodnetwork.com/office/${newsData[index]["nimg"]}"),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                              text:
                                  "${newsData[index]["ndet"].toString().substring(0, (newsData[index]["ndet"].toString().length / 3).ceil())}",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                                text: " Read More",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              title: Text(
                                                "${newsData[index]["nhead"].toString().toUpperCase()}",
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              ),
                                              insetPadding: EdgeInsets.all(15),
                                              content: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      child: Image.network(
                                                          "https://empowermentfoodnetwork.com/office/${newsData[index]["nimg"]}"),
                                                    ),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Text(
                                                        "${newsData[index]["ndet"]}",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                              ),
                                            ));
                                  })
                          ])),
                          SizedBox(height: 10),
                          Text(
                            "Published on ${newsData[index]["datte"]} ${newsData[index]["ttime"]}",
                            style: TextStyle(
                                color: Colors.blue,
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                separatorBuilder: (ctx, index) => Divider(
                      thickness: 5,
                    ),
                itemCount: newsData.length),
      ),
    );
  }
}
