import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:logica_mobile/pages_mechanic/ongoing_mekanik.dart';
import 'package:logica_mobile/pages_mechanic/pilih_mekanik.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MekanikDashboard());
}

class MekanikDashboard extends StatelessWidget {
  const MekanikDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MekanikDashboardPage(),
    );
  }
}

class MekanikDashboardPage extends StatefulWidget {
  const MekanikDashboardPage({Key? key}) : super(key: key);

  @override
  _MekanikDashboardPageState createState() => _MekanikDashboardPageState();
}

class _MekanikDashboardPageState extends State<MekanikDashboardPage> {
  String userName = 'Unknown';
  String workshopName = 'Unknown Workshop';
  List<Map<String, dynamic>> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadTasks();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('userData');

    if (userDataString != null) {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      setState(() {
        userName = userData['name'];
        workshopName = userData['workshop_name'] ?? 'Unknown Workshop';
      });
    }
  }

  Future<void> _loadTasks() async {
    await _refreshMaintenanceSchedule();
  }

  Future<void> _refreshMaintenanceSchedule() async {
    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:8000/api/maintenance"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List<dynamic>) {
          setState(() {
            tasks = List<Map<String, dynamic>>.from(data);
          });
        } else {
          print("Unexpected response format: $data");
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Gagal memuat jadwal maintenance")),
          );
        }
      }
    } catch (e) {
      print("Error fetching maintenance schedule: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Terjadi kesalahan: $e")),
        );
      }
    }
  }

  List<Map<String, dynamic>> _getFilteredTasks(String status) {
    return tasks.where((task) {
      String taskStatus = (task['status'] ?? '').toLowerCase();
      return taskStatus == status.toLowerCase();
    }).toList();
  }

  bool _isToday(String? dateStr) {
    if (dateStr == null) return false;
    try {
      final taskDate = DateTime.parse(dateStr);
      final now = DateTime.now();
      return taskDate.year == now.year &&
          taskDate.month == now.month &&
          taskDate.day == now.day;
    } catch (e) {
      return false;
    }
  }

  List<Map<String, dynamic>> _getTodayTasks() {
    return tasks.where((task) => _isToday(task['date'])).toList();
  }

  @override
  Widget build(BuildContext context) {
    final ongoingTasks = _getFilteredTasks('on going');
    final pendingTasks = _getFilteredTasks('pending');
    final completedTasks = _getFilteredTasks('completed');
    final todayTasks = _getTodayTasks();

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
                    'LogiCa Mekanik',
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
              child: RefreshIndicator(
                onRefresh: _refreshMaintenanceSchedule,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    WelcomeCard(userName: userName, workshopName: workshopName),
                    const SizedBox(height: 16.0),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OngoingService()));
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
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MechanicSelectionScreen(),
                                    ),
                                  );
                                },
                                child: Card(
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      children: const [
                                        Icon(Icons.insert_drive_file, size: 32),
                                        SizedBox(height: 8),
                                        Text(
                                          'Laporan',
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
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24.0),
                    if (ongoingTasks.isNotEmpty) ...[
                      const SectionHeader(title: 'Dikerjakan'),
                      ...ongoingTasks.map((task) => TaskCard(
                            title:
                                task['tipe_maintenance'] ?? 'Tidak diketahui',
                            subtitle:
                                '${task['date'] ?? ''} - ${task['name'] ?? ''}',
                            status: 'On-going',
                            statusColor: _getStatusColor('on going'),
                          )),
                      const SizedBox(height: 16.0),
                    ] else ...[
                      const SectionHeader(title: 'Dikerjakan'),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: Text('Empty',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey)),
                        ),
                      ),
                    ],
                    if (todayTasks.isNotEmpty) ...[
                      const SectionHeader(title: 'Tugas Hari Ini'),
                      ...todayTasks.map((task) => TaskCard(
                            title:
                                task['tipe_maintenance'] ?? 'Tidak diketahui',
                            subtitle:
                                '${task['date'] ?? ''} - ${task['name'] ?? ''}',
                            status: task['status'] ?? '',
                            statusColor: _getStatusColor(task['status'] ?? ''),
                          )),
                      const SizedBox(height: 16.0),
                    ] else ...[
                      const SectionHeader(title: 'Tugas Hari Ini'),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: Text('Empty',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey)),
                        ),
                      ),
                    ],
                    if (pendingTasks.isNotEmpty) ...[
                      const SectionHeader(title: 'Menunggu'),
                      ...pendingTasks.map((task) => TaskCard(
                            title:
                                task['tipe_maintenance'] ?? 'Tidak diketahui',
                            subtitle:
                                '${task['date'] ?? ''} - ${task['name'] ?? ''}',
                            status: 'Pending',
                            statusColor: _getStatusColor('pending'),
                          )),
                      const SizedBox(height: 16.0),
                    ],
                    if (completedTasks.isNotEmpty) ...[
                      const SectionHeader(title: 'Selesai'),
                      ...completedTasks.map((task) => TaskCard(
                            title:
                                task['tipe_maintenance'] ?? 'Tidak diketahui',
                            subtitle:
                                '${task['date'] ?? ''} - ${task['name'] ?? ''}',
                            status: 'Completed',
                            statusColor: _getStatusColor('completed'),
                          )),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Servis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_drive_file),
            label: 'Laporan',
          ),
        ],
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'on going':
      case 'on-going':
        return Colors.blue;
      case 'pending':
      case 'ready':
        return Colors.green;
      case 'completed':
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }
}

// [Widget classes remain the same as before]
class WelcomeCard extends StatelessWidget {
  final String userName;
  final String workshopName;

  const WelcomeCard({
    Key? key,
    required this.userName,
    required this.workshopName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Selamat Datang,',
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            Text(userName,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(workshopName,
                style: const TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title,
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
    );
  }
}

class TaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final Color statusColor;

  const TaskCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.statusColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8.0),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 14.0, color: Colors.black54)),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                status,
                style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: statusColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
