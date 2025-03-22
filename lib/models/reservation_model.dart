class ReservationModel {
  ReservationModel({
    required this.roomName,
    required this.reservations,
  });

  final String roomName;
  final List<Reservation> reservations;

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      roomName: json["roomName"] ?? "",
      reservations: json["reservations"] == null
          ? []
          : List<Reservation>.from(json["reservations"]!.map((x) {
              return Reservation.fromJson(x, json["room_id"].toString());
            })),
    );
  }

  @override
  String toString() {
    return "$roomName, $reservations, ";
  }
}

class Reservation {
  Reservation({
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
  final Origin? origin;
  final String lastStatusDate;
  final String board;
  final String created;
  final String cpolicy;
  final String agency;
  final dynamic corporate;
  final Price? price;
  final Payment? payment;
  final Taxes? taxes;
  final List<Room> rooms;
  final String customerName;
  final String customerPhone;
  final String customerSurName;
  final List<Note> notes;

  factory Reservation.fromJson(
    Map<String, dynamic> json,
    String roomId,
  ) {
    return Reservation(
      roomId: roomId,
      id: json["id"] ?? 0,
      idHuman: json["id_human"] ?? "",
      booker: json["booker"] ?? 0,
      status: json["status"] ?? "",
      expirationDate: json["expiration_date"] ?? "",
      origin: json["origin"] == null ? null : Origin.fromJson(json["origin"]),
      lastStatusDate: json["last_status_date"] ?? "",
      board: json["board"] ?? "",
      created: json["created"] ?? "",
      cpolicy: json["cpolicy"] ?? "",
      agency: json["agency"] ?? "",
      corporate: json["corporate"],
      price: json["price"] == null ? null : Price.fromJson(json["price"]),
      payment:
          json["payment"] == null ? null : Payment.fromJson(json["payment"]),
      taxes: json["taxes"] == null ? null : Taxes.fromJson(json["taxes"]),
      rooms: json["rooms"] == null
          ? []
          : List<Room>.from(
              json["rooms"]!
                  .where((x) => x["id_zak_room"].toString() == roomId)
                  .map((x) => Room.fromJson(x)),
            ),
      customerName: json["customerName"] ?? "",
      customerPhone: json["customerPhone"] ?? "",
      customerSurName: json["customerSurName"] ?? "",
      notes: json["notes"] == null
          ? []
          : List<Note>.from(json["notes"]!.map((x) => Note.fromJson(x))),
    );
  }

  @override
  String toString() {
    return "$id, $idHuman, $booker, $status, $expirationDate, $origin, $lastStatusDate, $board, $created, $cpolicy, $agency, $corporate, $price, $payment, $taxes, $rooms, $customerName, $notes, ";
  }
}

class Note {
  Note({
    required this.id,
    required this.remarks,
  });

  final int id;
  final String remarks;

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json["id"] ?? 0,
      remarks: json["remarks"] ?? "",
    );
  }

  @override
  String toString() {
    return "$id, $remarks, ";
  }
}

class Origin {
  Origin({
    required this.channel,
  });

  final String channel;

  factory Origin.fromJson(Map<String, dynamic> json) {
    return Origin(
      channel: json["channel"] ?? "",
    );
  }

  @override
  String toString() {
    return "$channel, ";
  }
}

class Payment {
  Payment({
    required this.amount,
    required this.currency,
  });

  final num amount;
  final String currency;

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      amount: json["amount"] ?? 0,
      currency: json["currency"] ?? "",
    );
  }

  @override
  String toString() {
    return "$amount, $currency, ";
  }
}

class Price {
  Price({
    required this.rooms,
    required this.extras,
    required this.meals,
    required this.total,
  });

  final Extras? rooms;
  final Extras? extras;
  final Extras? meals;
  final num total;

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      rooms: json["rooms"] == null ? null : Extras.fromJson(json["rooms"]),
      extras: json["extras"] == null ? null : Extras.fromJson(json["extras"]),
      meals: json["meals"] == null ? null : Extras.fromJson(json["meals"]),
      total: json["total"] ?? 0,
    );
  }

  @override
  String toString() {
    return "$rooms, $extras, $meals, $total, ";
  }
}

class Extras {
  Extras({
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

  factory Extras.fromJson(Map<String, dynamic> json) {
    return Extras(
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

class Room {
  Room({
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
  final Occupancy? occupancy;
  final List<Customer> customers;

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      idZakRoom: json["id_zak_room"] ?? 0,
      idZakReservationRoom: json["id_zak_reservation_room"] ?? 0,
      doorCode: json["door_code"],
      idZakRoomType: json["id_zak_room_type"] ?? 0,
      dfrom: json["dfrom"] ?? "",
      dto: json["dto"] ?? "",
      occupancy: json["occupancy"] == null
          ? null
          : Occupancy.fromJson(json["occupancy"]),
      customers: json["customers"] == null
          ? []
          : List<Customer>.from(
              json["customers"]!.map((x) => Customer.fromJson(x))),
    );
  }

  @override
  String toString() {
    return "$idZakRoom, $idZakReservationRoom, $doorCode, $idZakRoomType, $dfrom, $dto, $occupancy, $customers, ";
  }
}

class Customer {
  Customer({
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

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
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

class Occupancy {
  Occupancy({
    required this.adults,
    required this.teens,
    required this.children,
    required this.babies,
  });

  final num adults;
  final num teens;
  final num children;
  final num babies;

  factory Occupancy.fromJson(Map<String, dynamic> json) {
    return Occupancy(
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

class Taxes {
  Taxes({
    required this.rsrvTax,
    required this.currency,
    required this.roomTax,
  });

  final Extras? rsrvTax;
  final String currency;
  final RoomTax? roomTax;

  factory Taxes.fromJson(Map<String, dynamic> json) {
    return Taxes(
      rsrvTax:
          json["rsrv_tax"] == null ? null : Extras.fromJson(json["rsrv_tax"]),
      currency: json["currency"] ?? "",
      roomTax:
          json["room_tax"] == null ? null : RoomTax.fromJson(json["room_tax"]),
    );
  }

  @override
  String toString() {
    return "$rsrvTax, $currency, $roomTax, ";
  }
}

class RoomTax {
  RoomTax({required this.json});
  final Map<String, dynamic> json;

  factory RoomTax.fromJson(Map<String, dynamic> json) {
    return RoomTax(json: json);
  }

  @override
  String toString() {
    return "";
  }
}
