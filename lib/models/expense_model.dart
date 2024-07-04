import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });

  factory Expense.fromDocument(DocumentSnapshot doc) {
    return Expense(
      id: doc.id,
      title: doc['title'],
      amount: doc['amount'],
      date: (doc['date'] as Timestamp).toDate(),
      category: doc['category'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'date': date,
      'category': category,
    };
  }
}
