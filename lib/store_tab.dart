import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'add_report_screen.dart';

class StoreTab extends StatelessWidget {
  const StoreTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final isAdmin = snapshot.data!['role'] == 'admin';
        return Scaffold(
          body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('reports').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
              return AnimationLimiter(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var report = snapshot.data!.docs[index];
                    bool isOwner = report['userId'] == user.uid;
                    return AnimationConfiguration.synchronized(
                      duration: const Duration(milliseconds: 375),
                      child: FadeInAnimation(
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: Card(
                            child: ListTile(
                              leading: report['image'] != null
                                  ? Image.network(report['image'], width: 50, height: 50, fit: BoxFit.cover)
                                  : const Icon(Icons.image, size: 50),
                              title: Text('${report['service']} - ${report['amount']}'),
                              subtitle: Text(report['date']),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isAdmin)
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        // TODO: Thêm logic sửa báo cáo
                                      },
                                    ),
                                  if (isAdmin || isOwner)
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () => FirebaseFirestore.instance
                                          .collection('reports')
                                          .doc(report.id)
                                          .delete(),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddReportScreen())),
            child: const Icon(Icons.add),
            backgroundColor: Colors.teal,
          ),
        );
      },
    );
  }
}