import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        final isAdmin = snapshot.data!['role'] == 'admin';
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                if (isAdmin) ...[
                  Text('Doanh thu tháng: 10,000,000', style: TextStyle(fontSize: 18)),
                  Text('Số khách: 50', style: TextStyle(fontSize: 18)),
                ],
                SizedBox(height: 16),
                Container(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      titlesData: FlTitlesData(show: true),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            FlSpot(0, 500000),
                            FlSpot(1, 600000),
                            FlSpot(2, 800000),
                            FlSpot(3, 700000),
                            FlSpot(4, 900000),
                          ],
                          isCurved: true,
                          color: Colors.teal,
                          dotData: FlDotData(show: false),
                        ),
                      ],
                    ),
                  ),
                ),
                if (isAdmin)
                  DropdownButton<String>(
                    value: 'Tháng 5',
                    onChanged: (value) {},
                    items: ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5'].map((String value) {
                      return DropdownMenuItem<String>(value: value, child: Text(value));
                    }).toList(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}