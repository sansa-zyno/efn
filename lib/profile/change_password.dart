import 'dart:convert';
import 'package:achievement_view/achievement_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paulcha/constants/api.dart';
import 'package:paulcha/register.dart';
import 'package:paulcha/services/http.service.dart';
import 'package:paulcha/services/local_storage.dart';
import 'package:paulcha/widgets/GradientButton/GradientButton.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  ///Text Editing Controllers
  TextEditingController oldPasswordController = TextEditingController(text: '');
  TextEditingController newPasswordController = TextEditingController(text: '');
  TextEditingController retypePasswordController =
      TextEditingController(text: '');
  bool loading = false;
  String? username;

  getUserName() async {
    username = await LocalStorage().getString("username");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
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
                      "Change Password",
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
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 25, right: 25),
          child: Column(children: [
            SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Text(
                  "Old Password",
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF072A6C),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            _input("", oldPasswordController),
            SizedBox(height: 25),
            Row(
              children: [
                Text(
                  "New Password",
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF072A6C),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            _input("", newPasswordController),
            SizedBox(height: 25),
            Row(
              children: [
                Text(
                  "Retype Password",
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF072A6C),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            _input("", retypePasswordController),
            SizedBox(height: 50),
            loading
                ? CircularProgressIndicator()
                : Container(
                    width: 250,
                    height: 50,
                    child: Hero(
                      tag: "Login",
                      child: GradientButton(
                        title: "Submit",
                        clrs: [Color(0xFF072A6C), Color(0xFF072A6C)],
                        onpressed: () {
                          update();
                        },
                      ),
                    ),
                  ),
            SizedBox(height: 25),
          ]),
        ),
      ),
    );
  }

  update() async {
    loading = true;
    setState(() {});
    final apiResponse = await HttpService.post(Api.changePassword, {
      "username": username,
      "oldPassword": oldPasswordController.text,
      "newPassword": newPasswordController.text,
      "cPassword": retypePasswordController.text,
    });
    final result = jsonDecode(apiResponse.data);
    print(result);
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
        subTitle: "Password reset successfully",
        isCircle: true,
      ).show();
      Navigator.pop(context);
    } else {
      Get.defaultDialog(
              title: "${result["Report"]}",
              titleStyle: TextStyle(
                  color: Color(0xFF072A6C), fontWeight: FontWeight.bold),
              middleText: "Your input fields could not be updated",
              middleTextStyle: TextStyle(color: Color(0xFF072A6C)))
          .then((value) => print("done"));
    }
    loading = false;
    setState(() {});
  }

  Widget _input(String hint, TextEditingController controller,
      {bool obscure = false}) {
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
