// =======================
// File: pages/home_page.dart
// =======================
import 'package:bilionare_budget/controller/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_transaction_page.dart';

class HomePage extends StatelessWidget {
  final TransactionController controller = Get.put(TransactionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Beranda')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Total: ${controller.formatCurrency(controller.total)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Transaksi Terbaru',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Obx(() {
                final items = controller.getRecentTransactions(5);
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Dismissible(
                      key: Key(item.id.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        color: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) =>
                          controller.removeTransaction(item.id!),
                      child: ListTile(
                        title: Text(item.description ?? '-'),
                        subtitle: Text(
                          '${item.kategoriTransaction} - ${item.date.toLocal()}',
                        ),
                        trailing: Text(controller.formatCurrency(item.nominal)),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddTransactionPage()),
        child: Icon(Icons.add),
      ),
    );
  }
}
