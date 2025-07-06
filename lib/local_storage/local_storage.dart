import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction_model.dart';
import 'dart:convert';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  factory LocalStorage() => _instance;
  LocalStorage._internal();

  Database? _database;

  // Default kategori tetap
  List<String> _defaultCategories = [
    'gaji',
    'warisan',
    'jalan-jalan',
    'makan',
    'belanja',
    'investasi',
    'lain-lain',
  ];

  List<String> _categories = [];

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

    await _loadCategories(); // load kategori dari SharedPreferences
  }

  // Simpan urutan kategori ke SharedPreferences
  Future<void> _saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('categories', jsonEncode(_categories));
  }

  // Load urutan kategori dari SharedPreferences
  Future<void> _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final String? saved = prefs.getString('categories');

    if (saved != null) {
      List<dynamic> decoded = jsonDecode(saved);
      _categories = decoded.map((e) => e.toString()).toList();
    } else {
      _categories = List.from(_defaultCategories);
    }
  }

  // Ambil daftar kategori
  List<String> getCategories() {
    return List.from(_categories);
  }

  // Ubah urutan kategori
  Future<void> reorderCategories(List<String> newOrder) async {
    if (Set.from(newOrder).containsAll(_defaultCategories) &&
        newOrder.length == _defaultCategories.length) {
      _categories = List.from(newOrder);
      await _saveCategories();
    } else {
      throw Exception('Kategori tidak valid untuk diubah urutan.');
    }
  }

  // Tambah transaksi
  Future<void> createTransaction(TransactionModel transaction) async {
    await _database!.insert('transactions', transaction.toJson());
  }

  // Hapus transaksi berdasarkan ID
  Future<void> deleteTransaction(int id) async {
    await _database!.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  // Ambil semua transaksi
  Future<List<TransactionModel>> getTransactions() async {
    final List<Map<String, dynamic>> data = await _database!.query(
      'transactions',
    );
    return data.map((e) => TransactionModel.fromJson(e)).toList();
  }

  // Ambil transaksi berdasarkan tipe
  Future<List<TransactionModel>> getByType(String type) async {
    final List<Map<String, dynamic>> data = await _database!.query(
      'transactions',
      where: 'typeTransaction = ?',
      whereArgs: [type],
    );
    return data.map((e) => TransactionModel.fromJson(e)).toList();
  }

  // Ambil transaksi berdasarkan rentang tanggal
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
