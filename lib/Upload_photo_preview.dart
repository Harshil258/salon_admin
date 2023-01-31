import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salon_admin/services/MainController.dart';
import 'package:salon_admin/services/auth.dart';

import '../themes.dart';
import 'MyHomePage.dart';
import 'Upload_photo.dart';
import 'common_widgets.dart';

class Upload_Photo_preview extends StatefulWidget {
  final PickedFile? image;
  final File? file;
  final String? link;

  const Upload_Photo_preview(this.image, this.file, this.link, {Key? key})
      : super(key: key);

  @override
  State<Upload_Photo_preview> createState() => _Upload_Photo_previewState();
}

class _Upload_Photo_previewState extends State<Upload_Photo_preview> {
  @override
  Widget build(BuildContext context) {
    var maincontroller = Get.find<MainController>();

    bool loading = false;

    return SafeArea(
      child: Scaffold(
          backgroundColor: MyThemes.darkblack,
          body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: SvgPicture.asset(
                      "assets/backorange.svg",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 0, 0, 0),
                    child: Text(
                      "Upload Your Photo",
                      style: TextStyle(
                          color: MyThemes.txtwhite,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 0, 0, 0),
                    child: Text(
                      "Profile",
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
                        color: MyThemes.txtdarkwhite,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 3, 0, 0),
                    child: Text(
                      "in Profile Section",
                      style: TextStyle(
                        color: MyThemes.txtdarkwhite,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 10, 22, 10),
                    child: Align(
                      alignment: Alignment.center,
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        color: MyThemes.lightblack,
                        child: Container(
                          height: 250,
                          width: 250,
                          alignment: Alignment.center,
                          child: widget.link!.trim().isEmpty
                              ? Center(
                            child: Image.file(File(widget.image!.path),
                                height: 250,
                                width: 250,
                                fit: BoxFit.cover),
                          )
                              : Center(
                            child: CachedNetworkImage(
                              imageUrl: "${widget.link}",
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              height: 250,
                              width: 250,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Upload_Photo()));
                    },
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Common_Widget("Change Again ??")),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  loading
                      ? CircularProgressIndicator()
                      : InkWell(
                    onTap: () async {
                      setState(() {
                        loading = true;
                      });
                      String setuser = "";
                      if (maincontroller.isusermodelinitilize) {
                        print(
                            "asedgsdgsd part is if  ${maincontroller
                                .modelforintent!.aid}");
                        if (!widget.link!.trim().isEmpty) {
                          //have to set image in fire store


                          // maincontroller.storeSaloon(
                          //     maincontroller.modelforintent!.aid.isNull ? "" : maincontroller.modelforintent!.aid.toString(),
                          //     maincontroller.modelforintent!.email.toString(),
                          //     maincontroller.modelforintent!.address,
                          //     maincontroller.modelforintent!.category,
                          //     maincontroller.modelforintent!.image,
                          //     maincontroller.modelforintent!.location,
                          //     maincontroller.modelforintent!.salon_id,
                          //     maincontroller.modelforintent!.salon_name,
                          //     maincontroller.modelforintent!.profileimage,
                          //     maincontroller.modelforintent!.owner_name,
                          //     maincontroller.modelforintent!.owner_surname,
                          //     maincontroller.modelforintent!.owner_mobilenumber)
                          //
                          // setuser = await maincontroller.loadUser(
                          //     maincontroller.modelforintent!.aid,
                          //     maincontroller.modelforintent!.name,
                          //     maincontroller.modelforintent!.surname,
                          //     maincontroller.modelforintent!.email,
                          //     maincontroller
                          //         .modelforintent!.mobilenumber,
                          //     maincontroller.modelforintent!.address,
                          //     maincontroller
                          //         .modelforintent!.photo) as String;
                        } else {
                          // profile is already on fire store

                          // maincontroller.modelforintent!.profileimage =
                          // await maincontroller.uploadImage(widget.image!,
                          //     maincontroller.modelforintent!.aid
                          //         .toString()) as String;
                          //
                          // setuser = await maincontroller.loadUser(
                          //     maincontroller.modelforintent!.uid,
                          //     maincontroller.modelforintent!.name,
                          //     maincontroller.modelforintent!.surname,
                          //     maincontroller.modelforintent!.email,
                          //     maincontroller
                          //         .modelforintent!.mobilenumber,
                          //     maincontroller.modelforintent!.address,
                          //     maincontroller
                          //         .modelforintent!.photo) as String;
                        }
                      } else {
                        User id =
                        await Authentication.getUserId() as User;
                        print("asedgsdgsd part is else  ${id}");

                        maincontroller.modelforintent!.email =
                            id.email.toString();
                        maincontroller.modelforintent!.profileimage =
                        await maincontroller.uploadImage(
                            widget.image!, id.uid) as String;

                        // maincontroller.storeSaloon(
                        //     id.uid,
                        //     id.email.toString(),
                        //     maincontroller.modelforintent!.address.toString(),
                        //     "Male",
                        //     "",
                        //     "",
                        //     id.uid,
                        //     salon_name,
                        //     profileimage,
                        //     owner_name,
                        //     owner_surname,
                        //     owner_mobilenumber)
                        // setuser = await maincontroller.loadUser(
                        //     id.uid,
                        //     maincontroller.modelforintent!.name,
                        //     maincontroller.modelforintent!.surname,
                        //     id.email.toString(),
                        //     maincontroller
                        //         .modelforintent!.mobilenumber,
                        //     maincontroller.modelforintent!.address,
                        //     maincontroller
                        //         .modelforintent!.photo) as String;
                      }
                      print("sdgsdgszdg  ${setuser}");
                      if (await setuser == 'success') {
                        setState(() {
                          loading = false;
                        });
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage()));
                      }
                    },
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Common_Widget("Next")),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
