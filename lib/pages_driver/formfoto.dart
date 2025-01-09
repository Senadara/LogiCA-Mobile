import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:logica_mobile/pages_driver/form.dart';

class SupirFormfoto extends StatefulWidget {
  @override
  _SupirFormfotoState createState() => _SupirFormfotoState();
}

class _SupirFormfotoState extends State<SupirFormfoto> {
  File? _imageFile; // File untuk menyimpan foto yang diambil
  final _formKey = GlobalKey<FormState>(); // GlobalKey untuk Form
  final TextEditingController licensePlateController = TextEditingController(); // Controller untuk TextFormField

  // Fungsi untuk mengambil foto dari kamera
  Future<void> _pickImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // Simpan foto ke dalam file
      });
    }
  }

  // Fungsi untuk memilih foto dari galeri
  Future<void> _pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // Simpan foto ke dalam file
      });
    }
  }

  @override
  void dispose() {
    licensePlateController.dispose(); // Hapus controller saat tidak lagi digunakan
    super.dispose();
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
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Informasi Kendaraan",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: licensePlateController,
                decoration: const InputDecoration(
                  labelText: "License Plate",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "License Plate tidak boleh kosong!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                "Foto Kendaraan",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => _buildBottomSheet(),
                  );
                },
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: _imageFile == null
                        ? const Icon(Icons.camera_alt, size: 50, color: Colors.grey)
                        : Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B6BA7),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_imageFile == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Silakan ambil atau pilih foto kendaraan!")),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MaintenanceRequestScreen()),
                      );
                    }
                  }
                },
                child: const Text("Selanjutnya"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Modal Bottom Sheet untuk memilih kamera atau galeri
  Widget _buildBottomSheet() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.camera, color: Colors.blue),
          title: const Text('Ambil Foto dari Kamera'),
          onTap: () {
            Navigator.pop(context); // Tutup Bottom Sheet
            _pickImageFromCamera(); // Ambil foto dari kamera
          },
        ),
        ListTile(
          leading: const Icon(Icons.photo, color: Colors.blue),
          title: const Text('Pilih Foto dari Galeri'),
          onTap: () {
            Navigator.pop(context); // Tutup Bottom Sheet
            _pickImageFromGallery(); // Pilih foto dari galeri
          },
        ),
      ],
    );
  }
}
