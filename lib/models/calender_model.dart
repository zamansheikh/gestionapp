class CalenderModel {
  final String? id;
  final String? owner;
  final String? zakRoomId;
  final String? roomName;
  final int? v;

  CalenderModel({
    this.id,
    this.owner,
    this.zakRoomId,
    this.roomName,
    this.v,
  });

  factory CalenderModel.fromJson(Map<String, dynamic> json) => CalenderModel(
    id: json["_id"],
    owner: json["owner"],
    zakRoomId: json["zakRoomId"],
    roomName: json["roomName"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "owner": owner,
    "zakRoomId": zakRoomId,
    "roomName": roomName,
    "__v": v,
  };
}
