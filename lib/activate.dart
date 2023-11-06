import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paulcha/constants/api.dart';
import 'package:paulcha/register.dart';
import 'package:paulcha/services/http.service.dart';
import 'package:paulcha/services/local_storage.dart';
import 'widgets/GradientButton/GradientButton.dart';
import 'package:dio/dio.dart' as dio;

class Activate extends StatefulWidget {
  const Activate({Key? key}) : super(key: key);

  @override
  State<Activate> createState() => _ActivateState();
}

class _ActivateState extends State<Activate> {
  ///Text Editing Controllers
  TextEditingController amountController = TextEditingController(text: '');
  List items = ["Activation"];
  String val = "Activation";
  Map? res;
  String dte = "Choose date";

  PlatformFile? file;

  Future getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = result.files.single;
      setState(() {});
    } else {
      // User canceled the picker
    }
  }

  String regFee = "";
  getAccountDetails() async {
    final rex = await HttpService.get(Api.regFee);
    print(rex);
    regFee = rex.data;
    final response = await HttpService.get(Api.bankDetails);
    res = jsonDecode(response.data)[0];
    setState(() {});
  }

  String? username;
  getusername() async {
    username = await LocalStorage().getString("username");
  }

  bool loading = false;
  aktivate() async {
    loading = true;
    setState(() {});
    print(username);
    final res = await HttpService.postWithFiles(Api.activate, {
      "username": username,
      "date": dte,
      "amt": amountController.text,
      "image": dio.MultipartFile.fromBytes(File(file!.path!).readAsBytesSync(),
          filename: file!.name),
      "name": val
    });
    final result = jsonDecode(res.data);
    if (result["Status"] == "succcess") {
      Get.defaultDialog(
        title: "${result["Report"]}",
        titleStyle:
            TextStyle(color: Color(0xFF072A6C), fontWeight: FontWeight.bold),
        middleText: "Activation details sent successfully",
        middleTextStyle: TextStyle(
          color: Color(0xFF072A6C),
        ),
      ).then((value) => print("done"));
    } else {
      Get.defaultDialog(
        title: "${result["Report"]}",
        titleStyle:
            TextStyle(color: Color(0xFF072A6C), fontWeight: FontWeight.bold),
        middleText: "Activation details not sent",
        middleTextStyle: TextStyle(
          color: Color(0xFF072A6C),
        ),
      ).then((value) => print("done"));
    }
    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getusername();
    getAccountDetails();
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
                      "Activate",
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 25, right: 25),
          child: Column(children: [
            SizedBox(
              height: 15,
            ),
            Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Text(
                      "Pay To: ",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF072A6C)),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Bank: ${res != null ? res!["bname"] : ""}",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF072A6C)),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 25),
                    Text(
                      "Account Name: ${res != null ? res!["aname"] : ""}",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF072A6C)),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 25),
                    Text(
                      "Account Number: ${res != null ? res!["anum"] : ""}",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF072A6C)),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )),
            SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Text(
                  "Payment Reason",
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF072A6C),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
                height: 50,
                width: 350,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    border: Border.all(color: Color(0xFF072A6C)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset(2, 2))
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                      value: val,
                      underline: Container(),
                      style: TextStyle(color: Colors.black),
                      items: items
                          .map<DropdownMenuItem<String>>((value) =>
                              DropdownMenuItem(
                                  value: value, child: Text("$value")))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          val = value!;
                        });
                      }),
                )),
            SizedBox(height: 25),
            Row(
              children: [
                Text(
                  "Proof of Payment",
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF072A6C),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              InkWell(
                onTap: () {
                  getFile();
                },
                child: Container(
                  height: 50,
                  width: 150,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Color(0xFF072A6C)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset(2, 2))
                    ],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      bottomLeft: Radius.circular(5.0),
                    ),
                  ),
                  child: Text(
                    "Choose File",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Color(0xFF072A6C)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset(2, 2))
                    ],
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5.0),
                      bottomRight: Radius.circular(5.0),
                    ),
                  ),
                  child: Text(
                    "${file != null ? file!.name.split("/").last : "No file chosen"}",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ),
            ]),
            SizedBox(height: 25),
            Row(
              children: [
                Text(
                  "Date of payment",
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF072A6C),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            InkWell(
                onTap: () async {
                  DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now());
                  if (date != null) {
                    dte = "${date.year}-${date.month}-${date.day}";
                    setState(() {});
                  }
                },
                child: Container(
                  height: 50,
                  width: 450,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      border: Border.all(color: Color(0xFF072A6C)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 10,
                            offset: Offset(2, 2))
                      ]),
                  child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text("$dte", style: TextStyle(fontSize: 16))),
                )),
            SizedBox(height: 25),
            Row(
              children: [
                Text(
                  "Member Registration Fee",
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF072A6C),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              height: 50,
              width: 350,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  border: Border.all(color: Color(0xFF072A6C)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        offset: Offset(2, 2))
                  ]),
              child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text("\u20A6$regFee", style: TextStyle(fontSize: 16))),
            ),
            SizedBox(
              height: 25,
            ),
            loading
                ? Center(child: CircularProgressIndicator())
                : Container(
                    width: 250,
                    height: 50,
                    child: Hero(
                      tag: "Login",
                      child: GradientButton(
                        title: "Submit",
                        clrs: [Color(0xFF072A6C), Color(0xFF072A6C)],
                        onpressed: () {
                          if (file != null) {
                            aktivate();
                          } else {
                            Get.defaultDialog(
                              title: "No proof of payment",
                              titleStyle: TextStyle(
                                  color: Color(0xFF072A6C),
                                  fontWeight: FontWeight.bold),
                              middleText: "Please include proof of payment",
                              middleTextStyle:
                                  TextStyle(color: Color(0xFF072A6C)),
                            );
                          }
                        },
                      ),
                    ),
                  ),
            SizedBox(
              height: 25,
            )
          ]),
        ),
      ),
    );
  }

  Widget _input(String hint, TextEditingController controller,
      {bool obscure = false, bool readOnly = false}) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          border: Border.all(color: Color(0xFF072A6C)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(2, 2))
          ]),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 15, 0),
        child: TextFormField(
          readOnly: readOnly,
          cursorColor: Color(0xFF072A6C),
          obscureText: obscure,
          controller: controller,
          validator: (value) {
            if (value!.isEmpty) {
              return "This field must not be empty.";
            }
            return null;
          },
          decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
              //labelText: label,
              hintText: hint,
              focusColor: Colors.grey,

              //fillColor: Colors.white,

              fillColor: Colors.white),
          //keyboardType: TextInputType.emailAddress,
          style: TextStyle(
            fontFamily: "Poppins",
          ),
        ),
      ),
    );
  }
}
