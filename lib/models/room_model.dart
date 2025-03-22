class RoomModel {
  RoomModel({
    required this.id,
    required this.idRoomType,
    required this.name,
    required this.tags,
  });

  final int id;
  static const String idKey = "id";

  final int idRoomType;
  static const String idRoomTypeKey = "id_room_type";

  final String name;
  static const String nameKey = "name";

  final List<String> tags;
  static const String tagsKey = "tags";

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json["id"] ?? 0,
      idRoomType: json["id_room_type"] ?? 0,
      name: json["name"] ?? "",
      tags: json["tags"] == null
          ? []
          : List<String>.from(json["tags"]!.map((x) => x)),
    );
  }
}
