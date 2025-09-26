
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_delivery_app/auth/login_page.dart';
import 'package:smart_delivery_app/roles/admin/admin_home.dart';
import 'package:smart_delivery_app/roles/agent/agent_home.dart';
import 'package:smart_delivery_app/roles/customer/customer_home.dart';

class AuthGate extends StatelessWidget {
  final Function toggleTheme;
  const AuthGate({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection("users")
                .doc(snapshot.data!.uid)
                .get(),
            builder: (context, snap) {
              if (!snap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snap.data!.exists) {
                return const Center(child: Text("User data not found"));
              }
              final role = snap.data!["role"];
              if (role == "customer") return CustomerHome(toggleTheme: toggleTheme);
              if (role == "agent") return AgentHome(toggleTheme: toggleTheme);
              if (role == "admin") return AdminHome(toggleTheme: toggleTheme);
              return const Center(child: Text("Role not found"));
            },
          );
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
