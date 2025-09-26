import 'package:flutter/material.dart';

class OrderSummary extends StatelessWidget {
  final String orderId;
  final Map order;
  const OrderSummary({super.key, required this.orderId, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order Summary")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order ID: $orderId"),
            Text("Product: ${order["product"]["name"]}"),
            Text("Price: ₹${order["product"]["price"]}"),
            Text("Address: ${order["address"]}"),
            Text("Contact: ${order["contact"]}"),
            Text("Status: ${order["status"]}"),
            const SizedBox(height: 20),
            const Text("Estimated Delivery: 30 mins"),
          ],
        ),
      ),
    );
  }
}
