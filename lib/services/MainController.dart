import 'package:get/get.dart';

import 'FirebaseService.dart';

class MainController extends GetxController{

  bool isusermodelinitilize = false;
  // Usermodel? modelforintent = null;

  FirebaseService firebaseService = FirebaseService();

  Future<String?> storeAdmin(String aid, String email) async {
    return await firebaseService.storeAdmin(aid,email);
  }

  Future<String?> storeSaloon( String aid,
      String email,
      String address,
      String category,
      String image,
      String location,
      String salon_id,
      String salon_name) async {
    return await firebaseService.storeSaloon(aid,email,address,category,image,location,salon_id,salon_name);
  }

}