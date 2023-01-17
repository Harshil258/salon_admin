import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:salon_admin/services/itemService.dart';

import '../models/AdminModel.dart';
import '../models/servicemodel.dart';
import 'FirebaseService.dart';

class MainController extends GetxController {
  ItemService itemService = ItemService();

  bool isusermodelinitilize = false;

  AdminModel? modelforintent = null;

  FirebaseService firebaseService = FirebaseService();

  List<ServiceModel> servicemodellist = [];

  Future<String?> storeAdmin(String aid, String email) async {
    return await firebaseService.storeAdmin(aid, email);
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
    return await firebaseService.storeSaloon(
        aid, email, address, category, image, location, salon_id, salon_name);
  }

  Future<bool> getuserdata() async {
    modelforintent = (await itemService.getuserdata());
    print("model class modelforintent : ${modelforintent!.salonname}");

    // update();
    if (modelforintent!.aid != "") {
      isusermodelinitilize = true;
      return true;
    } else {
      return false;
    }
  }

  callfirebase() async {
    print("calling firebase");
    final CollectionReference collection =
        FirebaseFirestore.instance.collection('salons');
    QuerySnapshot querySnapshot = await collection.get();
    print(
        "Salon list querySnapshot ${querySnapshot.docChanges.toSet().toString()}");

    if (modelforintent!.aid != "") {
      servicemodellist =
          await itemService.loadservicesFromfirebase(modelforintent!.aid);
    }
  }
}
