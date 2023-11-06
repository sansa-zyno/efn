import 'dart:convert';
import 'package:achievement_view/achievement_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:paulcha/services/http.service.dart';
import 'package:paulcha/services/local_storage.dart';
import 'constants/api.dart';
import 'widgets/GradientButton/GradientButton.dart';

class RegisterAny extends StatefulWidget {
  const RegisterAny({Key? key}) : super(key: key);

  @override
  State<RegisterAny> createState() => _RegisterAnyState();
}

class _RegisterAnyState extends State<RegisterAny> {
  ///Text Editing Controllers
  bool onPageLoad = false;
  bool loading = false;
  TextEditingController uplineController = TextEditingController(text: '');
  TextEditingController usernameController = TextEditingController(text: '');
  TextEditingController firstNameController = TextEditingController(text: '');
  TextEditingController phoneController = TextEditingController(text: '');
  TextEditingController lastNameController = TextEditingController(text: '');
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  TextEditingController confirmPasswordController =
      TextEditingController(text: '');

  List items = [];
  String val = "";
  String regFee = "";
  String username = "";

  OnPageLoad() async {
    onPageLoad = true;
    setState(() {});
    final rex = await HttpService.get(Api.regFee);
    regFee = rex.data;
    username = await LocalStorage().getString("username");
    val = username;
    final response =
        await HttpService.post(Api.referers, {"username": username});
    List result = jsonDecode(response.data);
    for (Map res in result) {
      items.add(res.values.toList().first);
    }
    onPageLoad = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    OnPageLoad();
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
                        "Register Any Member",
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
        body: onPageLoad
            ? Center(
                child: SpinKitWave(
                color: Color(0xFF072A6C),
              ))
            : Container(
                padding: EdgeInsets.only(left: 25, right: 25),
                child: ListView(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      children: [
                        Text(
                          "Referer",
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                      child: items.isNotEmpty
                          ? DropdownButton<String>(
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
                              })
                          : Container(),
                    ),
                    Text(
                      "Upline",
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF072A6C),
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    _input("Upline", uplineController),
                    SizedBox(height: 25),
                    Row(
                      children: [
                        Text(
                          "Username",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF072A6C),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    _input("efn1", usernameController),
                    SizedBox(height: 25),
                    Row(
                      children: [
                        Text(
                          "First Name",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF072A6C),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    _input("First Name", firstNameController),
                    SizedBox(height: 25),
                    Row(
                      children: [
                        Text(
                          "Last Name",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF072A6C),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    _input("Last Name", lastNameController),
                    SizedBox(height: 25),
                    Row(
                      children: [
                        Text(
                          "Phone Number",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF072A6C),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    _input("", phoneController, type: TextInputType.phone),
                    SizedBox(height: 25),
                    Row(
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF072A6C),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    _input("", emailController,
                        type: TextInputType.emailAddress),
                    SizedBox(height: 25),
                    Row(
                      children: [
                        Text(
                          "Password",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF072A6C),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    _input("Password", passwordController),
                    SizedBox(height: 25),
                    Row(
                      children: [
                        Text(
                          "Confirm Password",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF072A6C),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    _input("", confirmPasswordController),
                    SizedBox(height: 25),
                    Row(
                      children: [
                        Text(
                          "Registration Fee",
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                      child: Text("\u20A6$regFee"),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    loading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Container(
                            width: 250,
                            height: 50,
                            child: Hero(
                              tag: "Login",
                              child: GradientButton(
                                title: "Submit",
                                clrs: [Color(0xFF072A6C), Color(0xFF072A6C)],
                                onpressed: () {
                                  register();
                                },
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 25,
                    )
                  ],
                ),
              ));
  }

  register() async {
    loading = true;
    setState(() {});
    try {
      final res = await HttpService.post(Api.regAnyMember, {
        "username": username,
        "referer": val,
        "upline": uplineController.text,
        "member": usernameController.text,
        "firstname": firstNameController.text,
        "lastname": lastNameController.text,
        "email": emailController.text,
        "phone": phoneController.text,
        "password": passwordController.text,
        "cpassword": confirmPasswordController.text
      });
      final result = jsonDecode(res.data);
      print(result);
      if (result["Status"] == "succcess") {
        AchievementView(
          context,
          color: Colors.green,
          icon: Icon(
            Icons.check,
            color: Colors.white,
          ),
          title: "Success!",
          elevation: 20,
          subTitle: "Member registered successfully",
          isCircle: true,
        ).show();
        Navigator.pop(context);
      } else {
        Get.defaultDialog(
          title: "${result["Report"]}",
          titleStyle:
              TextStyle(color: Color(0xFF072A6C), fontWeight: FontWeight.bold),
          middleText: "Please check your registration credentials",
          middleTextStyle: TextStyle(color: Color(0xFF072A6C)),
        ).then((value) => print("done"));
      }
    } catch (e) {
      Get.defaultDialog(
        title: "Error",
        titleStyle:
            TextStyle(color: Color(0xFF072A6C), fontWeight: FontWeight.bold),
        middleText: "An error occurred while trying to register member",
        middleTextStyle: TextStyle(color: Color(0xFF072A6C)),
      ).then((value) => print("done"));
    }
    loading = false;
    setState(() {});
  }

  Widget _input(String hint, TextEditingController controller,
      {bool obscure = false, TextInputType type = TextInputType.text}) {
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
          keyboardType: type,
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
