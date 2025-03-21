class UserDetailsModel {
  String? id;
  String? firebaseUid;
  String? name;
  String? email;
  String? phone;
  bool? emailVerified;
  String? profilePricture;
  String? createdAt;
  String? updatedAt;

  UserDetailsModel(
      {this.id,
      this.firebaseUid,
      this.name,
      this.email,
      this.phone,
      this.emailVerified,
      this.profilePricture,
      this.createdAt,
      this.updatedAt});

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) =>
      UserDetailsModel(
        id: json["id"],
        firebaseUid: json["firebase_uid"],
        name: json["name"],
        email: json["email"],
        phone: json["phone_number"],
        emailVerified: json["email_verified"],
        profilePricture: json["profile_picture"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );
}
