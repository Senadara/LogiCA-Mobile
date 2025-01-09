import 'dart:convert';
import 'maintenance_model.dart';

// Fungsi untuk mem-parsing response dari backend ke dalam list MaintenanceModel
List<MaintenanceModel> maintenanceModelFromJson(String str) {
  final jsonData = json.decode(str);
  return List<MaintenanceModel>.from(
    jsonData.map((item) => MaintenanceModel.fromJson(item)),
  );
}

// Fungsi untuk mengonversi objek ke JSON
String maintenanceModelToJson(List<MaintenanceModel> data) {
  return json.encode(List<dynamic>.from(data.map((item) => item.toJson())));
}
