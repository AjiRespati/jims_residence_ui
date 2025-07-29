// lib/models/tenant.dart

class Tenant {
  final String id;
  final String roomId;
  final String name;
  final String phone;
  final String nikNumber;
  final String? nikImagePath; // Nullable
  final bool isNikCopyDone;
  final String tenancyStatus;
  final DateTime? startDate; // Nullable
  final DateTime? dueDate; // Nullable
  final DateTime? banishDate; // Nullable
  final DateTime? endDate; // Nullable
  final DateTime? checkinDate; // Nullable
  final DateTime? checkoutDate; // Nullable
  final String? createBy; // Nullable
  final String? updateBy; // Nullable
  final DateTime createdAt;
  final DateTime updatedAt;

  Tenant({
    required this.id,
    required this.roomId,
    required this.name,
    required this.phone,
    required this.nikNumber,
    this.nikImagePath,
    required this.isNikCopyDone,
    required this.tenancyStatus,
    this.startDate,
    this.dueDate,
    this.banishDate,
    this.endDate,
    this.checkinDate,
    this.checkoutDate,
    this.createBy,
    this.updateBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) {
    return Tenant(
      id: json['id'],
      roomId: json['roomId'],
      name: json['name'],
      phone: json['phone'],
      nikNumber: json['NIKNumber'],
      nikImagePath: json['NIKImagePath'],
      isNikCopyDone: json['isNIKCopyDone'],
      tenancyStatus: json['tenancyStatus'],
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      banishDate:
          json['banishDate'] != null
              ? DateTime.parse(json['banishDate'])
              : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      checkinDate:
          json['checkinDate'] != null
              ? DateTime.parse(json['checkinDate'])
              : null,
      checkoutDate:
          json['checkoutDate'] != null
              ? DateTime.parse(json['checkoutDate'])
              : null,
      createBy: json['createBy'],
      updateBy: json['updateBy'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'name': name,
      'phone': phone,
      'NIKNumber': nikNumber,
      'NIKImagePath': nikImagePath,
      'isNIKCopyDone': isNikCopyDone,
      'tenancyStatus': tenancyStatus,
      'startDate': startDate?.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'banishDate': banishDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'checkinDate': checkinDate?.toIso8601String(),
      'checkoutDate': checkoutDate?.toIso8601String(),
      'createBy': createBy,
      'updateBy': updateBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
