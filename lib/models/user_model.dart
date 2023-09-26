class UserModel {
  String? uId;
  String? name;
  String? email;
  String? profileImage;
  int? dateTime;

  UserModel(
      {required this.uId,
      required this.name,
      required this.email,
      required this.profileImage,
      required this.dateTime});

  factory UserModel.fromJson(Map<Object?, dynamic> map) {
    return UserModel(
        uId: map['uId'],
        name: map['name'],
        email: map['email'],
        profileImage: map['profileImage'],
        dateTime: map['dateTime']);
  }
}
