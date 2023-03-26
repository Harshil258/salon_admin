import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:salon_admin/models/ServiceModel.dart';
import 'package:salon_admin/MyThemes.dart';

import '../widgets/common_widgets.dart';
import 'Home_Screen.dart';
import '../services/MainController.dart';
import 'Add_Service_Image.dart';

class AddServiceScreen extends StatefulWidget {
  final ServiceModel serviceModel;
  final File? file;
  final String? link;
  final bool? updateornot;

  const AddServiceScreen(
      {required this.file,
      required this.link,
      required this.serviceModel,
      required this.updateornot,
      Key? key})
      : super(key: key);

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  late String service_gender;
  late String salon_image;
  TextEditingController service_title = new TextEditingController();
  TextEditingController service_description = new TextEditingController();
  TextEditingController service_price = new TextEditingController();
  var maincontroller = Get.find<MainController>();
  bool loading = false;

  @override
  void initState() {
    print("srfhetrht   ${widget.serviceModel.service_gender}");
    print("srffdrhghetrht   ${widget.link}");
    service_gender = widget.serviceModel.service_gender;
    service_title.text = widget.serviceModel.title;
    service_description.text = widget.serviceModel.description;
    service_price.text = widget.serviceModel.price.toString();
  }

  Future<bool> isThereAnyBooking(String serviceId) async {
    print("serviceId ::  ${serviceId}");
    var instance = await FirebaseFirestore.instance
        .collectionGroup('bookings')
        .where('servicesId', arrayContainsAny: [serviceId]).get();

    if (instance.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _formKeysignupprocess = GlobalKey<FormState>();

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
                        "Fill in your new Service",
                        style: TextStyle(
                            color: MyThemes.txtwhite,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 0, 0, 0),
                      child: Text(
                        "Details",
                        style: TextStyle(
                            color: MyThemes.txtwhite,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 15, 0, 0),
                      child: Text(
                        "Click here to change Service profile",
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
                      padding: const EdgeInsets.fromLTRB(22, 10, 22, 10),
                      child: GestureDetector(
                        onTap: () {
                          Get.off(Add_Service_Image(
                            serviceModel: widget.serviceModel,
                            updateornot: widget.updateornot,
                          ));
                        },
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
                                      child: Image.file(widget.file!,
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
                                  return "Service title can not be Empty!";
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: service_title,
                              cursorColor: MyThemes.txtwhite,
                              style: TextStyle(color: MyThemes.txtwhite),
                              decoration: InputDecoration(
                                  hintText: "Service title",
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
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: service_description,
                              cursorColor: MyThemes.txtwhite,
                              style: TextStyle(color: MyThemes.txtwhite),
                              decoration: InputDecoration(
                                  hintText: "Description",
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
                                // print("sTERJHDRT ${int.parse(text.toString()).toInt()}");
                                if (text == null || text.isEmpty) {
                                  // return "Price can not be Empty! ${int.parse(text.toString())}";
                                  return "Price can not be Empty! ${text.toString()}";
                                } else if (text != null &&
                                    int.parse(text).toInt() <= 0) {
                                  return "Price can not be Zero or Less then it";
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: service_price,
                              keyboardType: TextInputType.number,
                              cursorColor: MyThemes.txtwhite,
                              style: TextStyle(color: MyThemes.txtwhite),
                              decoration: InputDecoration(
                                  hintText: "Service Price",
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
                              value: service_gender,
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
                                print("category value ${service_gender}");
                                setState(() {
                                  service_gender = value!;
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
                      height: 50,
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
                              child: Common_Widget("Save"),
                              onTap: () async {
                                if (_formKeysignupprocess.currentState!
                                    .validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  if (maincontroller.modelforintent != null) {
                                    print("updating");
                                    if (widget.link != "") {
                                      print(
                                          "updating data :: ${widget.serviceModel.toJson().toString()}");

                                      await maincontroller.storeService(
                                          service_title.text.toString(),
                                          int.parse(service_price.text),
                                          service_description.text.toString(),
                                          widget.link.toString(),
                                          maincontroller.modelforintent!.aid!,
                                          widget.serviceModel.serviceId,
                                          service_gender);

                                      await maincontroller
                                          .loadservicesFromfirebase(
                                              maincontroller.modelforintent!.aid
                                                  .toString());

                                      setState(() {
                                        loading = false;
                                      });
                                      Get.back();
                                    } else if (!widget.file.isNull) {
                                      var image = await maincontroller
                                          .uploadServiceImage(
                                              widget.file!,
                                              widget.serviceModel.serviceId
                                                  .toString());

                                      await maincontroller.storeService(
                                          service_title.text.toString(),
                                          int.parse(service_price.text),
                                          service_description.text.toString(),
                                          image!,
                                          maincontroller.modelforintent!.aid!,
                                          widget.serviceModel.serviceId
                                              .toString(),
                                          service_gender);

                                      await maincontroller
                                          .loadservicesFromfirebase(
                                              maincontroller.modelforintent!.aid
                                                  .toString());

                                      setState(() {
                                        loading = false;
                                      });
                                      Get.back();
                                    }
                                  } else {
                                    var snackBar = SnackBar(
                                        content: Text('Please Login First'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                }
                              },
                            )),
                    (widget.updateornot == true)
                        ? Center(
                            child: GestureDetector(
                                onTap: () async {
                                  print(
                                      "isThereAnyBooking :: ${await isThereAnyBooking(widget.serviceModel.serviceId)}");
                                  if (await isThereAnyBooking(
                                      widget.serviceModel.serviceId)) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Warning",
                                              style: TextStyle(
                                                  color: MyThemes.darkblack)),
                                          content: Text(
                                              "You cannot delete this service because it is used in a booking.",
                                              style: TextStyle(
                                                  color: MyThemes.darkblack)),
                                          actions: [
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("OK"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    await FirebaseFirestore.instance
                                        .collection("service")
                                        .doc(widget.serviceModel.serviceId)
                                        .delete();
                                    await maincontroller
                                        .loadservicesFromfirebase(maincontroller
                                            .modelforintent!.aid
                                            .toString());
                                    Navigator.of(context).pop();
                                    Get.back();
                                  }
                                },
                                child: Common_Widget("Delete Service")),
                          )
                        : Container()
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
