import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../models/AdminModel.dart';
import '../models/ServiceModel.dart';
import 'FirebaseService.dart';

class ItemService {
  FirebaseService firebaseService = FirebaseService();


  Future loadservicesFromfirebase(String Salonid) async {
    return await firebaseService.loadservicesFromfirebase(Salonid);
  }

  Future<AdminModel> getuserdata() async {
    AdminModel model =await firebaseService.getuserdata();
    print("AdminModel Admin : ${model.toJson().toString()}");
    return model;
  }

  Future<String?> uploadImage(File file,String name) async {
    return await firebaseService.uploadImage(file,name);
  }

  Future<String?> uploadServiceImage(File file,String name) async {
    return await firebaseService.uploadServiceImage(file,name);
  }



}
