import 'package:flutter/material.dart';

class MekanikDashboard extends StatelessWidget {
  const MekanikDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Mekanik')),
      body: const Center(child: Text('Selamat datang di Dashboard Mekanik')),
    );
  }
}
