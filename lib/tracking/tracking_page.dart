import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TrackingPage extends StatelessWidget {
  final String orderId;
  const TrackingPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Track Delivery")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .doc(orderId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final order = snapshot.data!.data() as Map<String, dynamic>;
          final status = order["status"];
          final agentLoc = order["agentLocation"];

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Order Status: $status",
                    style:
                        const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: agentLoc == null
                    ? const Center(
                        child: Text("Agent has not started delivery yet"),
                      )
                    : FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(
                            agentLoc["lat"],
                            agentLoc["lng"],
                          ),
                          initialZoom: 14,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                            userAgentPackageName: "com.example.smartdelivery",
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: LatLng(agentLoc["lat"], agentLoc["lng"]),
                                width: 60,
                                height: 60,
                                child: const Icon(Icons.delivery_dining,
                                    color: Colors.red, size: 4),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
