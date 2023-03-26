import 'package:get/get.dart';

import 'FirebaseService.dart';
import 'MainController.dart';

Future<void> init() async{
  Get.lazyPut(() => FirebaseService());
  Get.lazyPut(() => MainController());
}