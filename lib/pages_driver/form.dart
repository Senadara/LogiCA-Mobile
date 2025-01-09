import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MaintenanceRequestScreen extends StatefulWidget {
  @override
  _MaintenanceRequestScreenState createState() =>
      _MaintenanceRequestScreenState();
}

class _MaintenanceRequestScreenState extends State<MaintenanceRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  bool _isLoading = false;
  String userId = "1";
  String vehicleId = "1";
  final String baseurl = "http://10.0.2.2:8000/api/maintenance"; // Endpoint API
  final client = http.Client(); // Inisialisasi HTTP Client

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Load user data
    String? userDataString = prefs.getString('userData');
    if (userDataString != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      setState(() {
        userId = userData['id'];
        vehicleId = userData['vehicle_id'];
      });
    }

    // Load vehicle data
    // String? vehicleDataString = prefs.getString('userVehicle');
    // if (vehicleDataString != null) {
    //   Map<String, dynamic> vehicleData = jsonDecode(vehicleDataString);
    //   setState(() {
    //     vehicleId = vehicleData['id'].toString();
    //   });
    // }
  }

  Future<void> _selectDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        dateController.text =
        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<dynamic> post({required String title}) async {
    var url = Uri.parse(baseurl);
    var body = {"title": title};

    try {
      var response = await client.post(url, body: body);

      if (response.statusCode == 201) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      print("Error in POST request: $e");
      return null;
    }
  }

  Future<void> submitMaintenance() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String type = typeController.text;
    final String note = notesController.text;
    final String date = dateController.text;

    if (userId.isEmpty || vehicleId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data user atau kendaraan tidak ditemukan!")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var body = {
        "user_id": userId,
        "vehicle_id": vehicleId,
        "tipe_maintenance": type,
        "note": note,
        "evidence_photo": "", // Tambahkan jika ada file
        "date": date,
      };

      var response = await client.post(
        Uri.parse(baseurl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data berhasil disimpan")),
        );
        Navigator.pop(context);
      } else {
        final error = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error['message'] ?? "Gagal menyimpan data")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LogiCa',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF3B6BA7),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInputField(
                label: "Tipe Maintenance",
                controller: typeController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Tipe Maintenance tidak boleh kosong!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildInputField(
                label: "Tanggal Maintenance",
                controller: dateController,
                readOnly: true,
                onTap: _selectDate,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Tanggal Maintenance tidak boleh kosong!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildInputField(
                label: "Catatan Tambahan",
                controller: notesController,
                maxLines: 4,
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B6BA7),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: submitMaintenance,
                child: const Text("Submit Request"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    int maxLines = 1,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            maxLines: maxLines,
            onTap: onTap,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            validator: validator,
          ),
        ],
      ),
    );
  }
}
