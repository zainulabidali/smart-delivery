import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_delivery_app/roles/admin/admin_home.dart';
import 'package:smart_delivery_app/roles/agent/agent_home.dart';
import 'package:smart_delivery_app/roles/customer/customer_home.dart';
import 'auth/login_page.dart';
import 'auth/signup_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Delivery',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection("users")
                .doc(snapshot.data!.uid)
                .get(),
            builder: (context, snap) {
              if (!snap.hasData) return const CircularProgressIndicator();
              final role = snap.data!["role"];
              if (role == "customer") return const CustomerHome();
              if (role == "agent") return const AgentHome();
              if (role == "admin") return const AdminHome();
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
