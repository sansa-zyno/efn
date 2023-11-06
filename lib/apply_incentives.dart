import 'dart:convert';
import 'package:achievement_view/achievement_view.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:paulcha/constants/api.dart';
import 'package:paulcha/services/http.service.dart';
import 'services/local_storage.dart';

class ApplyIncentives extends StatefulWidget {
  const ApplyIncentives({Key? key}) : super(key: key);

  @override
  State<ApplyIncentives> createState() => _ApplyIncentivesState();
}

class _ApplyIncentivesState extends State<ApplyIncentives> {
  List? tableDatas;
  String? username;

  getData() async {
    username = await LocalStorage().getString("username");
    final table =
        await HttpService.post(Api.incentives, {"username": username});
    tableDatas = jsonDecode(table.data);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      "Apply Incentives",
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
      body: tableDatas != null
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: DataTable2(
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  minWidth: 600,
                  columns: [
                    DataColumn2(
                      label: Text('No',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue)),
                    ),
                    DataColumn(
                      label: Text('Incentive Name',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue)),
                    ),
                    DataColumn(
                      label: Text('PV',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue)),
                    ),
                    DataColumn(
                      label: Text('Action',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue)),
                    ),
                  ],
                  rows: tableDatas!.isNotEmpty
                      ? List<DataRow>.generate(
                          tableDatas!.length,
                          (index) => DataRow(cells: [
                                DataCell(Text("${index + 1}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                                DataCell(Text("${tableDatas![index]["iname"]}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                                DataCell(Text("${tableDatas![index]["PV"]}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))),
                                DataCell(InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    padding: EdgeInsets.all(8),
                                    child: Text("Apply",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16)),
                                  ),
                                  onTap: () {
                                    apply(tableDatas![index]["id"]);
                                  },
                                )),
                              ]))
                      : []),
            )
          : Center(child: SpinKitDualRing(color: Color(0xFF072A6C))),
    );
  }

  apply(id) async {
    try {
      final res = await HttpService.post(
          Api.applyIncentives, {"username": username, "id": id});
      final result = jsonDecode(res.data);
      if (result["Status"] == "succcess") {
        AchievementView(
          context,
          color: Color(0xFF072A6C),
          icon: Icon(
            Icons.check,
            color: Colors.white,
          ),
          title: "Success!",
          elevation: 20,
          subTitle: "Your request to apply for the incentive was successfull",
          isCircle: true,
        ).show();
      } else {
        AchievementView(
          context,
          color: Colors.red,
          icon: Icon(
            Icons.bug_report,
            color: Colors.white,
          ),
          title: "Failed!",
          elevation: 20,
          subTitle: "Request failed",
          isCircle: true,
        ).show();
      }
    } catch (e) {
      AchievementView(
        context,
        color: Colors.red,
        icon: Icon(
          Icons.bug_report,
          color: Colors.white,
        ),
        title: "Error!",
        elevation: 20,
        subTitle: "Something went wrong",
        isCircle: true,
      ).show();
    }
  }
}
