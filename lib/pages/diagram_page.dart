// =======================
// File: pages/diagram_page.dart
// =======================
import 'package:bilionare_budget/controller/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';

class DiagramPage extends StatefulWidget {
  @override
  _DiagramPageState createState() => _DiagramPageState();
}

class _DiagramPageState extends State<DiagramPage> {
  final TransactionController controller = Get.find();
  String selectedFilter = 'Hari';

  List<TransactionModel> getFilteredTransactions() {
    DateTime now = DateTime.now();
    DateTime start;
    if (selectedFilter == 'Hari') {
      start = DateTime(now.year, now.month, now.day);
    } else if (selectedFilter == 'Minggu') {
      start = now.subtract(Duration(days: now.weekday - 1));
    } else {
      start = DateTime(now.year, now.month);
    }
    return controller.filterByDate(start, now);
  }

  Map<String, double> calculateTotalByType(List<TransactionModel> list) {
    double income = 0;
    double expense = 0;
    for (var e in list) {
      if (e.typeTransaction == 'Income') {
        income += e.nominal.toDouble();
      } else {
        expense += e.nominal.toDouble();
      }
    }
    return {'Income': income, 'Expense': expense};
  }

  List<PieChartSectionData> getPieChartSections(Map<String, double> data) {
    return [
      PieChartSectionData(
        value: data['Income'],
        color: Colors.green,
        title: 'Income',
        radius: 50,
      ),
      PieChartSectionData(
        value: data['Expense'],
        color: Colors.red,
        title: 'Expense',
        radius: 50,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final filtered = getFilteredTransactions();
    final chartData = calculateTotalByType(filtered);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Diagram', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1.3,
              child: PieChart(
                PieChartData(
                  sections: getPieChartSections(chartData),
                  centerSpaceRadius: 40,
                  sectionsSpace: 4,
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: DropdownButton<String>(
                value: selectedFilter,
                dropdownColor: Colors.grey[900],
                style: TextStyle(color: Colors.white),
                items: ['Hari', 'Minggu', 'Bulan']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => selectedFilter = val!),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final item = filtered[index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFFD7D7D7),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink.withOpacity(0.3),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.kategoriTransaction,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                DateFormat('dd MM yyyy').format(item.date),
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          controller.formatCurrency(item.nominal),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: item.typeTransaction == 'Income'
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
