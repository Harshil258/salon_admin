import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_admin/models/ServiceModel.dart';
import 'package:salon_admin/services/MainController.dart';

import '../MyThemes.dart';
import '../widgets/common_widgets.dart';
import 'Add_Services_Screen.dart';

class Search_Screen extends StatefulWidget {
  const Search_Screen({Key? key}) : super(key: key);

  @override
  State<Search_Screen> createState() => _Search_ScreenState();
}

class _Search_ScreenState extends State<Search_Screen> {
  var maincontroller = Get.find<MainController>();

  late Future<List<ServiceModel>> futureSearchList;

  TextEditingController searchtext = new TextEditingController();

  Future<List<ServiceModel>> getfuturelist(String searchtxt) async {
    if (searchtext.toString().trim() == "") {
      return maincontroller.servicemodellist;
    } else {
      return maincontroller.servicemodellist
          .where((element) => element.title
              .toLowerCase()
              .contains(searchtxt.toLowerCase().toString()))
          .toList();
    }
  }

  @override
  initState() {
    super.initState();
    futureSearchList = getfuturelist("");
  }

  @override
  Widget build(BuildContext context) {
    Widget sliverlist;

    return SafeArea(
        child: Scaffold(
      backgroundColor: MyThemes.darkblack,
      appBar: AppBar(
        flexibleSpace: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            color: MyThemes.darkblack,
            borderOnForeground: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: MyThemes.purple)),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: TextFormField(
                            textAlignVertical: TextAlignVertical.center,
                            onChanged: (text) {
                              setState(() {
                                futureSearchList = getfuturelist(text);
                              });
                              futureSearchList.then((value) {
                                print("asdgfsdgsdfg ${value.toSet()}");
                              });
                            },
                            controller: searchtext,
                            cursorColor: MyThemes.txtwhite,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: MyThemes.txtdarkwhite, fontSize: 15),
                            decoration: InputDecoration(
                                hintText: "Search Your Favourite Saloon!!",
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(bottom: 10),
                                hintStyle:
                                    TextStyle(color: MyThemes.txtdarkwhite)),
                          ),
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
      ),
      body: Container(
        child: CustomScrollView(slivers: [
          FutureBuilder<List<ServiceModel>>(
            future: futureSearchList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      futureSearchList.then((value) {
                        print("asdgfsdgdgsdgsdfg ${value.toSet()}");
                      });
                      return GestureDetector(
                        onTap: () {
                          Get.to(AddServiceScreen(
                            serviceModel: ServiceModel(
                                title: snapshot.data![index].title,
                                description: snapshot.data![index].description,
                                image: snapshot.data![index].image,
                                price: snapshot.data![index].price,
                                salonId: snapshot.data![index].salonId,
                                serviceId: snapshot.data![index].serviceId,
                                service_gender:
                                    snapshot.data![index].service_gender),
                            file: null,
                            link: snapshot.data![index].image,
                            updateornot: true,
                          ));
                          //  https://cdn-icons-png.flaticon.com/512/8583/8583104.png
                        },
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: custom_item_view(
                              Name: snapshot.data![index].title,
                              Price: snapshot.data![index].price,
                              Description: snapshot.data![index].description,
                              imagelink: snapshot.data![index].image,
                            )),
                      );
                    },
                    childCount: snapshot.data!.length,
                  ),

                  //SliverChildBuildDelegate
                );
              } else {
                return SliverToBoxAdapter(
                    child: Center(child: Text("We do not have services")));
              }
            },
          )
        ]),
      ),
    ));
  }
}
