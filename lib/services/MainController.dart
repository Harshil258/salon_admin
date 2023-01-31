import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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
      String salon_name,
      String profileimage,
      String owner_name,
      String owner_surname,
      String owner_mobilenumber,
      ) async {
    return await firebaseService.storeSaloon(aid, email, address, category,
        image, location, salon_id, salon_name, profileimage,owner_name,owner_surname,owner_mobilenumber);
  }

  Future<bool> getuserdata() async {
    modelforintent = (await itemService.getuserdata());
    print("model class modelforintent!.aid : ${await modelforintent!.aid}");
    update();
    if (modelforintent!.aid.toString() != "") {
      isusermodelinitilize = true;
      print("model class isusermodelinitilize : ${isusermodelinitilize}  true");
      return true;
    } else {
      isusermodelinitilize = false;
      print("model class isusermodelinitilize : ${isusermodelinitilize} false");
      return false;
    }
  }

  callfirebase() async {
    print("calling firebase");
    // final CollectionReference collection =
    //     FirebaseFirestore.instance.collection('salons');
    // QuerySnapshot querySnapshot = await collection.get();
    // print(
    //     "Salon list querySnapshot ${querySnapshot.docChanges.toSet().toString()}");

    if (modelforintent!.aid != "") {
      // servicemodellist =
      //     await itemService.loadservicesFromfirebase(modelforintent!.aid);
      print(
              "servicemodellist  servicemodellist ${servicemodellist.toSet().toString()}");
    }
  }

  Future<String?> uploadImage(PickedFile file,String name) async{
    return await itemService.uploadImage(file,name);
  }
}
