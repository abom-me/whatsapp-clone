// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? name;
  String? uid;
  String? profileImage;
  String? phone;
  bool? isOnline;
  List<String>? groupId;

  UserModel({
    this.name,
    this.uid,
    this.profileImage,
    this.phone,
    this.isOnline,
    this.groupId,
  });

  UserModel copyWith({
    String? name,
    String? uid,
    String? profileImage,
    String? phone,
    bool? isOnline,
    List<String>? groupId,
  }) =>
      UserModel(
        name: name ?? this.name,
        uid: uid ?? this.uid,
        profileImage: profileImage ?? this.profileImage,
        phone: phone ?? this.phone,
        isOnline: isOnline ?? this.isOnline,
        groupId: groupId ?? this.groupId,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    name: json["name"],
    uid: json["uid"],
    profileImage: json["profileImage"],
    phone: json["phone"],
    isOnline: json["isOnline"],
    groupId: json["groupId"] == null ? [] : List<String>.from(json["groupId"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "uid": uid,
    "profileImage": profileImage,
    "phone": phone,
    "isOnline": isOnline,
    "groupId": groupId == null ? [] : List<dynamic>.from(groupId!.map((x) => x)),
  };
}
