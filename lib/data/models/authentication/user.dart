import 'package:hive_flutter/hive_flutter.dart';

part 'user.g.dart';

@HiveType(typeId: 2)
class AppUser {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? fullName;

  @HiveField(2)
  String? email;

  @HiveField(3)
  String? password;

  @HiveField(4)
  String? photoUrl;

  AppUser({
    this.id,
    this.fullName,
    this.email,
    this.password,
    this.photoUrl,
  });

  AppUser.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    fullName = json['fullName'];
    email = json['email'];
    photoUrl = json['photoUrl'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = id;
    map['fullName'] = fullName;
    map['email'] = email;
    map['password'] = password;
    map['photoUrl'] = photoUrl;
    return map;
  }
}
