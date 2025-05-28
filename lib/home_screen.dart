import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'store_tab.dart';
import 'stats_tab.dart';
import 'approval_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final isAdmin = snapshot.data!['role'] == 'admin';
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Nail Salon'),
              actions: [
                if (isAdmin)
                  IconButton(
                    icon: const Icon(Icons.person_add),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ApprovalScreen())),
                  ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                  },
                ),
              ],
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Cửa hàng'),
                  Tab(text: 'Thống kê'),
                ],
              ),
            ),
            body: const TabBarView(
              children: [
                StoreTab(),
                StatsTab(),
              ],
            ),
          ),
        );
      },
    );
  }
}