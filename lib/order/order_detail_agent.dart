import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class AgentOrderDetail extends StatefulWidget {
  final String orderId;
  final Map order;

  const AgentOrderDetail({super.key, required this.orderId, required this.order});

  @override
  State<AgentOrderDetail> createState() => _AgentOrderDetailState();
}

class _AgentOrderDetailState extends State<AgentOrderDetail> {
  bool updatingLocation = false;

  Future<void> updateStatus(String newStatus) async {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.orderId)
        .update({"status": newStatus});
  }

  Future<void> updateLocation() async {
    setState(() => updatingLocation = true);

    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    await FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.orderId)
        .update({
      "agentLocation": {
        "lat": pos.latitude,
        "lng": pos.longitude,
      }
    });

    setState(() => updatingLocation = false);
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    return Scaffold(
      appBar: AppBar(title: const Text("Order Details")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Product: ${order["product"]["name"]}"),
            Text("Address: ${order["address"]}"),
            Text("Contact: ${order["contact"]}"),
            Text("Current Status: ${order["status"]}"),
            const SizedBox(height: 20),

            ElevatedButton(
                onPressed: () => updateStatus("In Transit"),
                child: const Text("Mark as In Transit")),
            ElevatedButton(
                onPressed: () => updateStatus("Delivered"),
                child: const Text("Mark as Delivered")),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateLocation,
              child: updatingLocation
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Update Location"),
            ),
          ],
        ),
      ),
    );
  }
}
