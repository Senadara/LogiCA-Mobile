import 'package:flutter/material.dart';

class SupirDashboard extends StatelessWidget {
  final String token;
  const SupirDashboard({required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Supir')),
      body: Center(child: Text('Token: $token')),
    );
  }
}
