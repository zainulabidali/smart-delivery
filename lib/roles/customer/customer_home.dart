import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_delivery_app/order/order_page.dart';

class CustomerHome extends StatelessWidget {
  final Function toggleTheme; // Save toggleTheme as class member

  const CustomerHome({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    final products = [
      {"name": "Pizza", "price": 250},
      {"name": "Burger", "price": 150},
      {"name": "Sandwich", "price": 100},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Dashboard"),
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
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final item = products[index];
          return Card(
            child: ListTile(
              title: Text(item["name"].toString()),
              subtitle: Text("₹${item["price"]}"),
              trailing: ElevatedButton(
                child: const Text("Order"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderPage(product: item),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
