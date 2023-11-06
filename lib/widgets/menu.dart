import 'dart:convert';
import 'dart:io';
import 'package:achievement_view/achievement_view.dart';
import 'package:boxicons/boxicons.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:paulcha/activate.dart';
import 'package:paulcha/add_fund.dart';
import 'package:paulcha/apply_incentives.dart';
import 'package:paulcha/constants/api.dart';
import 'package:paulcha/geneology/team_genealogy.dart';
import 'package:paulcha/geneology/direct_genealogy.dart';
import 'package:paulcha/home.dart';
import 'package:paulcha/latest_news.dart';
import 'package:paulcha/login.dart';
import 'package:paulcha/market/my_orders.dart';
import 'package:paulcha/payment/withdraw_funds.dart';
import 'package:paulcha/profile/change_password.dart';
import 'package:paulcha/profile/edit_profile_setup.dart';
import 'package:paulcha/register_any_member.dart';
import 'package:paulcha/register_fixed_member.dart';
import 'package:paulcha/services/appbackground.service.dart';
import 'package:paulcha/services/http.service.dart';
import 'package:paulcha/services/local_storage.dart';
import 'package:paulcha/support.dart';
import 'package:paulcha/support_requests.dart';
import 'package:paulcha/testify.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:paulcha/transaction/earning_history.dart';
import 'package:paulcha/transaction/funding_history.dart';
import 'package:paulcha/transaction/incentives_history.dart';
import 'package:paulcha/transaction/withdrawal_history.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool transaction = false;
  bool geneology = false;
  bool payment = false;
  bool apply = false;
  bool aktivate = false;
  bool testify = false;
  bool extra = false;

  XFile? image;
  String imageUrl = "";
  String? username;
  String? useremail;

  getUserData() async {
    username = await LocalStorage().getString("username");
    final response =
        await HttpService.post(Api.getEmail, {"username": username});
    useremail = response.data;
    setState(() {});
    getImage();
  }

  getImage() async {
    try {
      Response res = await HttpService.postWithFiles(
          Api.getProfilePics, {"username": username});
      imageUrl = jsonDecode(res.data)[0]["avatar"];
    } catch (e) {
      imageUrl = "";
    }
    setState(() {});
  }

  uploadImage() async {
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      Response res = await HttpService.postWithFiles(Api.changeProfilePics, {
        "username": username,
        "image": MultipartFile.fromBytes(File(image!.path).readAsBytesSync(),
            filename: image!.name)
      });
      final result = jsonDecode(res.data);
      if (result["Status"] == "succcess") {
        getImage();
        AchievementView(
          context,
          color: Color(0xFF072A6C),
          icon: Icon(
            Icons.check,
            color: Colors.white,
          ),
          title: "Success!",
          elevation: 20,
          subTitle: "Profile picture uploaded successfully",
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
          subTitle: "Profile picture upload failed",
          isCircle: true,
        ).show();
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue[600],
              ),
              currentAccountPicture: CircularProfileAvatar(
                "",
                backgroundColor: Color(0xffDCf0EF),
                initialsText: Text(
                  "+",
                  textScaleFactor: 1,
                  style: TextStyle(
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w900,
                      fontSize: 21,
                      color: Colors.white),
                ),
                //cacheImage: true,
                borderWidth: 2,
                elevation: 10,
                radius: 50,
                onTap: () {
                  uploadImage();
                },
                child: imageUrl != ""
                    ? Image.network(
                        "https://empowermentfoodnetwork.com/office/uploads//images//${imageUrl.substring(15, (imageUrl.length))}",
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.camera_alt),
              ),
              accountName: Text("${username != null ? username : ""}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white)),
              accountEmail: Text("${useremail != null ? useremail : ""}",
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white))),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(15),
              children: [
                ListTile(
                  leading: Icon(
                    Boxicons.bxs_home_circle,
                    color: Colors.blue,
                  ),
                  title: Text("Dashboard",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                          child: Home(
                            username: username!,
                          )),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Boxicons.bx_user,
                    color: Colors.blue,
                  ),
                  title: Text("Edit Profile",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                          child: EditProfile()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Boxicons.bx_arrow_from_left,
                    color: Colors.blue,
                  ),
                  title: Text("Change Password",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                          child: ChangePassword()),
                    );
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                Text("REGISTER NEW MEMBER",
                    style: TextStyle(
                        color: Color(0xFF072A6C),
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                SizedBox(
                  height: 15,
                ),
                ListTile(
                  leading: Icon(
                    Boxicons.bx_map,
                    color: Colors.blue,
                  ),
                  title: Text("Register Fixed Member",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                          child: RegisterFixed()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Boxicons.bx_map,
                    color: Colors.blue,
                  ),
                  title: Text("Register Any Member",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                          child: RegisterAny()),
                    );
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                Text("TRANSACTION HISTORY",
                    style: TextStyle(
                        color: Color(0xFF072A6C),
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                SizedBox(
                  height: 15,
                ),
                ListTile(
                  leading: Icon(
                    Boxicons.bx_video_recording,
                    color: Colors.blue,
                  ),
                  title: Text("Transaction",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_back_ios_rounded),
                    onPressed: () {
                      transaction = !transaction;
                      setState(() {});
                    },
                  ),
                ),
                Visibility(
                    visible: transaction,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.arrow_right),
                            title: Text("Wallet Withrawal history",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                    child: WithdrawalHistory()),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.arrow_right),
                            title: Text("Earning history",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                    child: EarningHistory()),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.arrow_right),
                            title: Text("Funding history",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                    child: FundingHistory()),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.arrow_right),
                            title: Text("Incentives history",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                    child: IncentiveHistory()),
                              );
                            },
                          ),
                        ],
                      ),
                    )),
                SizedBox(
                  height: 15,
                ),
                Text("GENEOLOGY",
                    style: TextStyle(
                        color: Color(0xFF072A6C),
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                SizedBox(
                  height: 15,
                ),
                ListTile(
                  leading: Icon(
                    Boxicons.bx_bookmark_heart,
                    color: Colors.blue,
                  ),
                  title: Text("Geneology",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_back_ios_rounded),
                    onPressed: () {
                      geneology = !geneology;
                      setState(() {});
                    },
                  ),
                ),
                Visibility(
                    visible: geneology,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.arrow_right),
                            title: Text("View Team Geneology",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                    child: TeamGenealogy()),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.arrow_right),
                            title: Text("View Direct Referer Genealogy",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                    child: DirectGenealogy()),
                              );
                            },
                          ),
                          /*ListTile(
                            leading: Icon(Icons.arrow_right),
                            title: Text("View Team Table",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            onTap: () {},
                          ),*/
                        ],
                      ),
                    )),
                SizedBox(
                  height: 15,
                ),
                Text("PAYMENTS",
                    style: TextStyle(
                        color: Color(0xFF072A6C),
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                SizedBox(
                  height: 15,
                ),
                ListTile(
                  leading: Icon(
                    Boxicons.bx_repeat,
                    color: Colors.blue,
                  ),
                  title: Text("Payments",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_back_ios_rounded),
                    onPressed: () {
                      payment = !payment;
                      setState(() {});
                    },
                  ),
                ),
                Visibility(
                    visible: payment,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: ListTile(
                        leading: Icon(Icons.arrow_right),
                        title: Text("Withrawal Funds",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeIn,
                                child: WithdrawFund()),
                          );
                        },
                      ),
                    )),
                SizedBox(
                  height: 15,
                ),
                Text("FUND ACCOUNT",
                    style: TextStyle(
                        color: Color(0xFF072A6C),
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                SizedBox(
                  height: 15,
                ),
                ListTile(
                  leading: Icon(
                    Boxicons.bx_cookie,
                    color: Colors.blue,
                  ),
                  title: Text("Fund Now",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                          child: AddFund()),
                    );
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                Text("INCENTIVES",
                    style: TextStyle(
                        color: Color(0xFF072A6C),
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                SizedBox(
                  height: 15,
                ),
                ListTile(
                  leading: Icon(
                    Boxicons.bx_donate_blood,
                    color: Colors.blue,
                  ),
                  title: Text("Apply Now",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                          child: ApplyIncentives()),
                    );
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                Text("MARKET PLACE",
                    style: TextStyle(
                        color: Color(0xFF072A6C),
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                SizedBox(
                  height: 15,
                ),
                /* ListTile(
                  leading: Icon(Boxicons.bx_cart),
                  title: Text("Our shop"),
                ),*/
                ListTile(
                  leading: Icon(
                    Boxicons.bx_help_circle,
                    color: Colors.blue,
                  ),
                  title: Text("My Orders",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                          child: MyOrders()),
                    );
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                Text("ACTIVATE ACCOUNT PAGE",
                    style: TextStyle(
                        color: Color(0xFF072A6C),
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                SizedBox(
                  height: 15,
                ),
                ListTile(
                  leading: Icon(
                    Boxicons.bx_message_square_edit,
                    color: Colors.blue,
                  ),
                  title: Text("Activate",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_back_ios_rounded),
                    onPressed: () {
                      aktivate = !aktivate;
                      setState(() {});
                    },
                  ),
                ),
                Visibility(
                  visible: aktivate,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: ListTile(
                      leading: Icon(Icons.arrow_right),
                      title: Text("Activate Now",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              duration: Duration(milliseconds: 200),
                              curve: Curves.easeIn,
                              child: Activate()),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text("TESTIMONY",
                    style: TextStyle(
                        color: Color(0xFF072A6C),
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                SizedBox(
                  height: 15,
                ),
                ListTile(
                  leading: Icon(
                    Boxicons.bx_grid_alt,
                    color: Colors.blue,
                  ),
                  title: Text("Testify",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_back_ios_rounded),
                    onPressed: () {
                      testify = !testify;
                      setState(() {});
                    },
                  ),
                ),
                Visibility(
                  visible: testify,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: ListTile(
                      leading: Icon(Icons.arrow_right),
                      title: Text("Testify",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              duration: Duration(milliseconds: 200),
                              curve: Curves.easeIn,
                              child: Testify()),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text("OTHER",
                    style: TextStyle(
                        color: Color(0xFF072A6C),
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                SizedBox(
                  height: 15,
                ),
                ListTile(
                  leading: Icon(
                    Boxicons.bx_lock,
                    color: Colors.blue,
                  ),
                  title: Text("Extra",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_back_ios_rounded),
                    onPressed: () {
                      extra = !extra;
                      setState(() {});
                    },
                  ),
                ),
                Visibility(
                    visible: extra,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.arrow_right),
                            title: Text("Contact Support",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                    child: Support()),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.arrow_right),
                            title: Text("View Support Requests",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                    child: SupportRequest()),
                              );
                            },
                          ),
                        ],
                      ),
                    )),
                ListTile(
                  leading: Icon(
                    Boxicons.bx_help_circle,
                    color: Colors.blue,
                  ),
                  title: Text("Latest News",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                          child: LatestNews()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Boxicons.bx_log_out_circle,
                    color: Colors.blue,
                  ),
                  title: Text("Logout",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  onTap: () {
                    LocalStorage().clearPref();
                    //AppbackgroundService().stopBg();
                    Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                          child: Login()),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
