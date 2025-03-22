class AllRoomList {
  AllRoomList({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final List<Datum> data;

  factory AllRoomList.fromJson(Map<String, dynamic> json) {
    return AllRoomList(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null
          ? []
          : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }
}

class Datum {
  Datum({
    required this.id,
    required this.owner,
    required this.zakRoomId,
    required this.roomName,
    required this.v,
  });

  final String id;
  final String owner;
  final String zakRoomId;
  final String roomName;
  final num v;

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json["_id"] ?? "",
      owner: json["owner"] ?? "",
      zakRoomId: json["zakRoomId"] ?? "",
      roomName: json["roomName"] ?? "",
      v: json["__v"] ?? 0,
    );
  }
}
