import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/ServiceModel.dart';
import '../MyThemes.dart';
import 'Add_Services_Screen.dart';

class Add_Service_Image extends StatefulWidget {
  final ServiceModel serviceModel;
  final bool? updateornot;

  const Add_Service_Image(
      {required this.serviceModel, required this.updateornot, Key? key})
      : super(key: key);

  @override
  State<Add_Service_Image> createState() => _Add_Service_ImageState();
}

class _Add_Service_ImageState extends State<Add_Service_Image> {
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
                          await Permission.photos.request();
                          var permissionStatus = await Permission.photos.status;
                          if (permissionStatus.isGranted) {
                            final _imagePicker = ImagePicker();
                            final PickedFile? image = await _imagePicker
                                .getImage(source: ImageSource.gallery);
                            var file = await File(image!.path);
                            if (file != null) {
                              Get.off(AddServiceScreen(
                                file: file,
                                link: "",
                                serviceModel: widget.serviceModel,
                                updateornot: widget.updateornot,
                              ));
                            }
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
                          await Permission.photos.request();
                          var permissionStatus = await Permission.photos.status;
                          if (permissionStatus.isGranted) {
                            final _imagePicker = ImagePicker();
                            final PickedFile? image = await _imagePicker
                                .getImage(source: ImageSource.camera);
                            var file = await File(image!.path);
                            if (file != null) {
                              Get.off(AddServiceScreen(
                                serviceModel: widget.serviceModel,
                                file: file,
                                link: "",
                                updateornot: widget.updateornot,
                              ));
                            }
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
