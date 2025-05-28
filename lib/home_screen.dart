import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'store_tab.dart';
// import 'stats_tab.dart'; // Comment tạm thời
// import 'approval_screen.dart'; // Comment tạm thời

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
          length: 1, // Tạm thời chỉ có 1 tab
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Nail Salon'),
              actions: [
                if (isAdmin)
                  IconButton(
                    icon: const Icon(Icons.person_add),
                    onPressed: () {
                      // TODO: Thêm logic chuyển sang ApprovalScreen
                    },
                  ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () => FirebaseAuth.instance.signOut(),
                ),
              ],
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Cửa hàng'),
                  // Tab(text: 'Thống kê'), // Comment tạm thời
                ],
              ),
            ),
            body: const TabBarView(
              children: [
                StoreTab(),
                // StatsTab(), // Comment tạm thời
              ],
            ),
          ),
        );
      },
    );
  }
}