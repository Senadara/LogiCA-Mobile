import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logica_mobile/pages_driver/formfoto.dart';
import 'package:logica_mobile/pages_driver/maintenance.dart';
import 'package:logica_mobile/notification.dart';
import 'package:http/http.dart' as http;


class SupirDashboard extends StatefulWidget {
  final NotificationService notificationService;
  const SupirDashboard({Key? key, required this.notificationService})
      : super(key: key);

  @override
  _SupirDashboardState createState() => _SupirDashboardState();
}

class _SupirDashboardState extends State<SupirDashboard> {
  String userName = 'Supir';
  String licensePlate = 'Unknown';
  String lastMaintenanceDate = 'Unknown';
  String vehicleStatus = "Unknown";
  String maintenanceStatus = "Unknown";

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadUserVehicle();
  }

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('userData');

    if (userDataString != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      setState(() {
        userName = userData['name'];
      });
    }
  }

  Future<void> _loadUserVehicle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('userVehicle');

    if (userDataString != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      setState(() {
        licensePlate = userData['license_plate'];
        lastMaintenanceDate = userData['last_maintenance_date'];
        maintenanceStatus = userData['status'];
        print( userData['status']);
        _updateVehicleStatus();
      });
    }
  }

  void _updateVehicleStatus() {
    if (lastMaintenanceDate != 'Unknown') {
      // Parse last maintenance date
      DateTime maintenanceDate = DateTime.parse(lastMaintenanceDate);
      DateTime currentDate = DateTime.now();

      // Calculate the difference in months
      int differenceInMonths = (currentDate.year - maintenanceDate.year) * 12 +
          currentDate.month -
          maintenanceDate.month;

      // Update status based on the difference
      setState(() {
        if (differenceInMonths > 6) {
          vehicleStatus = 'Need Maintenance';
        } else {
          vehicleStatus = 'In Good Condition';
        }
      });
    }
  }

  Future<void> _refreshMaintenanceSchedule() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userDataString = prefs.getString('userData');

      if (userDataString != null) {
        Map<String, dynamic> userData = jsonDecode(userDataString);

        // Pastikan 'id' ada dan bertipe sesuai
        if (userData.containsKey('id')) {
          final userId = userData['id']; // Gunakan apa adanya tanpa .toString()

          final response = await http.get(
            Uri.parse("http://10.0.2.2:8000/api/maintenance/$userId?status="),
            headers: {"Content-Type": "application/json"},
          );

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);

            // Validasi tipe data yang diterima
            if (data is Map<String, dynamic>) {
              setState(() {
                maintenanceStatus = data['status'] ?? "Unknown";
                lastMaintenanceDate = data['last_maintenance_date'] ?? "Unknown";
              });
            } else {
              print("Unexpected response format: $data");
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Gagal memuat jadwal maintenance")),
            );
          }
        } else {
          print("User data does not contain 'id': $userData");
        }
      }
    } catch (e) {
      print("Error fetching maintenance schedule: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFF3B6BA7),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'LogiCa Driver',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: const [
                      Icon(Icons.notifications_outlined, color: Colors.white),
                      SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: Colors.white54,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selamat Datang,',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            licensePlate,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Status Kendaraan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$vehicleStatus - Last Service $lastMaintenanceDate',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SupirFormfoto(),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: const [
                            Icon(Icons.build, size: 32),
                            SizedBox(height: 8),
                            Text(
                              'Form Maintenance',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  maintenanceStatus != 'available'
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        'Jadwal Maintenance',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Maintenance(),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Servis Rutin',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '$lastMaintenanceDate',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: maintenanceStatus == 'maintenance'
                                        ? const Color(0xFFF26868)
                                        : Colors.orange,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    maintenanceStatus == 'maintenance'
                                        ? 'Maintenance'
                                        : 'Unavailable',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text("Refresh Jadwal Maintenance"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B6BA7),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _refreshMaintenanceSchedule,
                      ),
                    ],
                  )
                      : SizedBox(),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF3B6BA7),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(Icons.home, color: Colors.white, size: 28),
                Icon(Icons.build, color: Colors.white, size: 28),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
