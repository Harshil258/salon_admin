import 'package:image_picker/image_picker.dart';

import '../models/AdminModel.dart';
import '../models/servicemodel.dart';
import 'FirebaseService.dart';

class ItemService {
  FirebaseService firebaseService = FirebaseService();


  Future loadservicesFromfirebase(String Salonid) async {
    return await firebaseService.loadservicesFromfirebase(Salonid);
  }

  Future<AdminModel> getuserdata() async {
    return await firebaseService.getuserdata();
  }


  Future<String?> loadUser(String userid, String name, String surname,
      String email, String phoneno, String address, String photo) async {
    return await firebaseService.storeData(
        userid, name, surname, email, phoneno, address, photo);
  }

  Future<String?> uploadImage(PickedFile file,String name) async {
    return await firebaseService.uploadImage(file,name);
  }
}
