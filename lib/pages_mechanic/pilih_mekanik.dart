import 'package:flutter/material.dart';

class MechanicSelectionScreen extends StatefulWidget {
  const MechanicSelectionScreen({super.key});

  @override
  _MechanicSelectionScreenState createState() =>
      _MechanicSelectionScreenState();
}

class _MechanicSelectionScreenState extends State<MechanicSelectionScreen> {
  List<Map<String, dynamic>> mechanics = [];
  Map<String, dynamic>? selectedMechanic;

  @override
  void initState() {
    super.initState();
    _loadMechanics();
  }

  void _loadMechanics() {
    mechanics = [
      {'name': 'Budiono Siregar', 'fullName': 'Budiono Siregar'},
      {'name': 'Adi Santoso', 'fullName': 'Adi Prasetyo Santoso'},
      {'name': 'Mingyu', 'fullName': 'Kim Mingyu'},
      {'name': 'Lisa', 'fullName': 'Lalisa Manoban'},
      {'name': 'JK', 'fullName': 'Jungkook'},
      {'name': 'JM', 'fullName': 'Jimin'},
      // Tambahkan mekanik lainnya
    ];
  }

  Future<void> _saveSelectedMechanic() async {
  if (selectedMechanic == null) return;

  // Navigasi langsung ke dashboard
  Navigator.pushNamed(context, '/MekanikDashboard'); 
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('LogiCa Mekanik'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informasi Kendaraan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('License Plate: BMW - Z 78123 WY'),
                  Text('Maintenance: Service Rutin'),
                  Text('Tanggal: 18-01-2004'),
                  Text('Catatan Tambahan: dimana mana itu ada getah'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select Mekanik',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButton<Map<String, dynamic>>(
              isExpanded: true,
              value: selectedMechanic,
              hint: const Text('Pilih mekanik'),
              onChanged: (newValue) {
                setState(() {
                  selectedMechanic = newValue;
                });
              },
              items: mechanics.map<DropdownMenuItem<Map<String, dynamic>>>(
                  (Map<String, dynamic> mechanic) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: mechanic,
                  child: Text(mechanic['fullName']),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: selectedMechanic == null ? null : _saveSelectedMechanic,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 12),
                ),
                child: const Text(
                  'Kerjakan',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Service',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
