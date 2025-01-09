import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:logica_mobile/pages_driver/form.dart';

class SupirFormfoto extends StatefulWidget {
  @override
  _SupirFormfotoState createState() => _SupirFormfotoState();
}

class _SupirFormfotoState extends State<SupirFormfoto> {
  File? _imageFile; 
  final _formKey = GlobalKey<FormState>();
  final TextEditingController licensePlateController = TextEditingController(); 

  
  Future<void> _pickImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

 
  Future<void> _pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); 
      });
    }
  }

  @override
  void dispose() {
    licensePlateController.dispose();
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
              // const SizedBox(height: 10),
              // TextFormField(
              //   controller: licensePlateController,
              //   decoration: const InputDecoration(
              //     labelText: "License Plate",
              //     border: OutlineInputBorder(),
              //   ),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return "License Plate tidak boleh kosong!";
              //     }
              //     return null;
              //   },
              // ),
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
     bottomNavigationBar: BottomNavigationBar(
  currentIndex: 1,
  onTap: (index) {
    if (index == 0) {
      Navigator.pop(context);
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

    Widget _buildBottomSheet() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.camera, color: Colors.blue),
          title: const Text('Ambil Foto dari Kamera'),
          onTap: () {
            Navigator.pop(context); 
            _pickImageFromCamera(); 
          },
        ),
        ListTile(
          leading: const Icon(Icons.photo, color: Colors.blue),
          title: const Text('Pilih Foto dari Galeri'),
          onTap: () {
            Navigator.pop(context); 
            _pickImageFromGallery(); 
          },
        ),
      ],
    );
  }
}
