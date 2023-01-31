import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'home.dart';
import 'themes.dart';
import 'Register.dart';
import 'widgets/common_widgets.dart';
import 'MyHomePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool changebutton = false;
  final _formKey = GlobalKey<FormState>();

  // var detailPagecontroller = Get.find<DetailPageController>();
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 50),
                          child: SvgPicture.asset(
                            "assets/login mobile.svg",
                            height: 200,
                          ),
                        ),
                        CustomTextField(
                          id: "ID",
                          hinttxt: "Enter your ID",
                          icon: Icon(
                            CupertinoIcons.person,
                            color: MyThemes.txtwhite,
                          ),
                          isObscure: false,
                          controller: emailTextController,
                        ),
                        CustomTextField(
                          id: "Password",
                          hinttxt: "Enter your PASSWORD",
                          icon: Icon(
                            CupertinoIcons.padlock_solid,
                            color: MyThemes.txtwhite,
                          ),
                          isObscure: true,
                          controller: passwordTextController,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Material(
                            color: changebutton
                                ? MyThemes.purple
                                : Colors.transparent,
                            // borderRadius: BorderRadius.circular(8),
                            borderOnForeground: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                    color: changebutton
                                        ? MyThemes.txtwhite
                                        : MyThemes.purple)),
                            child: InkWell(
                              onTap: () async {
                                if (_validate(
                                    email: emailTextController.text,
                                    password: passwordTextController.text)) {
                                  //chakardu fare
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      });

                                  FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: emailTextController.text,
                                          password: passwordTextController.text)
                                      .then((value) {
                                    Toasty.showtoast("Login Successful");

                                    Get.to(MyHomePage());

                                    // Navigator.pushReplacement(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>  Home()));
                                  }).catchError((e) {
                                    Fluttertoast.showToast(msg: e!.message);
                                  });
                                  passwordTextController.clear();
                                  emailTextController.clear();
                                }
                                // if (_formKey.currentState!.validate()) {
                                //   setState(() {
                                //     changebutton = true;
                                //   });
                                //   await Future.delayed(
                                //       const Duration(seconds: 1));
                                //   // await Navigator.pushNamed(
                                //   //     context, Routes.homedetail);
                                //   setState(() {
                                //     changebutton = false;
                                //   });
                                // }
                              },
                              child: AnimatedContainer(
                                duration: const Duration(
                                    seconds: 1, milliseconds: 100),
                                width: changebutton ? 150 : 350,
                                height: changebutton ? 50 : 60,
                                alignment: Alignment.center,
                                child: changebutton
                                    ? const Icon(
                                        Icons.done,
                                        color: Colors.white,
                                      )
                                    : const Text("LOGIN",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15)),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                                child: Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                    child:
                                        Divider(color: MyThemes.txtdarkwhite))),
                            const Text("OR"),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                child: Divider(
                                  color: MyThemes.txtdarkwhite,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Register()));
                                // Navigator.pushNamed(context, Routes.register);
                                // Navigator.push(
                                //     context,
                                //     PageTransition(
                                //       type: PageTransitionType.fade,
                                //       child: Register(),
                                //       ));
                              },
                              child: Text(
                                "Want to Register ??",
                                style: TextStyle(color: MyThemes.txtdarkwhite),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _validate({required String email, required String password}) {
    if (email.isEmpty && password.isEmpty) {
      Toasty.showtoast('Please Enter Your Credentials');
      return false;
    } else if (email.isEmpty) {
      Toasty.showtoast('Please Enter Your Email Address');
      return false;
    } else if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
        .hasMatch(email)) {
      //(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      Toasty.showtoast('Please Enter Valid Email Address');
      return false;
    } else if (password.isEmpty) {
      Toasty.showtoast('Please Enter Your Password');
      return false;
    } else {
      return true;
    }
  }
}
