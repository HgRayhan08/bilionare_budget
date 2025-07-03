import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaction_model.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  factory LocalStorage() => _instance;
  LocalStorage._internal();

  Database? _database;

  Future<void> initDatabase() async {
    final dbPath = await getDatabasesPath();
    _database = await openDatabase(
      join(dbPath, 'transaction.db'),
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE transactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nominal INTEGER,
            description TEXT,
            date TEXT,
            typeTransaction TEXT,
            kategoriTransaction TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  Future<void> createTransaction(TransactionModel transaction) async {
    await _database!.insert('transactions', transaction.toJson());
  }

  Future<void> deleteTransaction(int id) async {
    await _database!.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<TransactionModel>> getTransactions() async {
    final List<Map<String, dynamic>> data = await _database!.query(
      'transactions',
    );
    return data.map((e) => TransactionModel.fromJson(e)).toList();
  }

  Future<List<TransactionModel>> getByType(String type) async {
    final List<Map<String, dynamic>> data = await _database!.query(
      'transactions',
      where: 'typeTransaction = ?',
      whereArgs: [type],
    );
    return data.map((e) => TransactionModel.fromJson(e)).toList();
  }

  Future<List<TransactionModel>> getByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final List<Map<String, dynamic>> data = await _database!.query(
      'transactions',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
    );
    return data.map((e) => TransactionModel.fromJson(e)).toList();
  }
}
