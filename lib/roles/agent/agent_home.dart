import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_delivery_app/order/order_detail_agent.dart';

class AgentHome extends StatelessWidget {
  final Function toggleTheme; // Save as class member

  const AgentHome({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Delivery Agent Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => toggleTheme(), // Works now
          ),
          IconButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .where("agentId", isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final orders = snapshot.data!.docs;
          if (orders.isEmpty) {
            return const Center(child: Text("No assigned orders"));
          }
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  title: Text(order["product"]["name"]),
                  subtitle: Text("Status: ${order["status"]}"),
                  trailing: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AgentOrderDetail(
                            orderId: orders[index].id,
                            order: order,
                          ),
                        ),
                      );
                    },
                    child: const Text("Details"),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
