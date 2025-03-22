class NewReservationModel {
  NewReservationModel({
    required this.roomName,
    required this.reservations,
  });

  final String roomName;
  final List<NewReservation> reservations;

  factory NewReservationModel.fromJson(Map<String, dynamic> json) {
    return NewReservationModel(
      roomName: json["roomName"] ?? "",
      reservations: json["reservations"] == null
          ? []
          : List<NewReservation>.from(json["reservations"]!.map((x) {
              return NewReservation.fromJson(x, json["room_id"].toString());
            })),
    );
  }

  @override
  String toString() {
    return "$roomName, $reservations, ";
  }
}

class NewReservation {
  NewReservation({
    required this.roomId,
    required this.id,
    required this.idHuman,
    required this.booker,
    required this.status,
    required this.expirationDate,
    required this.origin,
    required this.lastStatusDate,
    required this.board,
    required this.created,
    required this.cpolicy,
    required this.agency,
    required this.corporate,
    required this.price,
    required this.payment,
    required this.taxes,
    required this.rooms,
    required this.customerName,
    required this.customerPhone,
    required this.customerSurName,
    required this.notes,
  });
  final String roomId;
  final int id;
  final String idHuman;
  final num booker;
  final String status;
  final String expirationDate;
  final NewOrigin? origin;
  final String lastStatusDate;
  final String board;
  final String created;
  final String cpolicy;
  final String agency;
  final dynamic corporate;
  final NewPrice? price;
  final NewPayment? payment;
  final NewTaxes? taxes;
  final List<NewRoom> rooms;
  final String customerName;
  final String customerPhone;
  final String customerSurName;
  final List<NewNote> notes;

  factory NewReservation.fromJson(
    Map<String, dynamic> json,
    String roomId,
  ) {
    return NewReservation(
      roomId: roomId,
      id: json["id"] ?? 0,
      idHuman: json["id_human"] ?? "",
      booker: json["booker"] ?? 0,
      status: json["status"] ?? "",
      expirationDate: json["expiration_date"] ?? "",
      origin:
          json["origin"] == null ? null : NewOrigin.fromJson(json["origin"]),
      lastStatusDate: json["last_status_date"] ?? "",
      board: json["board"] ?? "",
      created: json["created"] ?? "",
      cpolicy: json["cpolicy"] ?? "",
      agency: json["agency"] ?? "",
      corporate: json["corporate"],
      price: json["price"] == null ? null : NewPrice.fromJson(json["price"]),
      payment:
          json["payment"] == null ? null : NewPayment.fromJson(json["payment"]),
      taxes: json["taxes"] == null ? null : NewTaxes.fromJson(json["taxes"]),
      rooms: json["rooms"] == null
          ? []
          : List<NewRoom>.from(
              json["rooms"]!
                  .where((x) => x["id_zak_room"].toString() == roomId)
                  .map((x) => NewRoom.fromJson(x)),
            ),
      customerName: json["customerName"] ?? "",
      customerPhone: json["customerPhone"] ?? "",
      customerSurName: json["customerSurName"] ?? "",
      notes: json["notes"] == null
          ? []
          : List<NewNote>.from(json["notes"]!.map((x) => NewNote.fromJson(x))),
    );
  }

  @override
  String toString() {
    return "$id, $idHuman, $booker, $status, $expirationDate, $origin, $lastStatusDate, $board, $created, $cpolicy, $agency, $corporate, $price, $payment, $taxes, $rooms, $customerName, $notes, ";
  }
}

class NewNote {
  NewNote({
    required this.id,
    required this.remarks,
  });

  final int id;
  final String remarks;

  factory NewNote.fromJson(Map<String, dynamic> json) {
    return NewNote(
      id: json["id"] ?? 0,
      remarks: json["remarks"] ?? "",
    );
  }

  @override
  String toString() {
    return "$id, $remarks, ";
  }
}

class NewOrigin {
  NewOrigin({
    required this.channel,
  });

  final String channel;

  factory NewOrigin.fromJson(Map<String, dynamic> json) {
    return NewOrigin(
      channel: json["channel"] ?? "",
    );
  }

  @override
  String toString() {
    return "$channel, ";
  }
}

class NewPayment {
  NewPayment({
    required this.amount,
    required this.currency,
  });

  final num amount;
  final String currency;

  factory NewPayment.fromJson(Map<String, dynamic> json) {
    return NewPayment(
      amount: json["amount"] ?? 0,
      currency: json["currency"] ?? "",
    );
  }

  @override
  String toString() {
    return "$amount, $currency, ";
  }
}

class NewPrice {
  NewPrice({
    required this.rooms,
    required this.extras,
    required this.meals,
    required this.total,
  });

  final NewExtras? rooms;
  final NewExtras? extras;
  final NewExtras? meals;
  final num total;

  factory NewPrice.fromJson(Map<String, dynamic> json) {
    return NewPrice(
      rooms: json["rooms"] == null ? null : NewExtras.fromJson(json["rooms"]),
      extras:
          json["extras"] == null ? null : NewExtras.fromJson(json["extras"]),
      meals: json["meals"] == null ? null : NewExtras.fromJson(json["meals"]),
      total: json["total"] ?? 0,
    );
  }

  @override
  String toString() {
    return "$rooms, $extras, $meals, $total, ";
  }
}

class NewExtras {
  NewExtras({
    required this.amount,
    required this.vat,
    required this.total,
    required this.discount,
    required this.currency,
    required this.vatRate,
  });

  final num amount;
  final num vat;
  final num total;
  final num discount;
  final String currency;
  final num vatRate;

  factory NewExtras.fromJson(Map<String, dynamic> json) {
    return NewExtras(
      amount: json["amount"] ?? 0,
      vat: json["vat"] ?? 0,
      total: json["total"] ?? 0,
      discount: json["discount"] ?? 0,
      currency: json["currency"] ?? "",
      vatRate: json["vat_rate"] ?? 0,
    );
  }

  @override
  String toString() {
    return "$amount, $vat, $total, $discount, $currency, $vatRate, ";
  }
}

class NewRoom {
  NewRoom({
    required this.idZakRoom,
    required this.idZakReservationRoom,
    required this.doorCode,
    required this.idZakRoomType,
    required this.dfrom,
    required this.dto,
    required this.occupancy,
    required this.customers,
  });

  final int idZakRoom;
  final int idZakReservationRoom;
  final dynamic doorCode;
  final int idZakRoomType;
  final String dfrom;
  final String dto;
  final NewOccupancy? occupancy;
  final List<NewCustomer> customers;

  factory NewRoom.fromJson(Map<String, dynamic> json) {
    return NewRoom(
      idZakRoom: json["id_zak_room"] ?? 0,
      idZakReservationRoom: json["id_zak_reservation_room"] ?? 0,
      doorCode: json["door_code"],
      idZakRoomType: json["id_zak_room_type"] ?? 0,
      dfrom: json["dfrom"] ?? "",
      dto: json["dto"] ?? "",
      occupancy: json["occupancy"] == null
          ? null
          : NewOccupancy.fromJson(json["occupancy"]),
      customers: json["customers"] == null
          ? []
          : List<NewCustomer>.from(
              json["customers"]!.map((x) => NewCustomer.fromJson(x))),
    );
  }

  @override
  String toString() {
    return "$idZakRoom, $idZakReservationRoom, $doorCode, $idZakRoomType, $dfrom, $dto, $occupancy, $customers, ";
  }
}

class NewCustomer {
  NewCustomer({
    required this.checkin,
    required this.checkout,
    required this.id,
    required this.arrived,
    required this.departed,
  });

  final String checkin;
  final String checkout;
  final int id;
  final String arrived;
  final String departed;

  factory NewCustomer.fromJson(Map<String, dynamic> json) {
    return NewCustomer(
      checkin: json["checkin"] ?? "",
      checkout: json["checkout"] ?? "",
      id: json["id"] ?? 0,
      arrived: json["arrived"] ?? "",
      departed: json["departed"] ?? "",
    );
  }

  @override
  String toString() {
    return "$checkin, $checkout, $id, $arrived, $departed, ";
  }
}

class NewOccupancy {
  NewOccupancy({
    required this.adults,
    required this.teens,
    required this.children,
    required this.babies,
  });

  final num adults;
  final num teens;
  final num children;
  final num babies;

  factory NewOccupancy.fromJson(Map<String, dynamic> json) {
    return NewOccupancy(
      adults: json["adults"] ?? 0,
      teens: json["teens"] ?? 0,
      children: json["children"] ?? 0,
      babies: json["babies"] ?? 0,
    );
  }

  @override
  String toString() {
    return "$adults, $teens, $children, $babies, ";
  }
}

class NewTaxes {
  NewTaxes({
    required this.rsrvTax,
    required this.currency,
    required this.roomTax,
  });

  final NewExtras? rsrvTax;
  final String currency;
  final NewRoomTax? roomTax;

  factory NewTaxes.fromJson(Map<String, dynamic> json) {
    return NewTaxes(
      rsrvTax: json["rsrv_tax"] == null
          ? null
          : NewExtras.fromJson(json["rsrv_tax"]),
      currency: json["currency"] ?? "",
      roomTax: json["room_tax"] == null
          ? null
          : NewRoomTax.fromJson(json["room_tax"]),
    );
  }

  @override
  String toString() {
    return "$rsrvTax, $currency, $roomTax, ";
  }
}

class NewRoomTax {
  NewRoomTax({required this.json});
  final Map<String, dynamic> json;

  factory NewRoomTax.fromJson(Map<String, dynamic> json) {
    return NewRoomTax(json: json);
  }

  @override
  String toString() {
    return "";
  }
}
