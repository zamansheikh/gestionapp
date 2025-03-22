class GetUserProfileModel {
  final String? id;
  final String? name;
  final String? role;
  final String? email;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final List<String>? roomIds;
  final String? image;
  final String? phone;

  GetUserProfileModel({
    this.id,
    this.name,
    this.role,
    this.email,
    this.roomIds,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.image,
    this.phone,
  });

  factory GetUserProfileModel.fromJson(Map<String, dynamic> json) =>
      GetUserProfileModel(
        id: json["_id"],
        name: json["name"],
        role: json["role"],
        email: json["email"],
        isDeleted: json["isDeleted"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        image: json["image"],
        phone: json["phone"],
        //! TODO: Here is some update!
        roomIds: json["property"] == null
            ? []
            : List<String>.from(json["property"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "role": role,
        "email": email,
        "isDeleted": isDeleted,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "image": image,
        "phone": phone,
      };
}
