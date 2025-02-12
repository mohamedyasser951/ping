class UserModel {
  final String name;
  final String? email;
  final String? phone;
  final String? uId;
  final String? image;

  UserModel(
      {required this.name,
      required this.email,
      required this.phone,
      required this.uId,
      required this.image});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      uId: json['uId'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'uId': uId,
      'image': image,
    };
  }

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, phone: $phone, uId: $uId, image: $image)';
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
          image == other.image;

  @override
  int get hashCode =>
      name.hashCode ^
      email.hashCode ^
      phone.hashCode ^
      uId.hashCode ^
      image.hashCode;
}
