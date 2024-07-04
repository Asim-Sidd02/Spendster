import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import '../models/expense_model.dart';
import 'expense_entry_screen.dart';
import 'analytics_screen.dart';
import 'profile_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  bool _isAscending = true; // Sorting order flag
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm');
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildHomePage() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('User not signed in', style: TextStyle(color: Colors.white)));
    }

    final userId = user.uid;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search',
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query.toLowerCase();
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(
                  _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _isAscending = !_isAscending;
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<Expense>>(
            stream: Provider.of<FirestoreService>(context).getExpenses(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final expenses = snapshot.data ?? [];

              final filteredExpenses = expenses.where((expense) {
                final title = expense.title.toLowerCase();
                final category = expense.category.toLowerCase();
                final amount = expense.amount.toString();
                final date = DateFormat('yyyy-MM-dd').format(expense.date);
                final month = DateFormat('MMMM').format(expense.date).toLowerCase();

                return title.contains(_searchQuery) ||
                    category.contains(_searchQuery) ||
                    amount.contains(_searchQuery) ||
                    date.contains(_searchQuery) ||
                    month.contains(_searchQuery);
              }).toList();

              // Sort the filtered expenses based on the date
              filteredExpenses.sort((a, b) => _isAscending
                  ? a.date.compareTo(b.date)
                  : b.date.compareTo(a.date));

              return ListView.builder(
                itemCount: filteredExpenses.length,
                itemBuilder: (context, index) {
                  final expense = filteredExpenses[index];
                  return ListTile(
                    title: Text(
                      expense.title,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      '₹${expense.amount} - ${expense.category}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: () {
                        Provider.of<FirestoreService>(context, listen: false).deleteExpense(userId, expense.id);
                      },
                    ),
                    onTap: () {
                      _showExpenseDetails(expense);
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        backgroundColor: Colors.black,
      ),
      body: _selectedIndex == 0
          ? _buildHomePage()
          : _selectedIndex == 1
          ? const AnalyticsPage()
          : const ProfileScreen(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
        onTap: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ExpenseEntryScreen()),
          );
        },
      )
          : null, // FAB only on Home screen
    );
  }

  void _showExpenseDetails(Expense expense) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text('Expense Details', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Title: ${expense.title}', style: const TextStyle(color: Colors.white)),
              Text('Amount: ₹${expense.amount}', style: const TextStyle(color: Colors.white)),
              Text('Category: ${expense.category}', style: const TextStyle(color: Colors.white)),
              Text('Date: ${_dateFormat.format(expense.date)}', style: const TextStyle(color: Colors.white)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
