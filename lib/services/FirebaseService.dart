import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

import '../models/servicemodel.dart';
import '../models/AdminModel.dart';
import 'auth.dart';

class FirebaseService {
  Future<AdminModel> getuserdata() async {
    User? user = await Authentication.getUserId();
    final CollectionReference collection =
        FirebaseFirestore.instance.collection('Admin');
    DocumentSnapshot<Object?> model = await collection.doc(user!.uid).get();
    print("Current Admin : ${user!.uid}");
    print("Current Admin : ${model.data().toString()}");
    if (model.data().isNull) {
      return AdminModel(
          aid: "",
          email: "",
          address: "",
          category: "",
          image: "",
          location: "",
          rating: "",
          salonid: "",
          salonname: "");
    } else {
      return AdminModel(
          aid: model.get("uid"),
          email: model.get("email"),
          address: model.get("address"),
          category: model.get("category"),
          image: model.get("image"),
          location: model.get("location"),
          rating: model.get("rating"),
          salonid: model.get("salonid"),
          salonname: model.get("salonname"));
    }
  }

  Future<List<ServiceModel>> loadservicesFromfirebase(String salonid) async {
    final CollectionReference collection =
    FirebaseFirestore.instance.collection('service');
    QuerySnapshot snapshot =
    await collection.where('salon_id', isEqualTo: salonid).get();

    return await List.from(
        snapshot.docs.map((element) => fromQuerySnapshotService(element)));
  }

  Future<String?> storeAdmin(String aid, String email) async {
    try {
      final CollectionReference collection =
          FirebaseFirestore.instance.collection('Admin');
      collection.doc(aid).set({
        "aid": aid,
        "email": email,
      });
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
      String salon_name) async {
    try {
      final CollectionReference collection =
          FirebaseFirestore.instance.collection('salons');
      collection.doc(aid).set({
        "aid": aid,
        "email": email,
        "address": address,
        "category": category,
        "image": image,
        "location": location,
        "salon_id": salon_id,
        "salon_name": salon_name
      });
      return 'Salon Stroed';
    } on Exception catch (e) {
      return 'Error adding user  ${e.toString()}';
    }
  }

  Future<String?> storeData(String userid, String name, String surname,
      String email, String phoneno, String address, String photo) async {
    try {
      final CollectionReference collection =
          FirebaseFirestore.instance.collection('Users');
      collection.doc(userid).set({
        "uid": userid,
        "Name": name,
        "Surname": surname,
        "email": email,
        "mobilenumber": phoneno,
        "address": address,
        "photo": photo
      });
      return 'success';
    } on Exception catch (e) {
      return 'Error adding user  ${e.toString()}';
    }
  }

  Future<String?> uploadImage(PickedFile file, String name) async {
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
}
