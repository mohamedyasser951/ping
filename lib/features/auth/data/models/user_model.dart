import 'dart:convert';

class UserModel {
  final String? uId;

  final String name;
  final String? email;
  final String? phone;
  // final String? image;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.uId,
    // required this.image
  });

  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      uId: json['uId'],
      // image: json['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'uId': uId,
      // 'image': image,
    };
  }
    String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email,   phone: $phone, uId: $uId)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          email == other.email &&
          phone == other.phone &&
          uId == other.uId;
  //  &&
  //         image == other.image;

  @override
  int get hashCode =>
      name.hashCode ^ email.hashCode ^ phone.hashCode ^ uId.hashCode;
  // image.hashCode;
}
