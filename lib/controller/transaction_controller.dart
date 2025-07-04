
// =======================
// File: controllers/transaction_controller.dart
// =======================
import 'package:get/get.dart';
import '../models/transaction_model.dart';
import '../local_storage/local_storage.dart';
import 'package:intl/intl.dart';

class TransactionController extends GetxController {
  RxList<TransactionModel> allTransactions = <TransactionModel>[].obs;
  final storage = LocalStorage();

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    allTransactions.value = await storage.getTransactions();
  }

  Future<void> addTransaction(TransactionModel trx) async {
    await storage.createTransaction(trx);
    fetchTransactions();
  }

  Future<void> removeTransaction(int id) async {
    await storage.deleteTransaction(id);
    fetchTransactions();
  }

  int get totalIncome => allTransactions
      .where((e) => e.typeTransaction == 'Income')
      .fold(0, (sum, e) => sum + e.nominal);

  int get totalExpense => allTransactions
      .where((e) => e.typeTransaction == 'Expense')
      .fold(0, (sum, e) => sum + e.nominal);

  int get total => totalIncome - totalExpense;

  List<TransactionModel> getRecentTransactions(int count) {
    List<TransactionModel> sorted = [...allTransactions];
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(count).toList();
  }

  List<TransactionModel> filterByDate(DateTime start, DateTime end) =>
      allTransactions.where((e) => e.date.isAfter(start.subtract(Duration(days: 1))) && e.date.isBefore(end.add(Duration(days: 1)))).toList();

  String formatCurrency(int amount) => NumberFormat.currency(locale: 'id', symbol: 'Rp ').format(amount);
}
