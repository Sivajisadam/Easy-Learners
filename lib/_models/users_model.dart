class Users {
  String? userId;
  String? name;
  String? email;
  String? profilePicture;

  Users({this.userId, this.name, this.email, this.profilePicture});
  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      userId: json['firebase_uid'],
      name: json['name'],
      email: json['email'],
      profilePicture: json['profile_picture'] ?? "",
    );
  }
}
