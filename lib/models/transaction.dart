class Transaction {
  final String id;
  final String title;
  final double amount;
  final String type;
  final String category;
  final String date;
  final String time;
  final String note;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    required this.time,
    required this.note,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'amount': amount,
    'type': type,
    'category': category,
    'date': date,
    'time': time,
    'note': note,
  };

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json['id'] as String,
    title: json['title'] as String,
    amount: (json['amount'] as num).toDouble(),
    type: json['type'] as String,
    category: json['category'] as String,
    date: json['date'] as String,
    time: json['time'] as String,
    note: json['note'] as String? ?? '',
  );
}
