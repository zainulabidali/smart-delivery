import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AgentsMap extends StatelessWidget {
  const AgentsMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Agents Location Map")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .where("status", isEqualTo: "In Transit")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          final markers = <Marker>[];

          for (var doc in docs) {
            final data = doc.data() as Map<String, dynamic>;
            if (data["agentLocation"] != null) {
              markers.add(
                Marker(
                  point: LatLng(
                      data["agentLocation"]["lat"],
                      data["agentLocation"]["lng"]),
                  width: 50,
                  height: 50,
                  child: const Icon(Icons.delivery_dining,
                      color: Colors.blue, size: 40),
                ),
              );
            }
          }

          if (markers.isEmpty) {
            return const Center(child: Text("No agents active right now"));
          }

          return FlutterMap(
            options: MapOptions(
              initialCenter: markers.first.point,
              initialZoom: 12,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: "com.example.smartdelivery",
              ),
              MarkerLayer(markers: markers),
            ],
          );
        },
      ),
    );
  }
}
