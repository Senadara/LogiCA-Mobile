import 'package:flutter/material.dart';

class MekanikDashboard extends StatelessWidget {
  final String token;
  const MekanikDashboard({required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Mekanik')),
      body: Center(child: Text('Token: $token')),
    );
  }
}
