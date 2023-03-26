import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyThemes{

  static Color first =const Color(0xff010101);
  static Color five =const Color(0xff0e0e0e);
  static Color second = Color(0xff8372ff);
  static Color third = Color(0xffdcdcdc);
  static Color four = Color(0xffa8a8a8);

  static Map<int, Color> color =
  {
    50:Color.fromRGBO(136,14,79, .1),
    100:Color.fromRGBO(136,14,79, .2),
    200:Color.fromRGBO(136,14,79, .3),
    300:Color.fromRGBO(136,14,79, .4),
    400:Color.fromRGBO(136,14,79, .5),
    500:Color.fromRGBO(136,14,79, .6),
    600:Color.fromRGBO(136,14,79, .7),
    700:Color.fromRGBO(136,14,79, .8),
    800:Color.fromRGBO(136,14,79, .9),
    900:Color.fromRGBO(136,14,79, 1),
  };

  static MaterialColor darkblack = MaterialColor(0xff010101, color);
  static MaterialColor txtwhite = MaterialColor(0xffdcdcdc, color);
  static MaterialColor txtdarkwhite = MaterialColor(0xffa8a8a8, color);
  static MaterialColor purple = MaterialColor(0xff8372ff, color);
  static MaterialColor lightblack = MaterialColor(0xff0e0e0e, color);

}

TextStyle TextStyleBlack(double size) {
  return GoogleFonts.arimaMadurai(
    textStyle: TextStyle(
      fontSize: size,
      color: Colors.black,
    ),
  );
}

