import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AgentHome extends StatelessWidget {
  const AgentHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delivery Agent Dashboard"),
        actions: [
          IconButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: const Icon(Icons.logout))
        ],
      ),
      body: const Center(child: Text("Welcome Delivery Agent")),
    );
  }
}
