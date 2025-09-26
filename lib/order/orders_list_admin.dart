import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersListAdmin extends StatelessWidget {
  const OrdersListAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Orders")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("orders").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!.docs;
          int pending = 0, inTransit = 0, delivered = 0;

          for (var doc in orders) {
            final data = doc.data() as Map<String, dynamic>;
            if (data["status"] == "Pending") pending++;
            if (data["status"] == "In Transit") inTransit++;
            if (data["status"] == "Delivered") delivered++;
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Chip(label: Text("Pending: $pending")),
                    Chip(label: Text("In Transit: $inTransit")),
                    Chip(label: Text("Delivered: $delivered")),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index].data() as Map<String, dynamic>;
                    return Card(
                      child: ListTile(
                        title: Text(order["product"]["name"]),
                        subtitle: Text(
                            "Status: ${order["status"]} | Address: ${order["address"]}"),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
