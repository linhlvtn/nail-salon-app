import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class StatsTab extends StatelessWidget {
  const StatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('reports').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final reports = snapshot.data!.docs;

        double totalRevenue = 0;
        final serviceRevenue = {'Nail': 0.0, 'Mi': 0.0, 'Gội': 0.0, 'Xăm': 0.0};
        for (var report in reports) {
          try {
            final amount = double.parse(report['amount']);
            totalRevenue += amount;
            serviceRevenue[report['service']] = serviceRevenue[report['service']]! + amount;
          } catch (e) {
            print('Lỗi parse amount: $e');
          }
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text('Tổng doanh thu', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text('${totalRevenue.toStringAsFixed(0)} VNĐ', style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 16),
              Expanded(
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: serviceRevenue['Nail'],
                        color: Colors.teal,
                        title: 'Nail',
                        showTitle: true,
                      ),
                      PieChartSectionData(
                        value: serviceRevenue['Mi'],
                        color: Colors.red,
                        title: 'Mi',
                        showTitle: true,
                      ),
                      PieChartSectionData(
                        value: serviceRevenue['Gội'],
                        color: Colors.blue,
                        title: 'Gội',
                        showTitle: true,
                      ),
                      PieChartSectionData(
                        value: serviceRevenue['Xăm'],
                        color: Colors.yellow,
                        title: 'Xăm',
                        showTitle: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}