import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'order_summary.dart';

class OrderPage extends StatefulWidget {
  final Map product;
  const OrderPage({super.key, required this.product});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final addressController = TextEditingController();
  final contactController = TextEditingController();

  Future<void> placeOrder() async {
    final user = FirebaseAuth.instance.currentUser!;
    final orderData = {
      "customerId": user.uid,
      "product": widget.product,
      "address": addressController.text.trim(),
      "contact": contactController.text.trim(),
      "status": "Pending",
      "timestamp": FieldValue.serverTimestamp(),
    };

    final docRef =
        await FirebaseFirestore.instance.collection("orders").add(orderData);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OrderSummary(orderId: docRef.id, order: orderData),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Place Order")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Ordering: ${widget.product["name"]} (₹${widget.product["price"]})"),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: "Delivery Address"),
            ),
            TextField(
              controller: contactController,
              decoration: const InputDecoration(labelText: "Contact Number"),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: placeOrder,
              child: const Text("Confirm Order"),
            )
          ],
        ),
      ),
    );
  }
}
