class TransactionModel {
  final int nominal;
  final String? description;
  final DateTime date;
  final String typeTransaction;
  final String kategoriTransaction;
  final int? id;

  TransactionModel({
    required this.nominal,
    this.description,
    required this.date,
    required this.typeTransaction,
    required this.kategoriTransaction,
    this.id,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        id: json['id'],
        nominal: json['nominal'],
        description: json['description'],
        date: DateTime.parse(json['date']),
        typeTransaction: json['typeTransaction'],
        kategoriTransaction: json['kategoriTransaction'],
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nominal': nominal,
    'description': description,
    'date': date.toIso8601String(),
    'typeTransaction': typeTransaction,
    'kategoriTransaction': kategoriTransaction,
  };
}
