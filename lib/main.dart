import 'package:flutter/material.dart';
import 'package:logica_mobile/supir_dashboard.dart';
import 'package:logica_mobile/mekanik_dashboard.dart';
import 'package:logica_mobile/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/SupirDashboard': (context) => const SupirDashboard(token: ''),
        '/MekanikDashboard': (context) => const MekanikDashboard(token: ''),
      },
    );
  }
}
