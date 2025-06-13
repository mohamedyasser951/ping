import 'dart:convert';

class UserModel {
  final String uId;
  final String name;
  final String email;
  final String phone;
  final bool isOnline;
  final DateTime? lastSeen;
    final bool? isNewUser;

  // final String? image;

  UserModel(
      {required this.name,
      required this.email,
      required this.phone,
      required this.uId,
      this.isOnline = false,
      this.lastSeen,
      this.isNewUser,
      // required this.image
      });

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? uId,
    bool? isOnline,
    DateTime? lastSeen,
    // String? image,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      uId: uId ?? this.uId,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      // image: image ?? this.image,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      uId: json['uId'],
      isOnline: json['isOnline'] ?? false,
      lastSeen:
          json['lastSeen'] != null ? DateTime.parse(json['lastSeen']) : null,
      // image: json['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'uId': uId,
      'isOnline': isOnline,
      'lastSeen': lastSeen?.toIso8601String(),
      // 'image': image,
    };
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email,   phone: $phone, uId: $uId, isOnline: $isOnline, lastSeen: $lastSeen)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          email == other.email &&
          phone == other.phone &&
          uId == other.uId &&
          isOnline == other.isOnline &&
          lastSeen == other.lastSeen;
  //  &&
  //         image == other.image;

  @override
  int get hashCode =>
      name.hashCode ^ email.hashCode ^ phone.hashCode ^ uId.hashCode;
  // image.hashCode;
}
