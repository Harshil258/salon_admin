import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:salon_admin/services/MainController.dart';
import 'package:salon_admin/services/auth.dart';
import 'package:salon_admin/signup_process.dart';
import 'package:salon_admin/themes.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool editable = false;
    var maincontroller = Get.find<MainController>();

    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            maincontroller.modelforintent!.profileimage!.trim().isEmpty
                ? SvgPicture.asset(
                    "assets/male.svg",
                    width: double.infinity,
                    height: 400,
                    fit: BoxFit.contain,
                  )
                : CachedNetworkImage(
                    imageUrl: "${maincontroller.modelforintent!.profileimage}",
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    width: double.infinity,
                    height: 400,
                    fit: BoxFit.cover,
                  ),
            DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.6,
              maxChildSize: 0.8,
              builder: (context, scrollController) {
                return Scrollbar(
                  child: Container(
                      decoration: BoxDecoration(
                          color: MyThemes.darkblack,
                          borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(40.0),
                              topRight: const Radius.circular(40.0))),
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView(
                          controller: scrollController,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: SvgPicture.asset("assets/divider.svg"),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          22, 0, 22, 0),
                                      child: TextFormField(
                                        cursorColor: MyThemes.txtwhite,
                                        initialValue: ("${maincontroller
                                                        .modelforintent!
                                                        .owner_name} ${maincontroller
                                                        .modelforintent!
                                                        .owner_surname}")
                                                .trim()
                                                .isNotEmpty
                                            ? "${maincontroller.modelforintent!
                                                    .owner_name} ${maincontroller.modelforintent!
                                                    .owner_surname}"
                                            : "Name and Surname is not set",
                                        autofocus: false,
                                        readOnly: editable,
                                        style: TextStyle(
                                            color: MyThemes.txtwhite,
                                            fontSize: 27,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ),
                                InkWell(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(22, 0, 22, 0),
                                    child: SvgPicture.asset(
                                        "assets/Edit Icon.svg"),
                                  ),
                                  onTap: () {
                                    Get.to(Signup_process());
                                  },
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
                              child: Text(
                                maincontroller.modelforintent!.email!.isNotEmpty
                                    ? maincontroller.modelforintent!.email.toString()
                                    : "Please Set Email",
                                style: TextStyle(
                                    color: MyThemes.txtdarkwhite, fontSize: 14),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
                              child: Text(
                                maincontroller
                                        .modelforintent!.owner_mobilenumber!.isNotEmpty
                                    ? maincontroller
                                        .modelforintent!.owner_mobilenumber.toString()
                                    : "Please set mobile number",
                                style: TextStyle(
                                    color: MyThemes.txtdarkwhite, fontSize: 14),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
                              child: Text(
                                maincontroller
                                        .modelforintent!.address!.isNotEmpty
                                    ? maincontroller.modelforintent!.address.toString()
                                    : "Please set Adderess",
                                style: TextStyle(
                                    color: MyThemes.txtdarkwhite, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      )),
                );
              },
            ),
            SafeArea(
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: SvgPicture.asset(
                    "assets/backpurple.svg",
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: MyThemes.darkblack,
        child: InkWell(
          onTap: () {
            Authentication.signOut(context: context);
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              height: 50,
              color: MyThemes.purple,
              child: Center(child: Text("Sign Out")),
            ),
          ),
        ),
      ),
    );
  }
}
