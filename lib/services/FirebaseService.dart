import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

import '../models/ServiceModel.dart';
import '../models/AdminModel.dart';
import 'auth.dart';

class FirebaseService {
  Future<AdminModel> getuserdata() async {
    User? user = await Authentication.getUserId();

    final CollectionReference collection =
        FirebaseFirestore.instance.collection('salons');
    DocumentSnapshot<Object?> model = await collection.doc(user!.uid).get();

    print("Current Admin : ${user!.uid}");
    print("Current Admin : ${model.data().toString()}");
    if (model.data().isNull) {
      return AdminModel(
        aid: user!.uid,
        email: "",
        address: "",
        category: "",
        image: "",
        location: "",
        salonid: "",
        salonname: "",
        saloonimage: "",
        owner_name: "",
        owner_surname: "",
        owner_mobilenumber: "",
      );
    } else {
      return AdminModel(
        aid: user!.uid,
        email: user.email,
        address: model.get("address"),
        category: model.get("category"),
        image: model.get("image"),
        location: model.get("location"),
        salonid: model.get("salon_id"),
        salonname: model.get("salon_name"),
        saloonimage: model.get("saloonimage"),
        owner_name: model.get("owner_name"),
        owner_surname: model.get("owner_surname"),
        owner_mobilenumber: model.get("owner_mobilenumber"),
      );
    }
  }

  Future<List<ServiceModel>> loadservicesFromfirebase(String salonid) async {
    final CollectionReference collection =
        FirebaseFirestore.instance.collection('service');
    QuerySnapshot snapshot =
        await collection.where('salon_id', isEqualTo: salonid).get();

    return List.from(
        snapshot.docs.map((element) => fromQuerySnapshotService(element)));
  }

  Future<String?> storeAdmin(String aid, String email) async {
    try {
      final CollectionReference collection =
          FirebaseFirestore.instance.collection('Admin');
      collection.doc(aid).set({"aid": aid, "email": email, "salon_id": aid});
      return 'Admin Stored';
    } on Exception catch (e) {
      return 'Error adding user  ${e.toString()}';
    }
  }

  Future<String?> storeSaloon(
      String aid,
      String email,
      String address,
      String category,
      String image,
      String location,
      String salon_id,
      String salon_name,
      String saloonimage,
      String owner_name,
      String owner_surname,
      String owner_mobilenumber) async {
    try {
      final CollectionReference collection =
          FirebaseFirestore.instance.collection('salons');
      User? user = await Authentication.getUserId();

      print("aid id ${aid}");
      collection.doc(aid).set({
        "aid": aid,
        "email": user!.email,
        "address": address,
        "category": category,
        "image": image,
        "location": location,
        "salon_id": salon_id,
        "salon_name": salon_name,
        "saloonimage": saloonimage,
        "owner_name": owner_name,
        "owner_surname": owner_surname,
        "owner_mobilenumber": owner_mobilenumber,
      });
      return 'Salon Stroed';
    } on Exception catch (e) {
      return 'Error adding user  ${e.toString()}';
    }
  }

  storeService(String title, int price, String description, String image,
      String salonId, String serviceId, String service_gender) {
    try {
      final CollectionReference collection =
          FirebaseFirestore.instance.collection('service');

      print("serviceId id ${serviceId}");
      collection.doc(serviceId).set({
        "Title": title,
        "Price": price,
        "description": description,
        "image": image,
        "salon_id": salonId,
        "service_id": serviceId,
        "gender": service_gender
      });
      return 'Service Stroed';
    } on Exception catch (e) {
      return 'Error adding Service  ${e.toString()}';
    }
  }

  Future<String?> uploadImage(File file, String name) async {
    final _firebaseStorage = FirebaseStorage.instance;
    try {
      print("sadgsdgdg   ${file.path}");
      if (file != null) {
        var snapshot = await _firebaseStorage
            .ref()
            .child('Users/Profiles/${name}')
            .putFile(File(file.path));
        var downloadUrl = await snapshot.ref.getDownloadURL();
        print("sadgsdgdg   ${downloadUrl}");
        return downloadUrl;
      } else {
        print('No Image Path Received');
      }
    } on Exception catch (e) {
      return 'Error adding image  ${e.toString()}';
    }
  }

  Future<String?> uploadServiceImage(File file, String name) async {
    final _firebaseStorage = FirebaseStorage.instance;
    try {
      print("sadgsdgdg   ${file.path}");
      if (file != null) {
        var snapshot = await _firebaseStorage
            .ref()
            .child('Users/SaloonServices/${name}')
            .putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        print("sadgsdgdg   ${downloadUrl}");
        return downloadUrl;
      } else {
        print('No Image Path Received');
      }
    } on Exception catch (e) {
      return 'Error adding image  ${e.toString()}';
    }
  }
}
