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
  String maintenanceDate = "Unknown";
  String maintenanceTipe = "Unknown";

  @override
  void initState() {
    super.initState();
    _refreshMaintenanceSchedule();
   /*  _loadUserName();
    _loadUserVehicle(); */
     _loadUserData();
  }

  /* Future<void> _loadUserName() async {
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
        _updateVehicleStatus();
      });
    }
  }
 */
Future<void> _loadUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      
      // Load user data
      String? userDataString = prefs.getString('userData');
      if (userDataString != null) {
        Map<String, dynamic> userData = jsonDecode(userDataString);
        setState(() {
          userName = userData['name'] ?? 'Supir';
        });
      }

      // Load vehicle data
      String? vehicleDataString = prefs.getString('userVehicle');
      if (vehicleDataString != null) {
        Map<String, dynamic> vehicleData = jsonDecode(vehicleDataString);
        setState(() {
          licensePlate = vehicleData['license_plate'] ?? 'Unknown';
          lastMaintenanceDate = vehicleData['last_maintenance_date'] ?? 'Unknown';
          maintenanceStatus = vehicleData['status'] ?? 'Unknown';
          _updateVehicleStatus();
        });
      }
    } catch (e) {
      print('Error loading data: $e');
      // Handle error gracefully - maybe show a snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading user data')),
        );
      }
    }
  }
  void _updateVehicleStatus() {
    if (lastMaintenanceDate != 'Unknown') {
      DateTime maintenanceDate = DateTime.parse(lastMaintenanceDate);
      DateTime currentDate = DateTime.now();

      int differenceInMonths = (currentDate.year - maintenanceDate.year) * 12 +
          currentDate.month -
          maintenanceDate.month;

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

        if (userData.containsKey('id')) {
          final userId = userData['id'];

          final response = await http.get(
            Uri.parse("http://10.0.2.2:8000/api/maintenance/$userId?status="),
            headers: {"Content-Type": "application/json"},
          );

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);

            if (data is List && data.isNotEmpty) {
              // Ambil data terakhir berdasarkan waktu 'created_at'
              data.sort((a, b) => b['created_at'].compareTo(a['created_at']));
              final latestData = data.first;

              setState(() {
                maintenanceStatus = latestData['status'] ?? 'Unknown';
                maintenanceDate = latestData['date'] ?? 'Unknown';
                maintenanceTipe = latestData['tipe_maintenance'] ?? 'Unknown';
              });
            } else {
              setState(() {
                maintenanceStatus = 'No Data';
                maintenanceDate = 'Unknown';
                maintenanceTipe = 'Unknown';
              });
              print("No maintenance data available.");
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

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Menghapus semua data di SharedPreferences
    Navigator.pushReplacementNamed(context, '/'); // Arahkan ke halaman login
  }

  Future<bool> _showLogoutConfirmation() async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi Logout"),
          content: const Text("Apakah Anda yakin ingin logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Logout"),
            ),
          ],
        );
      },
    ) ??
        false;
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
                    children: [
                      const Icon(Icons.notifications_outlined, color: Colors.white),
                      const SizedBox(width: 8),
                      PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'logout') {
                            bool confirmLogout = await _showLogoutConfirmation();
                            if (confirmLogout) {
                              _logout();
                            }
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem<String>(
                            value: 'logout',
                            child: Text('Logout'),
                          ),
                        ],
                        child: const CircleAvatar(
                          backgroundColor: Colors.white54,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
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
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text("Refresh"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B6BA7),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _refreshMaintenanceSchedule,
                  ),
                  maintenanceStatus != 'Completed'
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
                                    Text(
                                      maintenanceTipe,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      maintenanceDate,
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
                                    color: maintenanceStatus == 'pending'
                                        ? Colors.orange
                                        : maintenanceStatus == 'On Going'
                                        ? Colors.blue
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    maintenanceStatus == 'pending'
                                        ? 'Pending'
                                        : maintenanceStatus == 'On Going'
                                        ? 'On Going'
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
                    ],
                  )
                      : SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
  currentIndex: 0,
  onTap: (index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SupirFormfoto()),
      );
    }
  },
  items: const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.mail),
      label: 'Maintenance',
    ),
  ],
),

    );

  }
}
