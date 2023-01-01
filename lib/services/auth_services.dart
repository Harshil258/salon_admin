class AdminModel {
  String? aid;
  String? email;

 AdminModel({this.aid, this.email});

  factory AdminModel.fromMap(map) {
    return AdminModel(
      aid: map['uid'],
      email: map['email']
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'aid': aid,
      'email': email
    };
  }
}

