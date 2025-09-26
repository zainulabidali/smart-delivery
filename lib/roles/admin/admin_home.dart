import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_delivery_app/order/orders_list_admin.dart';
import 'package:smart_delivery_app/roles/agent/agents_map.dart';

class AdminHome extends StatelessWidget {
  final Function toggleTheme; // save as class member

  const AdminHome({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => toggleTheme(), // now works
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OrdersListAdmin()),
                );
              },
              child: const Text("📦 View All Orders"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AgentsMap()),
                );
              },
              child: const Text("🗺 Track Agents on Map"),
            ),
          ],
        ),
      ),
    );
  }
}
