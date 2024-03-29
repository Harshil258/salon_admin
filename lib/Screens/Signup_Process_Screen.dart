import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:salon_admin/services/MainController.dart';

import '../../MyThemes.dart';
import '../widgets/common_widgets.dart';
import 'Upload_Photo_Screen.dart';
import 'Upload_Photo_Preview_Screen.dart';
import '../models/AdminModel.dart';

class Signup_Process_Screen extends StatefulWidget {
  const Signup_Process_Screen({Key? key}) : super(key: key);

  @override
  State<Signup_Process_Screen> createState() => _Signup_Process_ScreenState();
}

class _Signup_Process_ScreenState extends State<Signup_Process_Screen> {
  late String category;
  TextEditingController firstname = new TextEditingController();
  TextEditingController surname = new TextEditingController();
  TextEditingController mobile = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController salonname = new TextEditingController();
  var maincontroller = Get.find<MainController>();

  @override
  void initState() {
    category = "Male";

    try {
      if (maincontroller.isusermodelinitilize) {
        firstname.text = "${maincontroller.modelforintent!.owner_name}";
        surname.text = "${maincontroller.modelforintent!.owner_surname}";
        mobile.text = "${maincontroller.modelforintent!.owner_mobilenumber}";
        address.text = "${maincontroller.modelforintent!.address}";
        salonname.text = "${maincontroller.modelforintent!.salonname}";
      }
    } on Exception catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final _formKeysignupprocess = GlobalKey<FormState>();

    bool loading = false;

    return SafeArea(
      child: Scaffold(
          backgroundColor: MyThemes.darkblack,
          body: Form(
            key: _formKeysignupprocess,
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(22.0),
                        child: SvgPicture.asset(
                          "assets/backpurple.svg",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 0, 0, 0),
                      child: Text(
                        "Fill in your bio to get",
                        style: TextStyle(
                            color: MyThemes.txtwhite,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 0, 0, 0),
                      child: Text(
                        "started",
                        style: TextStyle(
                            color: MyThemes.txtwhite,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 15, 0, 0),
                      child: Text(
                        "This data will be displayed in your account",
                        style: TextStyle(
                          color: MyThemes.txtwhite,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 3, 0, 0),
                      child: Text(
                        "profile for security",
                        style: TextStyle(
                          color: MyThemes.txtwhite,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: MyThemes.lightblack,
                        child: Stack(children: [
                          Container(
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 2, 15, 2),
                            child: TextFormField(
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return "FirstName can not be Empty!";
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: firstname,
                              cursorColor: MyThemes.txtwhite,
                              style: TextStyle(color: MyThemes.txtwhite),
                              decoration: InputDecoration(
                                  hintText: "FirstName",
                                  border: InputBorder.none,
                                  hintStyle:
                                      TextStyle(color: MyThemes.txtdarkwhite)),
                            ),
                          )
                        ]),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: MyThemes.lightblack,
                        child: Stack(children: [
                          Container(
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 2, 15, 2),
                            child: TextFormField(
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return "LastName can not be Empty!";
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: surname,
                              cursorColor: MyThemes.txtwhite,
                              style: TextStyle(color: MyThemes.txtwhite),
                              decoration: InputDecoration(
                                  hintText: "LastName",
                                  border: InputBorder.none,
                                  hintStyle:
                                      TextStyle(color: MyThemes.txtdarkwhite)),
                            ),
                          )
                        ]),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: MyThemes.lightblack,
                        child: Stack(children: [
                          Container(
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 2, 15, 2),
                            child: TextFormField(
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return "Mobile Number can not be Empty!";
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: mobile,
                              cursorColor: MyThemes.txtwhite,
                              style: TextStyle(color: MyThemes.txtwhite),
                              decoration: InputDecoration(
                                  hintText: "Mobile Number",
                                  border: InputBorder.none,
                                  hintStyle:
                                      TextStyle(color: MyThemes.txtdarkwhite)),
                            ),
                          )
                        ]),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: MyThemes.lightblack,
                        child: Stack(children: [
                          Container(
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 2, 15, 2),
                            child: TextFormField(
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return "Salon Name can not be Empty!";
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: salonname,
                              cursorColor: MyThemes.txtwhite,
                              style: TextStyle(color: MyThemes.txtwhite),
                              decoration: InputDecoration(
                                  hintText: "Salon name",
                                  border: InputBorder.none,
                                  hintStyle:
                                      TextStyle(color: MyThemes.txtdarkwhite)),
                            ),
                          )
                        ]),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: MyThemes.lightblack,
                        child: Stack(children: [
                          Container(
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 2, 15, 2),
                            child: TextFormField(
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return "Address can not be Empty!";
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: address,
                              cursorColor: MyThemes.txtwhite,
                              style: TextStyle(color: MyThemes.txtwhite),
                              decoration: InputDecoration(
                                  hintText: "Address",
                                  border: InputBorder.none,
                                  hintStyle:
                                      TextStyle(color: MyThemes.txtdarkwhite)),
                            ),
                          )
                        ]),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: MyThemes.lightblack,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          child: Theme(
                            data: ThemeData(
                                primaryColor: Colors.white,
                                accentColor: Colors.white,
                                hintColor: Colors.white),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: category,
                              dropdownColor: MyThemes.lightblack,
                              items: <String>['Male', 'Female', 'All']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        color: Colors.white,
                                        backgroundColor: MyThemes.lightblack),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                print("category value ${category}");
                                setState(() {
                                  category = value!;
                                });
                              },
                              icon: Icon(Icons.arrow_drop_down),
                              style: TextStyle(color: Colors.white),
                              underline: SizedBox(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    loading
                        ? Center(
                      child: CircularProgressIndicator(
                        color: MyThemes.purple,
                      ),
                    )
                        : Align(
                            alignment: Alignment.bottomCenter,
                            child: InkWell(
                              child: Common_Widget("Next"),
                              onTap: () async {
                                if (_formKeysignupprocess.currentState!
                                    .validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  if (maincontroller
                                          .modelforintent!.owner_name !=
                                      "") {
                                    // when user data is already filled
                                    maincontroller.modelforintent = new AdminModel(
                                        aid:
                                            "${maincontroller.modelforintent!.aid}",
                                        owner_name: "${firstname.text}",
                                        owner_surname: "${surname.text}",
                                        salonname: "${salonname.text}",
                                        email:
                                            "${maincontroller.modelforintent!.email}",
                                        owner_mobilenumber: "${mobile.text}",
                                        address: "${address.text}",
                                        saloonimage:
                                            "${maincontroller.modelforintent!.saloonimage}",
                                        category: category);

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Upload_Photo_preview(
                                                    null,
                                                    maincontroller
                                                        .modelforintent!
                                                        .saloonimage)));
                                  } else {
                                    // when new user
                                    maincontroller.modelforintent = new AdminModel(
                                        aid: maincontroller.modelforintent!.aid,
                                        owner_name: firstname.text,
                                        owner_surname: surname.text,
                                        email:
                                            "${maincontroller.modelforintent!.email}",
                                        owner_mobilenumber: mobile.text,
                                        address: address.text,
                                        saloonimage: "",
                                        salonname: salonname.text,
                                        category: category);

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Upload_Photo_Preview_Screen()));
                                  }
                                }
                              },
                            )),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
