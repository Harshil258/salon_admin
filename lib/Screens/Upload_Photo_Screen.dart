import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:salon_admin/services/MainController.dart';

import '../../MyThemes.dart';
import 'Upload_Photo_Preview_Screen.dart';

class Upload_Photo_Preview_Screen extends StatefulWidget {
  const Upload_Photo_Preview_Screen({Key? key}) : super(key: key);

  @override
  State<Upload_Photo_Preview_Screen> createState() =>
      _Upload_Photo_Preview_ScreenState();
}

class _Upload_Photo_Preview_ScreenState
    extends State<Upload_Photo_Preview_Screen> {
  @override
  void initState() {
    print(
        "aid aid Upload_Photo = ${Get.find<MainController>().modelforintent!.aid}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyThemes.darkblack,
      body: Container(
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(22.0),
                        child: SvgPicture.asset(
                          "assets/backpurple.svg",
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
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
                      child: InkWell(
                        onTap: () async {
                          Map<Permission, PermissionStatus> statuses = await [
                            Permission.storage,
                          ].request();
                          print(
                              "permissionStatus :: ${statuses[Permission.storage]}");
                          if (statuses[Permission.storage] ==
                              PermissionStatus.granted) {
                            final _imagePicker = ImagePicker();
                            final PickedFile? image = await _imagePicker
                                .getImage(source: ImageSource.gallery);
                            var file = await File(image!.path);
                            if (file != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Upload_Photo_preview(file, "")));
                            }
                          } else {
                            Map<Permission, PermissionStatus> statuses = await [
                              Permission.storage,
                            ].request();
                            print(
                                "permissionStatus :: ${statuses[Permission.storage]}");
                          }
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          color: MyThemes.lightblack,
                          child: Container(
                            height: 150,
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/Gallery Icon.svg",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 0, 22, 10),
                      child: InkWell(
                        onTap: () async {
                          Map<Permission, PermissionStatus> statuses = await [
                            Permission.storage,
                          ].request();
                          print(
                              "permissionStatus :: ${statuses[Permission.storage]}");
                          if (statuses[Permission.storage] ==
                              PermissionStatus.granted) {
                            final _imagePicker = ImagePicker();
                            final PickedFile? image = await _imagePicker
                                .getImage(source: ImageSource.camera);
                            var file = await File(image!.path);
                            if (file != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Upload_Photo_preview(file, "")));
                            }
                          } else {
                            Map<Permission, PermissionStatus> statuses = await [
                              Permission.storage,
                            ].request();
                            print(
                                "permissionStatus :: ${statuses[Permission.storage]}");
                          }
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          color: MyThemes.lightblack,
                          child: Container(
                            height: 150,
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/Camera Icon.svg",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
