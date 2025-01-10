import 'package:flutter/material.dart';
import 'package:logica_mobile/login.dart';
//import 'package:mediacamera/desktop.dart';
import 'package:logica_mobile/pages_driver/form.dart';
import 'package:logica_mobile/pages_driver/formfoto.dart';
import 'package:logica_mobile/pages_driver/maintenance.dart';
//import 'package:logica_mobile/pages_driver/media.dart';
import 'package:logica_mobile/pages_driver/supir_dashboard.dart';
import 'package:logica_mobile/notification.dart';
import 'package:logica_mobile/pages_mechanic/dashboard_mekanik.dart';
import 'package:logica_mobile/pages_mechanic/ongoing_service.dart';
import 'package:logica_mobile/pages_mechanic/list_maintainance.dart';

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
        '/': (context) => const Login(),
        '/SupirDashboard': (context) =>
            SupirDashboard(notificationService: NotificationService()),
        '/Maintenance': (context) => MaintenanceRequestScreen(),
        '/MekanikDashboard': (context) => const MekanikDashboardPage(),
        '/Mekanik': (context) => const Maintenance(),
        '/ListMaintainance': (context) => ListMaintainance(),
        '/ong': (context) => const OngoingService(),
      },
    );
  }
}
