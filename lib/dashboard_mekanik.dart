import 'package:flutter/material.dart';

class MekanikDashboardPage extends StatelessWidget {
  const MekanikDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF255BAF), // Warna biru sesuai gambar
        title: const Text('LogiCa Mekanik'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Navigasi ke halaman notifikasi
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selamat Datang,',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const Text(
              'Dayat Mekanik',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Bengkel Utama Sepanjang',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMenuCard(Icons.build, 'Jadwal Servis', () {
                  // Navigasi ke halaman jadwal servis
                }),
                _buildMenuCard(Icons.description, 'Laporan', () {
                  // Navigasi ke halaman laporan
                }),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Dikerjakan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildTaskCard('Servis Rutin', 'Supaidi', '15 Januari 2024 - 10.00', 'On-going', Colors.blue),
            const SizedBox(height: 10),
            const Text(
              'Tugas Hari Ini',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildTaskCard('Servis Rutin', '', '15 Januari 2024 - 10.00', 'Ready', Colors.green),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
            icon: Icon(Icons.description),
            label: 'Laporan',
          ),
        ],
        selectedItemColor: Colors.blue,
        onTap: (index) {
          // Tambahkan navigasi sesuai index
        },
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
}
