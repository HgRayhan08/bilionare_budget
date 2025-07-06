// =======================
// File: pages/history_page.dart
// =======================
import 'package:bilionare_budget/controller/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final TransactionController controller = Get.find();
  String selectedType = 'Income';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Riwayat Transaksi', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: Text('Income'),
                  selected: selectedType == 'Income',
                  selectedColor: Colors.green,
                  backgroundColor: Colors.grey.withOpacity(0.5),
                  labelStyle: TextStyle(
                    color: selectedType == 'Income'
                        ? Colors.white
                        : Colors.black,
                  ),
                  onSelected: (val) => setState(() => selectedType = 'Income'),
                ),
                SizedBox(width: 10),
                ChoiceChip(
                  label: Text('Expense'),
                  selected: selectedType == 'Expense',
                  selectedColor: Colors.green,
                  backgroundColor: Colors.grey.withOpacity(0.5),
                  labelStyle: TextStyle(
                    color: selectedType == 'Expense'
                        ? Colors.white
                        : Colors.black,
                  ),
                  onSelected: (val) => setState(() => selectedType = 'Expense'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              final filtered = controller.allTransactions
                  .where((e) => e.typeTransaction == selectedType)
                  .toList();
              return ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final item = filtered[index];
                  return Dismissible(
                    key: Key(item.id.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.red,
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) => controller.removeTransaction(item.id!),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
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
                              color: selectedType == 'Income'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
