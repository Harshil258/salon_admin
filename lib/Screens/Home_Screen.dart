import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:geocoder/geocoder.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:salon_admin/models/ServiceModel.dart';
import 'package:salon_admin/Screens/Profile_Screen.dart';
import 'package:salon_admin/services/MainController.dart';
import 'package:salon_admin/MyThemes.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/common_widgets.dart';
import 'Add_Services_Screen.dart';
import 'Search_Screen.dart';
import '../models/AdminModel.dart';

class Home_Screen extends StatefulWidget {
  const Home_Screen({Key? key}) : super(key: key);

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

void launchMap(String address) async {
  String query = Uri.encodeComponent(address);
  String googleUrl = "https://www.google.com/maps/search/?api=1&query=$query";

  // if (await canLaunch(googleUrl)) {
  try {
    await launch(googleUrl);
  } on Exception catch (e) {
    print("can not launch");
  }
  // }else{
  //   print("can not launch");
  // }
}

Future<Address> getUserLocation() async {
  //call this async method from whereever you need

  LocationData? myLocation;
  String error;
  Location location = Location();
  try {
    myLocation = await location.getLocation();
  } on PlatformException catch (e) {
    if (e.code == 'PERMISSION_DENIED') {
      error = 'please grant permission';
      print(error);
    }
    if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
      error = 'permission denied- please enable it from app settings';
      print(error);
    }
    myLocation = null;
  }
  var currentLocation = myLocation;
  final coordinates = Coordinates(myLocation!.latitude, myLocation!.longitude);
  var addresses =
      await Geocoder.local.findAddressesFromCoordinates(coordinates);
  var first = addresses.first;
  print(
      ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
  return first;
}

class _Home_ScreenState extends State<Home_Screen> {
  late List<AdminModel> salonlist;
  late final Future<List<AdminModel>> future;
  var maincontroller = Get.find<MainController>();
  late List<ServiceModel>? servicelist = null;

  late Future<Address> first;
  late Address addressfinal;
  late Widget sliverlist;

  @override
  initState() {
    super.initState();
    getAdminDataAndService();
    // future =
    first = getUserLocation();
  }

  getAdminDataAndService() async {
    if (maincontroller.isusermodelinitilize == false) {
      print(
          "MYHomePage ::    maincontroller.isusermodelinitilize  after maincontroller.getuserdata() ${maincontroller.isusermodelinitilize}");
      await maincontroller.getuserdata();
      print(
          "MYHomePage ::    maincontroller.isusermodelinitilize  after maincontroller.getuserdata() ${maincontroller.isusermodelinitilize}");
    }
    maincontroller.loadservicesFromfirebase(
        maincontroller.modelforintent!.aid.toString());
  }

  @override
  Widget build(BuildContext context) {
    Widget sliverlist;

    return SafeArea(
      child: Scaffold(
        backgroundColor: MyThemes.darkblack,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: CustomScrollView(
            slivers: [
              SliverStickyHeader(
                header: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                  child: Container(
                    color: MyThemes.darkblack,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Icon(
                                    CupertinoIcons.home,
                                    color: MyThemes.purple,
                                    size: 20.0,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Home",
                                    style: TextStyle(
                                        color: MyThemes.txtwhite,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    CupertinoIcons.chevron_down,
                                    color: MyThemes.txtwhite,
                                    size: 18.0,
                                  )
                                ],
                              ),
                              GetBuilder<MainController>(
                                builder: (controller) {
                                  return (maincontroller.modelforintent != null)
                                      ? FutureBuilder<Address>(
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return InkWell(
                                                  onTap: () async {
                                                    print("open google map");
                                                    launchMap(
                                                        "${snapshot.data!.addressLine} ${snapshot.data!.featureName} ${snapshot.data!.thoroughfare}");
                                                  },
                                                  child: Text(
                                                    "${snapshot.data!.addressLine} ${snapshot.data!.featureName} ${snapshot.data!.thoroughfare}",
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                  ));
                                            } else {
                                              return Text("No Address Defined");
                                            }
                                          },
                                          future: first,
                                        )
                                      : Text("No Address Defined");
                                },
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Profile_Screen(),
                                ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: (maincontroller.modelforintent != null &&
                                      maincontroller
                                              .modelforintent?.saloonimage !=
                                          null)
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "${maincontroller.modelforintent!.saloonimage}",
                                        errorWidget: (context, url, error) =>
                                            Icon(
                                          CupertinoIcons.person_crop_circle,
                                          size: 35.0,
                                          color: MyThemes.txtdarkwhite,
                                        ),
                                        placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator(
                                          color: MyThemes.purple,
                                        )),
                                        width: 35,
                                        height: 35,
                                        fit: BoxFit.cover,
                                      ))
                                  : Icon(
                                      CupertinoIcons.person_crop_circle,
                                      size: 28.0,
                                      color: MyThemes.txtdarkwhite,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverAppBar(
                backgroundColor: MyThemes.darkblack,
                foregroundColor: MyThemes.darkblack,
                pinned: true,
                floating: false,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: Container(
                    color: MyThemes.darkblack,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Expanded(
                          child: Material(
                            color: MyThemes.darkblack,
                            borderOnForeground: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: MyThemes.purple)),
                            child: Container(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 6, 16, 6),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Search_Screen()));
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Search Perticular Services!!",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: MyThemes.txtdarkwhite,
                                              fontSize: 15),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Icon(
                                          CupertinoIcons.search,
                                          size: 22.0,
                                          color: MyThemes.txtdarkwhite,
                                        ),
                                      )
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
                ),
              ),
              GetBuilder<MainController>(
                builder: (controller) {
                  if (controller.servicemodellist.isNotEmpty == true) {
                    sliverlist = SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Get.to(AddServiceScreen(
                                serviceModel: ServiceModel(
                                    title: controller
                                        .servicemodellist[index].title,
                                    description: controller
                                        .servicemodellist[index].description,
                                    image: controller
                                        .servicemodellist[index].image,
                                    price: controller
                                        .servicemodellist[index].price,
                                    salonId: controller
                                        .servicemodellist[index].salonId,
                                    serviceId: controller
                                        .servicemodellist[index].serviceId,
                                    service_gender: controller
                                        .servicemodellist[index]
                                        .service_gender),
                                file: null,
                                link: controller.servicemodellist[index].image,
                                updateornot: true,
                              ));
                              //  https://cdn-icons-png.flaticon.com/512/8583/8583104.png
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                              child: custom_item_view(
                                Name: controller.servicemodellist[index].title,
                                Price: controller.servicemodellist[index].price,
                                Description: controller
                                    .servicemodellist[index].description,
                                imagelink:
                                    controller.servicemodellist[index].image,
                              ),
                            ),
                          );
                        },
                        childCount: controller.servicemodellist.length,
                      ), //SliverChildBuildDelegate
                    );
                  } else {
                    sliverlist = SliverToBoxAdapter(
                        child: Center(child: Text("We do not have services")));
                  }
                  return sliverlist;
                },
              )
            ],
          ),
        ),
        bottomNavigationBar: Container(
          color: MyThemes.darkblack,
          child: InkWell(
            onTap: () {
              print(
                  "fdhtfrh  ${maincontroller.modelforintent!.toJson().toString()}");
              if (maincontroller.modelforintent!.salonname!.isEmpty &&
                  maincontroller.modelforintent!.owner_name!.isEmpty &&
                  maincontroller.modelforintent!.owner_surname!.isEmpty &&
                  maincontroller.modelforintent!.owner_mobilenumber!.isEmpty) {
                var snackBar =
                    SnackBar(content: Text('Please Fill These Details First'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                Get.to(Profile_Screen());
              } else {
                var random = Random();
                var serviceId = random.nextInt(4294967296);

                Get.to(AddServiceScreen(
                  serviceModel: ServiceModel(
                      title: "",
                      description: "",
                      image: "",
                      price: 0,
                      salonId: maincontroller.modelforintent!.aid!,
                      serviceId: serviceId.toString(),
                      service_gender: "Male"),
                  file: null,
                  link:
                      "https://cdn-icons-png.flaticon.com/512/8583/8583104.png",
                  updateornot: false,
                ));
              }

              //  https://cdn-icons-png.flaticon.com/512/8583/8583104.png
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                height: 50,
                color: MyThemes.purple,
                child: Center(child: Text("Add Service")),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
