// To parse this JSON data, do
//
//     final usermodel = usermodelFromJson(jsonString);

import 'dart:convert';

AdminModel usermodelFromJson(String str) =>
    AdminModel.fromJson(json.decode(str));

String usermodelToJson(AdminModel data) => json.encode(data.toJson());

class AdminModel {
  AdminModel({
    this.aid,
    this.email,
    this.address,
    this.category,
    this.image,
    this.location,
    this.salonid,
    this.salonname,
    this.saloonimage,
    this.owner_name,
    this.owner_surname,
    this.owner_mobilenumber,
  });

  String? aid;
  String? email;
  String? address;
  String? category;
  String? image;
  String? location;
  String? salonid;
  String? salonname;
  String? saloonimage;
  String? owner_name;
  String? owner_surname;
  String? owner_mobilenumber;

  factory AdminModel.fromJson(Map<String, dynamic> json) => AdminModel(
        aid: json["aid"],
        email: json["email"],
        address: json["address"],
        category: json["category"],
        image: json["image"],
        location: json["location"],
        salonid: json["salonid"],
        salonname: json["salonname"],
        saloonimage: json["saloonimage"],
        owner_name: json["owner_name"],
        owner_surname: json["owner_surname"],
        owner_mobilenumber: json["owner_mobilenumber"],
      );

  Map<String, dynamic> toJson() => {
        "aid": aid,
        "email": email,
        "address": address,
        "category": category,
        "image": image,
        "location": location,
        "salonid": salonid,
        "salonname": salonname,
        "saloonimage": saloonimage,
        "owner_name": owner_name,
        "owner_surname": owner_surname,
        "owner_mobilenumber": owner_mobilenumber
      };
}
