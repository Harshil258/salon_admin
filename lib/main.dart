import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salon_admin/services/initclass.dart';
import 'package:salon_admin/util/routes.dart';
import 'Screens/Home_Screen.dart';
import 'Screens/Home_Screen.dart';
import 'Screens/Login_Screen.dart';
import 'MyThemes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Screens/Register_Screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    Widget first;
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      first = Home_Screen();
    } else {
      first = Register_Screen();
    }

    return GetMaterialApp(
      title: 'Saloon',
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: MyThemes.darkblack,
        primarySwatch: MyThemes.darkblack,
        textTheme: Theme.of(context).textTheme.apply(
              displayColor: MyThemes.txtwhite,
              bodyColor: MyThemes.txtwhite,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
      ),
      // home: first(),
      routes: {
        "/": (context) => first,
        Routes.homedetail: (context) => const Home_Screen(),
        // Routes.register: (context) => Register(),
        // // Routes.Uploadphoto: (context) => Upload_Photo(),
      },
    );
  }
}
