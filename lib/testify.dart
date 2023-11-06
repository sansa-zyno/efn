import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paulcha/Widgets/GradientButton/GradientButton.dart';
import 'package:paulcha/constants/api.dart';
import 'package:paulcha/services/http.service.dart';
import 'package:paulcha/services/local_storage.dart';

class Testify extends StatefulWidget {
  @override
  State<Testify> createState() => _TestifyState();
}

class _TestifyState extends State<Testify> {
  TextEditingController subjectController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  String? username;

  getUserName() async {
    username = await LocalStorage().getString("username");
  }

  bool loading = false;
  testify() async {
    loading = true;
    setState(() {});
    print(username);
    final res = await HttpService.post(Api.testify, {
      "username": username,
      "subject": subjectController.text,
      "comment": commentController.text
    });
    final result = jsonDecode(res.data);
    if (result["Status"] == "succcess") {
      Get.defaultDialog(
        title: "${result["Report"]}",
        titleStyle:
            TextStyle(color: Color(0xFF072A6C), fontWeight: FontWeight.bold),
        middleText: "Message sent successfully",
        middleTextStyle: TextStyle(color: Color(0xFF072A6C)),
      ).then((value) => print("done"));
    } else {
      Get.defaultDialog(
        title: "${result["Report"]}",
        titleStyle:
            TextStyle(color: Color(0xFF072A6C), fontWeight: FontWeight.bold),
        middleText: "Message not sent",
        middleTextStyle: TextStyle(color: Color(0xFF072A6C)),
      ).then((value) => print("done"));
    }
    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width / 100;
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
                      "Testimony",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: w * 6.0,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          children: [
            SizedBox(height: 15),
            Row(
              children: [
                Text(
                  "Subject",
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF072A6C),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            _input("", subjectController),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Text(
                  "Enter Your Testimony",
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF072A6C),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              height: 350,
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                color: Colors.white30,
                border: Border.all(color: Color(0xFF072A6C)),
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                        hintText: "Leave a comment here"),
                    controller: commentController,
                    maxLines: 15,
                    maxLength: 450,
                  ))
                ],
              ),
            ),
            SizedBox(height: 50),
            loading
                ? Center(child: CircularProgressIndicator())
                : Container(
                    width: 220,
                    height: 50,
                    child: GradientButton(
                      title: "Submit",
                      clrs: [Color(0xFF072A6C), Color(0xFF072A6C)],
                      onpressed: () async {
                        testify();
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _input(String hint, TextEditingController controller,
      {bool obscure = false}) {
    return Container(
      height: 60,
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
              hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontStyle: FontStyle.italic),
              //labelText: label,
              hintText: hint,
              focusColor: Colors.grey,

              //fillColor: Colors.white,

              fillColor: Color.fromARGB(255, 136, 0, 0)),
          //keyboardType: TextInputType.emailAddress,
          style: TextStyle(
            fontFamily: "Poppins",
          ),
        ),
      ),
    );
  }
}
