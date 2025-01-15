import 'package:flutter/material.dart';

class ReadyService extends StatelessWidget {
  const ReadyService({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LogiCa Mekanik',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            color: Colors.white, 
            fontSize: 20, 
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const MekanikDashboard(),
    );
  }
}

class MekanikDashboard extends StatelessWidget {
  const MekanikDashboard({super.key});

  void handleItemClick(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item clicked!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LogiCa Mekanik',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Selamat Datang,',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey, 
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Dayat Mekanik',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, 
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Bengkel Utama Sepanjang',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey, 
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Dikerjakan',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black, 
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: 3, 
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      handleItemClick(context); 
                    },
                    child: Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        title: const Text(
                          'Servis Rutin',
                          style: TextStyle(color: Colors.black), 
                        ),
                        subtitle: const Text(
                          '15 Januari 2024 - 10.00\nSupaidi',
                          style: TextStyle(color: Colors.grey), 
                        ),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green, 
                            foregroundColor: Colors.white, 
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            handleItemClick(context); 
                          },
                          child: const Text('Ready'),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}