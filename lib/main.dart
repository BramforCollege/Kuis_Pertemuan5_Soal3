import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Kontak',
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      home: ContactListScreen(onToggleTheme: toggleTheme),
    );
  }
}

class ContactListScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const ContactListScreen({super.key, required this.onToggleTheme});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  // Data dummy kontak
  final List<Contact> contacts = [
    Contact(
      name: "Rendy",
      phone: "+628123456789",
      status: ContactStatus.online,
    ),
    Contact(
      name: "Zidan",
      phone: "+628219876543",
      status: ContactStatus.offline,
    ),
    Contact(
      name: "Windah Batubara",
      phone: "+628571234567",
      status: ContactStatus.away,
    ),
    Contact(
      name: "Ilham",
      phone: "+628135555888",
      status: ContactStatus.online,
    ),
    Contact(
      name: "Kipli Sedunia",
      phone: "+628789999111",
      status: ContactStatus.offline,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Kontak'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.orange,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                contact.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    contact.phone,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey[400] : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: getStatusColor(contact.status),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        getStatusText(contact.status),
                        style: TextStyle(
                          fontSize: 12,
                          color: getStatusTextColor(contact.status, isDark),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.call, color: Colors.blue),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Memanggil'),
                        content: Text('Memanggil ${contact.name}...'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Color getStatusColor(ContactStatus status) {
    switch (status) {
      case ContactStatus.online:
        return Colors.green;
      case ContactStatus.offline:
        return Colors.red;
      case ContactStatus.away:
        return Colors.orange;
    }
  }

  String getStatusText(ContactStatus status) {
    switch (status) {
      case ContactStatus.online:
        return 'Online';
      case ContactStatus.offline:
        return 'Offline';
      case ContactStatus.away:
        return 'Away';
    }
  }

  Color getStatusTextColor(ContactStatus status, bool isDark) {
    if (isDark) {
      // Warna untuk dark mode - lebih terang dan mudah dibaca
      switch (status) {
        case ContactStatus.online:
          return Colors.green[300]!;
        case ContactStatus.offline:
          return Colors.red[300]!;
        case ContactStatus.away:
          return Colors.orange[300]!;
      }
    } else {
      // Warna untuk light mode - lebih gelap
      switch (status) {
        case ContactStatus.online:
          return Colors.green[700]!;
        case ContactStatus.offline:
          return Colors.red[700]!;
        case ContactStatus.away:
          return Colors.orange[700]!;
      }
    }
  }
}

enum ContactStatus { online, offline, away }

class Contact {
  final String name;
  final String phone;
  final ContactStatus status;

  Contact({required this.name, required this.phone, required this.status});
}
