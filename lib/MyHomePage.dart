import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:geocoder/geocoder.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:salon_admin/profile.dart';
import 'package:salon_admin/services/MainController.dart';
import 'package:salon_admin/themes.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/AdminModel.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
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

class _MyHomePageState extends State<MyHomePage> {
  late List<AdminModel> salonlist;
  late final Future<List<AdminModel>> future;
  var maincontroller = Get.find<MainController>();
  late Future<Address> first;
  late Address addressfinal;

  @override
  initState() {
    super.initState();

    // print("MYHomePage ::    maincontroller.isusermodelinitilize ${maincontroller.isusermodelinitilize}");
    // if (maincontroller.isusermodelinitilize == false) {
    //   maincontroller.getuserdata();
    //   print("MYHomePage ::    maincontroller.isusermodelinitilize  after maincontroller.getuserdata() ${maincontroller.isusermodelinitilize}");
    // }
    // maincontroller.callfirebase();


    getAdminDataAndService();
    // future =
    first = getUserLocation();
  }

  getAdminDataAndService() async {
    if (maincontroller.isusermodelinitilize == false) {
      print("MYHomePage ::    maincontroller.isusermodelinitilize  after maincontroller.getuserdata() ${maincontroller.isusermodelinitilize}");
      await maincontroller.getuserdata();
      print("MYHomePage ::    maincontroller.isusermodelinitilize  after maincontroller.getuserdata() ${maincontroller.isusermodelinitilize}");
    }
    maincontroller.callfirebase();
  }
  @override
  Widget build(BuildContext context) {
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
                                  builder: (context) => Profile(),
                                ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: (maincontroller.modelforintent != null &&
                                      maincontroller.modelforintent?.image !=
                                          null)
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "${maincontroller.modelforintent!.image}",
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
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             search_page()));
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Search Your Favourite Saloon!!",
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
            ],
          ),
        ),
      ),
    );
  }
}
