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

import '../../MyThemes.dart';
import '../widgets/common_widgets.dart';
import 'Home_Screen.dart';
import 'Upload_Photo_Screen.dart';

class Upload_Photo_preview extends StatefulWidget {
  final File? file;
  final String? link;

  const Upload_Photo_preview(this.file, this.link, {Key? key})
      : super(key: key);

  @override
  State<Upload_Photo_preview> createState() => _Upload_Photo_previewState();
}

class _Upload_Photo_previewState extends State<Upload_Photo_preview> {
  @override
  Widget build(BuildContext context) {
    var maincontroller = Get.find<MainController>();

    print("Upload_Photo_preview");
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
                      "assets/backpurple.svg",
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
                                  child: Image.file(File(widget.file!.path),
                                      height: 250,
                                      width: 250,
                                      fit: BoxFit.cover),
                                )
                              : Center(
                                  child: CachedNetworkImage(
                                    imageUrl: "${widget.link}",
                                    placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(
                                        color: MyThemes.purple,
                                      ),
                                    ),
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
                              builder: (context) =>
                                  Upload_Photo_Preview_Screen()));
                    },
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Common_Widget("Change Again ??")),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  loading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: MyThemes.purple,
                          ),
                        )
                      : InkWell(
                          onTap: () async {
                            setState(() {
                              loading = true;
                            });
                            print("Upload_Photo_preview  on tap  ${maincontroller.isusermodelinitilize}");

                            if (maincontroller.isusermodelinitilize) {
                              print("maincontroller.modelforintent!.aid   ${maincontroller.modelforintent!.toJson().toString()}");
                              if (!widget.link!.trim().isEmpty) {
                                //have to set image in fire store
                                print(
                                    "aid aid  first if = ${maincontroller.modelforintent!.aid}");
                                maincontroller
                                    .storeSaloon(
                                        maincontroller.modelforintent!.aid
                                            .toString(),
                                        maincontroller.modelforintent!.email
                                            .toString(),
                                        maincontroller.modelforintent!.address
                                            .toString(),
                                        maincontroller.modelforintent!.category
                                            .toString(),
                                        maincontroller.modelforintent!.image
                                            .toString(),
                                        maincontroller.modelforintent!.location
                                            .toString(),
                                        maincontroller.modelforintent!.aid
                                            .toString(),
                                        maincontroller.modelforintent!.salonname
                                            .toString(),
                                        maincontroller
                                            .modelforintent!.saloonimage
                                            .toString(),
                                        maincontroller
                                            .modelforintent!.owner_name
                                            .toString(),
                                        maincontroller
                                            .modelforintent!.owner_surname
                                            .toString(),
                                        maincontroller
                                            .modelforintent!.owner_mobilenumber
                                            .toString())
                                    .then((value) {
                                  if (value == 'Salon Stroed') {
                                    setState(() {
                                      loading = false;
                                    });
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Home_Screen()));
                                  }
                                });
                              } else if (!widget.file.isNull) {
                                print(
                                    "aid aid  first else = ${maincontroller.modelforintent!.aid}");

                                maincontroller.modelforintent!.saloonimage =
                                    await maincontroller.uploadImage(
                                        widget.file!,
                                        maincontroller.modelforintent!.aid
                                            .toString()) as String;

                                maincontroller
                                    .storeSaloon(
                                        maincontroller.modelforintent!.aid
                                            .toString(),
                                        maincontroller.modelforintent!.email
                                            .toString(),
                                        maincontroller.modelforintent!.address
                                            .toString(),
                                        maincontroller.modelforintent!.category
                                            .toString(),
                                        maincontroller.modelforintent!.image
                                            .toString(),
                                        maincontroller.modelforintent!.location
                                            .toString(),
                                        maincontroller.modelforintent!.aid
                                            .toString(),
                                        maincontroller.modelforintent!.salonname
                                            .toString(),
                                        maincontroller
                                            .modelforintent!.saloonimage
                                            .toString(),
                                        maincontroller
                                            .modelforintent!.owner_name
                                            .toString(),
                                        maincontroller
                                            .modelforintent!.owner_surname
                                            .toString(),
                                        maincontroller
                                            .modelforintent!.owner_mobilenumber
                                            .toString())
                                    .then((value) {
                                  if (value == 'Salon Stroed') {
                                    setState(() {
                                      loading = false;
                                    });
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Home_Screen()));
                                  }
                                });
                              }
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
