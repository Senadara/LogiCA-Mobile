import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
      });
    }
  }

  Future<void> _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? taskDataString = prefs.getString('taskData');

    if (taskDataString != null) {
      List<dynamic> taskData = jsonDecode(taskDataString);
      setState(() {
        tasks = List<Map<String, dynamic>>.from(taskData);
      });
    }
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal memuat jadwal maintenance")),
        );
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF255BAF),
        title: const Text('LogiCa Mekanik'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Selamat Datang,', style: TextStyle(fontSize: 16, color: Colors.grey)),
            Text(userName, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(workshopName, style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMenuCard(Icons.build, 'Jadwal Servis', () {}),
                _buildMenuCard(Icons.description, 'Laporan', () {}),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text("Refresh Jadwal Maintenance"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B6BA7),
                foregroundColor: Colors.white,
              ),
              onPressed: _refreshMaintenanceSchedule,
            ),
            const Text('Tugas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...tasks.map((task) {
              return _buildTaskCard(
                task['tipe_maintenance'] ?? 'Tidak diketahui',
                task['name'] ?? '',
                task['date'] ?? '',
                task['status'] ?? '',
                _getStatusColor(task['status'] ?? ''),
              );
            }).toList(),
            TextButton(onPressed: (){
                Navigator.pushNamed(context, '/ong');
              }, 
              child: Text('ongoing'),
            ),
            TextButton(onPressed: (){
                Navigator.pushNamed(context, '/red');
              }, 
              child: Text('ready'),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Servis'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.description), label: 'Laporan'),
        ],
        selectedItemColor: Colors.blue,
        onTap: (index) {},
      ),
    );
  }

  Widget _buildMenuCard(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Icon(icon, size: 40),
            ),
          ),
          const SizedBox(height: 5),
          Text(title, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildTaskCard(String title, String name, String time, String status, Color statusColor) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$name\n$time'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            status,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'on going':
        return Colors.blue;
      case 'pending':
        return Colors.green;
      case 'completed':
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }
}
