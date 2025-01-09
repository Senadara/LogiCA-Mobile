class Vehicle {
  final String id;
  final String name;
  final String plateNumber;
  final String status;

  Vehicle({
    required this.id,
    required this.name,
    required this.plateNumber,
    required this.status,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json["id"].toString(),
      name: json["name"] ?? '',
      plateNumber: json["plate_number"] ?? '',
      status: json["status"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "plate_number": plateNumber,
      "status": status,
    };
  }
}
