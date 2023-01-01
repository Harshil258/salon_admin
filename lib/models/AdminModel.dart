// To parse this JSON data, do
//
//     final usermodel = usermodelFromJson(jsonString);

import 'dart:convert';

AdminModel usermodelFromJson(String str) => AdminModel.fromJson(json.decode(str));

String usermodelToJson(AdminModel data) => json.encode(data.toJson());

class AdminModel {
  AdminModel({
    required this.aid,
    required this.email,
    required this.address,
    required this.category,
    required this.image,
    required this.location,
    required this.rating,
    required this.salonid,
    required this.salonname
  });

  String aid;
  String email;
  String address;
  String category;
  String image;
  String location;
  String rating;
  String salonid;
  String salonname;

  factory AdminModel.fromJson(Map<String, dynamic> json) => AdminModel(
    aid: json["aid"],
    email: json["email"],
    address: json["address"],
    category: json["category"],
    image: json["image"],
    location: json["location"],
    rating: json["rating"],
    salonid: json["salonid"],
    salonname: json["salonname"]
  );

  Map<String, dynamic> toJson() => {
    "aid": aid,
    "email": email,
    "address": address,
    "category": category,
    "image": image,
    "location": location,
    "rating": rating,
    "salonid": salonid,
    "salonname": salonname
  };
}
