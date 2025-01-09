import 'vehicle_model.dart';

class MaintenanceModel {
  final String id;
  final String status;
  final String mechanicId;
  final Vehicle vehicle;
  final String evidencePhoto;
  final String createdAt;
  final String updatedAt;

  MaintenanceModel({
    required this.id,
    required this.status,
    required this.mechanicId,
    required this.vehicle,
    required this.evidencePhoto,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MaintenanceModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceModel(
      id: json["id"].toString(),
      status: json["status"] ?? '',
      mechanicId: json["mechanic_id"].toString(),
      vehicle: Vehicle.fromJson(json["vehicle"]),
      evidencePhoto: json["evidence_photo"] ?? '',
      createdAt: json["created_at"] ?? '',
      updatedAt: json["updated_at"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "status": status,
      "mechanic_id": mechanicId,
      "vehicle": vehicle.toJson(),
      "evidence_photo": evidencePhoto,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }
}

