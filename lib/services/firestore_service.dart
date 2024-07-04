import 'package:cloud_firestore/cloud_firestore.dart';
import './../models/expense_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addExpense(String userId, Expense expense) {
    return _db.collection('users').doc(userId).collection('expenses').add(expense.toMap());
  }

  Stream<List<Expense>> getExpenses(String userId) {
    return _db.collection('users').doc(userId).collection('expenses').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Expense.fromDocument(doc)).toList());
  }

  Future<void> deleteExpense(String userId, String id) {
    return _db.collection('users').doc(userId).collection('expenses').doc(id).delete();
  }
}
