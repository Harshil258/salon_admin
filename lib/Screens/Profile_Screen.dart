import 'package:cached_network_image/cached_network_image.dart';
import 'package:cell_calendar/cell_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:salon_admin/services/MainController.dart';
import 'package:salon_admin/services/auth.dart';
import 'package:salon_admin/Screens/Signup_Process_Screen.dart';
import 'package:salon_admin/MyThemes.dart';
import 'package:intl/intl.dart';

import '../models/BookingService.dart';
import '../models/ServiceModel.dart';
import '../widgets/common_widgets.dart';

class Profile_Screen extends StatefulWidget {
  const Profile_Screen({Key? key}) : super(key: key);

  @override
  State<Profile_Screen> createState() => _Profile_ScreenState();
}

class _Profile_ScreenState extends State<Profile_Screen> {
  var detailPagecontroller = Get.find<MainController>();
  final firestore = FirebaseFirestore.instance;
  List<BookingService> listOfBookingServices = <BookingService>[].obs;

  @override
  void initState() {
    super.initState();
    // detailPagecontroller.bookingEvents.clear();
    // fetchConfirmedBookings(detailPagecontroller.modelforintent!.aid.toString())
    //     .then((value) {
    //   value.forEach((element) {
    //     print("rherhrh  :: ${element.bookingID}");
    //     detailPagecontroller.bookingEvents.add(CalendarEvent(
    //         eventName: element.userId.toString(),
    //         eventDate: element.bookingStart,
    //         bookingStart: element.bookingStart,
    //         bookingEnd: element.bookingEnd,
    //         servicesId: element.servicesId,
    //         userEmail: element.userEmail,
    //         eventBackgroundColor: MyThemes.purple,
    //         userName: element.userName.toString(),
    //         userPhoneNumber: element.userPhoneNumber,
    //         status: element.status,
    //         bookingID: element.bookingID,
    //         servicePrice: element.servicePrice!.toInt()));
    //   });
    //   listOfBookingServices = value;
    //   setState(() {});
    // });
    callinitstate();
  }

  void callinitstate() {
    detailPagecontroller.bookingEvents.clear();
    fetchConfirmedBookings(detailPagecontroller.modelforintent!.aid.toString())
        .then((value) {
      value.forEach((element) {
        print("rherhrh  :: ${element.bookingID}");
        detailPagecontroller.bookingEvents.add(CalendarEvent(
            eventName: element.userId.toString(),
            eventDate: element.bookingStart,
            bookingStart: element.bookingStart,
            bookingEnd: element.bookingEnd,
            servicesId: element.servicesId,
            userEmail: element.userEmail,
            eventBackgroundColor: MyThemes.purple,
            userName: element.userName.toString(),
            userPhoneNumber: element.userPhoneNumber,
            status: element.status,
            bookingID: element.bookingID,
            servicePrice: element.servicePrice!.toInt()));
      });
      listOfBookingServices = value;
      setState(() {});
    });
  }

  Future<List<BookingService>> fetchConfirmedBookings(String aid) async {
    List<BookingService> bookingstemp = [];

    var instance = await FirebaseFirestore.instance
        .collection('salons')
        .doc(aid)
        .collection('bookings')
        .get();

    bookingstemp = instance.docs.map((doc) {
      print("dhjsetjghjdgfjt    ::  ${doc.id}");

      return BookingService.fromJson(doc.id, doc.data());
    }).toList();

    instance.docs.forEach((element) {
      print("dhjsetjt    ::  ${element.id}");
    });

    print('All Bookings With this id :: ${aid} :: ${bookingstemp[0].toJson()}');
    List<BookingService> finalbooking = bookingstemp
      ..sort((a, b) => a.bookingStart.compareTo(b.bookingStart));
    finalbooking.forEach((element) {
      print('All Bookings With IDS:: ${element.toJson()}');
    });
    return finalbooking;
  }

  Future<List<ServiceModel>> fetchServiceDetails(
      List<dynamic>? serviceids) async {
    print(
        "fetchServiceDetails :: serviceids  :: ${serviceids!.toSet().toString()}");
    List<ServiceModel> servicelist = [];

    for (var element in serviceids!) {
      var instance = await FirebaseFirestore.instance
          .collection("service")
          .doc(element.toString())
          .get();

      print("fetchServiceDetails :: forloop  :: ${instance.data().toString()}");
      print(
          "fetchServiceDetails :: forloop  :: ${fromQuerySnapshotService(instance)}");
      var service = fromQuerySnapshotService(instance);
      print("fetchServiceDetails :: service toJson :: ${service.toJson()}");
      servicelist.add(service);
    }
    print(
        "fetchServiceDetails :: servicelist  :: ${servicelist!.toSet().toString()}");
    return servicelist;
  }

  @override
  Widget build(BuildContext context) {
    bool editable = false;
    var maincontroller = Get.find<MainController>();
    final cellCalendarPageController = CellCalendarPageController();

    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            maincontroller.modelforintent!.saloonimage!.trim().isEmpty
                ? SvgPicture.asset(
                    "assets/male.svg",
                    width: double.infinity,
                    height: 400,
                    fit: BoxFit.contain,
                  )
                : CachedNetworkImage(
                    imageUrl: "${maincontroller.modelforintent!.saloonimage}",
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(
                        color: MyThemes.purple,
                      ),
                    ),
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
                                        initialValue:
                                            ("${maincontroller.modelforintent!.salonname}")
                                                    .trim()
                                                    .isNotEmpty
                                                ? "${maincontroller.modelforintent!.salonname}"
                                                : "Salon name is not set",
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
                                    Get.to(Signup_Process_Screen());
                                  },
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
                              child: Text(
                                ("${maincontroller.modelforintent!.owner_name} ${maincontroller.modelforintent!.owner_surname}")
                                        .trim()
                                        .isNotEmpty
                                    ? "${maincontroller.modelforintent!.owner_name} ${maincontroller.modelforintent!.owner_surname}"
                                    : "Name and Surname is not set",
                                style: TextStyle(
                                    color: MyThemes.txtdarkwhite, fontSize: 14),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
                              child: Text(
                                maincontroller.modelforintent!.email!.isNotEmpty
                                    ? maincontroller.modelforintent!.email
                                        .toString()
                                    : "Please Set Email",
                                style: TextStyle(
                                    color: MyThemes.txtdarkwhite, fontSize: 14),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
                              child: Text(
                                maincontroller.modelforintent!
                                        .owner_mobilenumber!.isNotEmpty
                                    ? maincontroller
                                        .modelforintent!.owner_mobilenumber
                                        .toString()
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
                                    ? maincontroller.modelforintent!.address
                                        .toString()
                                    : "Please set Adderess",
                                style: TextStyle(
                                    color: MyThemes.txtdarkwhite, fontSize: 14),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(22, 5, 22, 0),
                              child: Text(
                                "My Bookings :",
                                style: TextStyle(
                                    color: MyThemes.txtwhite, fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(22, 15, 22, 15),
                              child: Container(
                                height: 600,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.black, width: 1),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20))),
                                child: CellCalendar(
                                  cellCalendarPageController:
                                      cellCalendarPageController,
                                  events: detailPagecontroller.bookingEvents,
                                  daysOfTheWeekBuilder: (dayIndex) {
                                    final labels = [
                                      "S",
                                      "M",
                                      "T",
                                      "W",
                                      "T",
                                      "F",
                                      "S"
                                    ];
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 4.0),
                                      child: Text(
                                        labels[dayIndex],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  },
                                  monthYearLabelBuilder: (datetime) {
                                    final year = datetime!.year.toString();
                                    final month = datetime.month.monthName;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 16),
                                          Text(
                                            "$month  $year",
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: Icon(Icons.calendar_today),
                                            onPressed: () {
                                              cellCalendarPageController
                                                  .animateToDate(
                                                DateTime.now(),
                                                curve: Curves.linear,
                                                duration:
                                                    Duration(milliseconds: 300),
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  onCellTapped: (date) {
                                    final eventsOnTheDate = detailPagecontroller
                                        .bookingEvents
                                        .where((event) {
                                      final eventDate = event.eventDate;
                                      return eventDate.year == date.year &&
                                          eventDate.month == date.month &&
                                          eventDate.day == date.day;
                                    }).toList();
                                    showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                              title: Text(
                                                date.month.monthName +
                                                    " " +
                                                    date.day.toString(),
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              content: SizedBox(
                                                // 70% height
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .9,
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children:
                                                        eventsOnTheDate.map(
                                                      (event) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: MyThemes
                                                                        .darkblack,
                                                                    width: 1),
                                                                borderRadius:
                                                                    const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            20))),
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Text(
                                                                  "${event.userName}",
                                                                  style: TextStyle(
                                                                      color: MyThemes
                                                                          .darkblack,
                                                                      fontSize:
                                                                          18),
                                                                ),
                                                                Text(
                                                                  "${event.userPhoneNumber}",
                                                                  style: TextStyle(
                                                                      color: MyThemes
                                                                          .darkblack,
                                                                      fontSize:
                                                                          18),
                                                                ),
                                                                FutureBuilder<
                                                                    List<
                                                                        ServiceModel>>(
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    if (snapshot
                                                                            .connectionState ==
                                                                        ConnectionState
                                                                            .done) {
                                                                      if (snapshot
                                                                          .hasData) {
                                                                        print(
                                                                            "services :: drfhdfh :${snapshot.data!.toSet()} ");
                                                                        return Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              ListView.builder(
                                                                            shrinkWrap:
                                                                                true,
                                                                            physics:
                                                                                NeverScrollableScrollPhysics(),
                                                                            itemBuilder:
                                                                                (context, index) {
                                                                              print("services :: title :${snapshot.data![index].title} ");
                                                                              return Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  children: [
                                                                                    Row(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                      children: [
                                                                                        Column(
                                                                                          children: [
                                                                                            snapshot.data![index].image!.isNotEmpty
                                                                                                ? ClipRRect(
                                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                                    child: CachedNetworkImage(
                                                                                                      imageUrl: "${snapshot.data![index].image}",
                                                                                                      placeholder: (context, url) => Center(
                                                                                                          child: CircularProgressIndicator(
                                                                                                        color: MyThemes.purple,
                                                                                                      )),
                                                                                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                                                                                      height: 120,
                                                                                                      width: 110,
                                                                                                      fit: BoxFit.cover,
                                                                                                    ),
                                                                                                  )
                                                                                                : SizedBox(
                                                                                                    height: 50,
                                                                                                    width: 110,
                                                                                                  ),
                                                                                            Padding(
                                                                                              padding: const EdgeInsets.all(8.0),
                                                                                              child: Text(
                                                                                                "${snapshot.data![index].price.toString()} ₹",
                                                                                                style: TextStyle(color: MyThemes.darkblack, fontSize: 18),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        Expanded(
                                                                                          child: Padding(
                                                                                            padding: const EdgeInsets.all(8.0),
                                                                                            child: Column(
                                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Row(
                                                                                                  children: [
                                                                                                    MarqueeWidget(
                                                                                                      child: Text(
                                                                                                        snapshot.data![index].title,
                                                                                                        style: TextStyle(color: MyThemes.darkblack, fontSize: 17, fontWeight: FontWeight.bold),
                                                                                                      ),
                                                                                                      direction: Axis.horizontal,
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                                Text("Timing :", style: TextStyle(color: MyThemes.darkblack, fontSize: 16)),
                                                                                                Padding(
                                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                                  child: Row(
                                                                                                    children: [
                                                                                                      Column(
                                                                                                        children: [
                                                                                                          MarqueeWidget(child: Text(DateFormat("hh:mm").format(event.bookingStart!), style: TextStyle(color: MyThemes.darkblack, fontSize: 16)), direction: Axis.horizontal),
                                                                                                          Text("To", style: TextStyle(color: MyThemes.darkblack, fontSize: 16)),
                                                                                                          MarqueeWidget(child: Text(DateFormat("hh:mm").format(event.bookingEnd!), style: TextStyle(color: MyThemes.darkblack, fontSize: 16)), direction: Axis.horizontal),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    (index == snapshot.data!.length - 1)
                                                                                        ? Container()
                                                                                        : Divider(
                                                                                            thickness: 1,
                                                                                            color: MyThemes.darkblack,
                                                                                          ),
                                                                                  ],
                                                                                ),
                                                                              );
                                                                            },
                                                                            itemCount:
                                                                                snapshot.data!.length,
                                                                          ),
                                                                        );
                                                                      } else {
                                                                        return Container();
                                                                      }
                                                                    } else {
                                                                      return Column(
                                                                        children: [
                                                                          Center(
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              color: MyThemes.purple,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    }
                                                                  },
                                                                  future: fetchServiceDetails(
                                                                      event
                                                                          .servicesId),
                                                                ),
                                                                Divider(
                                                                  thickness: 1,
                                                                  color: MyThemes
                                                                      .darkblack,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          MarqueeWidget(
                                                                        direction:
                                                                            Axis.horizontal,
                                                                        child:
                                                                            Text(
                                                                          "Total Bill Of :  ${event.servicePrice} ₹",
                                                                          style: TextStyle(
                                                                              color: MyThemes.darkblack,
                                                                              fontSize: 20),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                ("${event.status}" ==
                                                                        "PENDING")
                                                                    ? ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          print(
                                                                              "event.bookingID :: ${event.bookingID}");
                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection(
                                                                                  'salons')
                                                                              .doc(detailPagecontroller
                                                                                  .modelforintent!.aid)
                                                                              .collection(
                                                                                  'bookings')
                                                                              .doc(event
                                                                                  .bookingID)
                                                                              .set({
                                                                            'status':
                                                                                'CANCELED'
                                                                          }, SetOptions(merge: true)).then((value) {
                                                                            var snackBar =
                                                                                SnackBar(content: Text('You have sucessfully cancelled appointment!!'));
                                                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                            callinitstate();
                                                                            Navigator.pop(context);
                                                                          });
                                                                        },
                                                                        style: ElevatedButton.styleFrom(
                                                                            backgroundColor: MyThemes
                                                                                .purple),
                                                                        child:
                                                                            Text(
                                                                          "CANCEL THIS APPOINTMENT",
                                                                          style: TextStyle(
                                                                              color: MyThemes.txtwhite,
                                                                              fontSize: 10),
                                                                        ))
                                                                    : Container(),
                                                                ("${event.status}" ==
                                                                        "CANCELED")
                                                                    ? ElevatedButton(
                                                                        onPressed:
                                                                            () {},
                                                                        style: ElevatedButton.styleFrom(
                                                                            backgroundColor: MyThemes
                                                                                .purple),
                                                                        child:
                                                                            Text(
                                                                          "YOU CANCELLED THE APPOINTMENT",
                                                                          style: TextStyle(
                                                                              color: MyThemes.txtwhite,
                                                                              fontSize: 10),
                                                                        ))
                                                                    : Container(),
                                                                ("${event.status}" ==
                                                                    "DONE")
                                                                    ? ElevatedButton(
                                                                    onPressed:
                                                                        () {},
                                                                    style: ElevatedButton.styleFrom(
                                                                        backgroundColor: MyThemes
                                                                            .purple),
                                                                    child:
                                                                    Text(
                                                                      "APPOINTMENT IS COMPLETED BY YOU",
                                                                      style: TextStyle(
                                                                          color: MyThemes.txtwhite,
                                                                          fontSize: 10),
                                                                    ))
                                                                    : Container(),
                                                                ("${event.status}" ==
                                                                        "PENDING")
                                                                    ? ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection(
                                                                                  'salons')
                                                                              .doc(detailPagecontroller
                                                                                  .modelforintent!.aid)
                                                                              .collection(
                                                                                  'bookings')
                                                                              .doc(event
                                                                                  .bookingID)
                                                                              .set({
                                                                            'status':
                                                                                'DONE'
                                                                          }, SetOptions(merge: true)).then((value) {
                                                                            var snackBar =
                                                                                SnackBar(content: Text('You have sucessfully completed appointment!!'));
                                                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                            callinitstate();
                                                                            Navigator.pop(context);
                                                                          });
                                                                        },
                                                                        style: ElevatedButton.styleFrom(
                                                                            backgroundColor: MyThemes
                                                                                .purple),
                                                                        child:
                                                                            Text(
                                                                          "DONE",
                                                                          style: TextStyle(
                                                                              color: MyThemes.txtwhite,
                                                                              fontSize: 10),
                                                                        ))
                                                                    : Container(),

                                                                (event.bookingStart!.isBefore(DateTime
                                                                            .now()) ==
                                                                        true)
                                                                    ? ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection('salons')
                                                                              .doc(detailPagecontroller.modelforintent!.aid)
                                                                              .collection('bookings')
                                                                              .doc(event.bookingID)
                                                                              .delete()
                                                                              .then((value) {
                                                                            var snackBar =
                                                                                SnackBar(content: Text('You have deleted appointment Sucessfully!!'));
                                                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                            callinitstate();
                                                                            Navigator.pop(context);
                                                                          });
                                                                        },
                                                                        style: ElevatedButton.styleFrom(
                                                                            backgroundColor: MyThemes
                                                                                .purple),
                                                                        child:
                                                                            Text(
                                                                          "DELETE THIS BOOKING ?",
                                                                          style: TextStyle(
                                                                              color: MyThemes.txtwhite,
                                                                              fontSize: 10),
                                                                        ))
                                                                    : Container(),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    /*   Container(
                                                                      height:
                                                                          50,
                                                                      color: MyThemes
                                                                          .purple,
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child: "${event.status}" ==
                                                                                "PENDING"
                                                                            ? Text(
                                                                                "CANCEL THE APPOINTMENT",
                                                                                style: TextStyle(color: MyThemes.darkblack, fontSize: 10),
                                                                              )
                                                                            : Container(),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      height:
                                                                          50,
                                                                      color: MyThemes
                                                                          .purple,
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child: "${event.status}" ==
                                                                                "PENDING"
                                                                            ? Text(
                                                                                "IS SERVICE DONE ?",
                                                                                style: TextStyle(color: MyThemes.darkblack, fontSize: 10),
                                                                              )
                                                                            : "${event.status}" == "CANCELED"
                                                                                ? Text(
                                                                                    "YOU CANCELLED THIS BOOKING",
                                                                                    style: TextStyle(color: MyThemes.darkblack, fontSize: 10),
                                                                                  )
                                                                                : Container(),
                                                                      ),
                                                                    ),*/
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ).toList(),
                                                  ),
                                                ),
                                              ),
                                            ));
                                  },
                                  onPageChanged: (firstDate, lastDate) {
                                    /// Called when the page was changed
                                    /// Fetch additional events by using the range between [firstDate] and [lastDate] if you want
                                  },
                                ),
                              ),
                            )
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
