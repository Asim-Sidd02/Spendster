import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import '../models/expense_model.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  DateTime _selectedDate = DateTime.now();
  List<Expense> _weeklyExpenses = [];
  bool _isLoading = true;
  late String _userId;

  @override
  void initState() {
    super.initState();
    _fetchUserIdAndUpdateData();
  }

  Future<void> _fetchUserIdAndUpdateData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
      _updateData();
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user is signed in'))
      );
    }
  }

  Future<void> _updateData() async {
    setState(() {
      _isLoading = true;
    });

    final firestoreService = Provider.of<FirestoreService>(context, listen: false);
    final startOfWeek = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    try {
      final expenses = await firestoreService.getExpenses(_userId).first;

      setState(() {
        _weeklyExpenses = expenses.where((expense) {
          return expense.date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
              expense.date.isBefore(endOfWeek.add(const Duration(days: 1)));
        }).toList();
        _isLoading = false;
      });

    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch data: $error'))
      );
    }
  }

  void _onDateChanged(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
    _updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Column(
        children: [
          WeekSelector(
            selectedDate: _selectedDate,
            onDateChanged: _onDateChanged,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  groupsSpace: 12,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final startOfWeek = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 8.0,
                            child: Text(
                              DateFormat('EEE').format(startOfWeek.add(Duration(days: value.toInt()))),
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 50,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text('₹${value.toInt()}', style: const TextStyle(color: Colors.white)),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: _prepareChartData(),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBorder: const BorderSide(color: Colors.blueGrey, width: 1),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '₹${rod.toY.toInt()}',
                          const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
                ),
                swapAnimationDuration: const Duration(milliseconds: 250),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _prepareChartData() {
    final data = List.generate(7, (index) => 0.0);
    final startOfWeek = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day - (_selectedDate.weekday - 1)
    );

    for (var expense in _weeklyExpenses) {
      final expenseDate = DateTime(expense.date.year, expense.date.month, expense.date.day);
      final dayIndex = expenseDate.difference(startOfWeek).inDays;

      if (dayIndex >= 0 && dayIndex < 7) {
        data[dayIndex] += expense.amount;
      }
    }

    return List.generate(7, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data[index],
            gradient: const LinearGradient(colors: [Colors.blue, Colors.lightBlueAccent]),
          ),
        ],
      );
    });
  }
}

class WeekSelector extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const WeekSelector({super.key, required this.selectedDate, required this.onDateChanged});

  @override
  Widget build(BuildContext context) {
    final startOfWeek = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    final weekText = 'Week of ${DateFormat('MMM dd, yyyy').format(startOfWeek)}';

    return Container(
      color: Colors.blueGrey[800],
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              onDateChanged(selectedDate.subtract(const Duration(days: 7)));
            },
          ),
          Text(
            weekText,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.white),
            onPressed: () {
              onDateChanged(selectedDate.add(const Duration(days: 7)));
            },
          ),
        ],
      ),
    );
  }
}
