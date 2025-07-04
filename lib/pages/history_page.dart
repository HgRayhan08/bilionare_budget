// =======================
// File: pages/history_page.dart
// =======================
import 'package:bilionare_budget/controller/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      appBar: AppBar(title: Text('Riwayat Transaksi')),
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
                  onSelected: (val) => setState(() => selectedType = 'Income'),
                ),
                SizedBox(width: 10),
                ChoiceChip(
                  label: Text('Expense'),
                  selected: selectedType == 'Expense',
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
                    child: ListTile(
                      title: Text(item.description ?? '-'),
                      subtitle: Text(
                        '${item.kategoriTransaction} - ${item.date.toLocal()}',
                      ),
                      trailing: Text(
                        controller.formatCurrency(item.nominal),
                        style: TextStyle(
                          color: selectedType == 'Income'
                              ? Colors.green
                              : Colors.red,
                        ),
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
