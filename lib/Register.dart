import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:salon_admin/services/MainController.dart';
import 'login.dart';
import 'services/auth_services.dart';
import 'themes.dart';
import 'widgets/common_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool changebutton = false;

  var maincontroller = Get.find<MainController>();

  final _auth = FirebaseAuth.instance;
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  String? errorMessage;
  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
  }

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
                          hinttxt: "Enter ID you want",
                          icon: Icon(
                            CupertinoIcons.person,
                            color: MyThemes.txtwhite,
                          ),
                          isObscure: false,
                          controller: emailTextController,
                        ),
                        CustomTextField(
                          id: "Password",
                          hinttxt: "Create your Password",
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
                            borderOnForeground: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                    color: changebutton
                                        ? MyThemes.txtwhite
                                        : MyThemes.purple)),
                            child: InkWell(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    changebutton = true;
                                    signUp(emailTextController.text,
                                        passwordTextController.text);
                                  });
                                  await Future.delayed(Duration(seconds: 1));
                                  // await Navigator.pushNamed(
                                  //     context, Routes.homedetail);
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
                                    ? const Icon(
                                        Icons.done,
                                        color: Colors.white,
                                      )
                                    : const Text("Register",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15)),
                              ),
                            ),
                          ),
                        ),
                        FutureBuilder(
                            // future: Authentication.initializeFirebase(
                            //     context: context),
                            builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error initializing Firebase');
                          } else if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
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
                                  onTap: () async {},
                                ),
                              ),
                            );
                          }
                          SizedBox(
                            height: 50,
                          );
                          return Container();
                          // return CircularProgressIndicator(
                          //   valueColor: AlwaysStoppedAnimation<Color>(
                          //     MyThemes.purple,
                          //   ),
                          // );
                        }),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                          child: InkWell(
                              onTap: () {
                                // Navigator.pushNamed(context, Routes.loginroute);
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.fade,
                                        child: LoginPage()));
                              },
                              child: Text(
                                "Want to go Login ??",
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

// void signUp(String email, String password){}}
  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    await maincontroller
        .storeAdmin(user!.uid, user.email.toString())
        .then((value) async {
      print("postDetailsToFirestore ::store ADMIN ${value}");
      if (value == "Admin Stored") {
        await maincontroller
            .storeSaloon(
                user!.uid, user.email.toString(), "", "", "", "", "", "")
            .then((value) async {
          print("postDetailsToFirestore ::store Salon ${value}");
        });
      }
    });

    // AdminModel adminModel = AdminModel();
    // adminModel.email = user.email;
    // adminModel.aid = user.uid;
    //
    // await firebaseFirestore
    //     .collection("Admin")
    //     .doc(user.uid)
    //     .set(adminModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully : ");

    Navigator.pushAndRemoveUntil((context),
        MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
  }
}
