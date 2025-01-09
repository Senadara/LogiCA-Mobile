import 'package:flutter/material.dart';

class SupirDashboard extends StatelessWidget {
  const SupirDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Supir')),
      body: const Center(child: Text('Selamat datang di Dashboard Supir')),
    );
  }
}
