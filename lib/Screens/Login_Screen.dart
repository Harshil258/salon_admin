import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:salon_admin/services/MainController.dart';
import 'package:salon_admin/services/auth.dart';
import 'package:salon_admin/Screens/Signup_Process_Screen.dart';

import '../MyThemes.dart';
import 'Home_Screen.dart';
import '../widgets/common_widgets.dart';
import 'Home_Screen.dart';
import 'Register_Screen.dart';

class Login_Screen extends StatefulWidget {
  const Login_Screen({Key? key}) : super(key: key);

  @override
  State<Login_Screen> createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {
  bool changebutton = false;
  final _formKey = GlobalKey<FormState>();
  var maincontroller = Get.find<MainController>();

  TextEditingController passwordTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Container(
            color: MyThemes.darkblack,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
                  child: Center(
                    child: Text(
                      "Welcome to My Saloon",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                  child: Center(
                    child: Text(
                      "Login to Your Saloon",
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 20),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 50),
                  child: SvgPicture.asset(
                    "assets/login mobile.svg",
                    height: 250,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Container(
                          child: Material(
                            color: changebutton
                                ? MyThemes.purple
                                : Colors.transparent,
                            borderOnForeground: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                    color: changebutton
                                        ? MyThemes.txtwhite
                                        : MyThemes.purple)),
                            child: InkWell(
                              onTap: () async {
                                User? user =
                                    await Authentication.signInWithGoogle(
                                        context: context);
                                if (user != null) {
                                  setState(() {
                                    changebutton = true;
                                  });
                                  await Future.delayed(Duration(seconds: 1));
                                  maincontroller.getuserdata().then(
                                    (value) async {
                                      print(
                                          "maincontroller.modelforintent   ::  ${maincontroller.modelforintent!.toJson()}");
                                      if (maincontroller.modelforintent!.aid !=
                                              "" &&
                                          maincontroller.modelforintent!
                                                  .owner_mobilenumber !=
                                              "") {
                                        Get.offAll(Home_Screen());
                                      } else {
                                        await postDetailsToFirestore(user);
                                        Get.off(Signup_Process_Screen());
                                      }
                                    },
                                  );

                                  setState(() {
                                    changebutton = false;
                                  });
                                }
                              },
                              child: AnimatedContainer(
                                duration:
                                    Duration(seconds: 1, milliseconds: 100),
                                width: changebutton ? 150 : 350,
                                height: changebutton ? 50 : 60,
                                alignment: Alignment.center,
                                child: changebutton
                                    ? Icon(
                                        Icons.done,
                                        color: Colors.white,
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 8, 0),
                                              child: Image.asset(
                                                  "assets/googleicon.png",
                                                  height: 35,
                                                  fit: BoxFit.cover)),
                                          Text("Sign in with Google",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15)),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const Register_Screen()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Want to Register ??",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: MyThemes.txtdarkwhite),
                            ),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  postDetailsToFirestore(User? user) async {
    await maincontroller
        .storeAdmin(user!.uid, user.email.toString())
        .then((value) async {
      print(
          "postDetailsToFirestore ::store ADMIN ${value}  email :: ${user.email.toString()}");
      if (value == "Admin Stored") {
        await maincontroller
            .storeSaloon(user!.uid, user.email.toString(), "", "", "", "", "",
                "", "", "", "", "")
            .then((value) async {
          print("postDetailsToFirestore ::store Salon ${value}");
        });
      }
    });

    Fluttertoast.showToast(msg: "Account created successfully : ");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => Home_Screen()),
        (route) => false);
  }
}
