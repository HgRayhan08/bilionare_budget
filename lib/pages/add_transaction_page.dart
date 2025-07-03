// =======================
// File: pages/add_transaction_page.dart
// =======================
import 'package:bilionare_budget/controller/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/transaction_model.dart';

class AddTransactionPage extends StatefulWidget {
  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _nominalController = TextEditingController();
  final _descriptionController = TextEditingController();
  final controller = Get.find<TransactionController>();

  String _selectedType = 'Expense';
  String _selectedCategory = 'Makan';
  DateTime _selectedDate = DateTime.now();

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        final trx = TransactionModel(
          nominal: int.parse(_nominalController.text),
          description: _descriptionController.text,
          date: _selectedDate,
          typeTransaction: _selectedType,
          kategoriTransaction: _selectedCategory,
        );
        await controller.addTransaction(trx);
        Get.back();
        Get.snackbar(
          'Sukses',
          'Transaksi berhasil ditambahkan',
          backgroundColor: Colors.green.shade100,
        );
      } catch (e) {
        Get.snackbar(
          'Gagal',
          'Terjadi kesalahan',
          backgroundColor: Colors.red.shade100,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Transaksi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 10),
                    Text('${_selectedDate.toLocal()}'.split(' ')[0]),
                    Spacer(),
                    TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null)
                          setState(() => _selectedDate = picked);
                      },
                      child: Text('Pilih'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nominalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Nominal'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Wajib diisi' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Deskripsi (opsional)'),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: InputDecoration(labelText: 'Tipe Transaksi'),
                items: ['Income', 'Expense']
                    .map(
                      (val) => DropdownMenuItem(value: val, child: Text(val)),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _selectedType = val!),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(labelText: 'Kategori'),
                items: ['Makan', 'Jalan-jalan', 'Belanja', 'Gaji', 'Lainnya']
                    .map(
                      (val) => DropdownMenuItem(value: val, child: Text(val)),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _selectedCategory = val!),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Simpan'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(45),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
