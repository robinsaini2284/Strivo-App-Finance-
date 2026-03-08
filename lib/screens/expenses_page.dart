import 'package:flutter/material.dart';
import 'add_expense_page.dart'; // Ensure this matches your file path

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  String selectedCategory = 'All';
  final List<String> categories = [
    'All',
    'Material',
    'Labour',
    'Machinery',
    'Transport',
  ];

  // 1. DATA SOURCE
  final List<Map<String, dynamic>> allExpenses = [
    {
      'company': 'Steel Suppliers Co.',
      'type': 'Material',
      'status': 'Approved',
      'amount': '₹8,50,000',
      'tax': '₹1,53,000',
      'date': '4 Feb 2026',
      'bill': true,
    },
    {
      'company': 'Construction Workers Union',
      'type': 'Labour',
      'status': 'Approved',
      'amount': '₹4,50,000',
      'tax': '₹0',
      'date': '3 Feb 2026',
      'bill': true,
    },
  ];

  // --- NAVIGATION & STATE SYNC ---
  void _navigateToAddExpense() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => AddExpensePage(
              onSave: (Map<String, dynamic> newExpense) {
                setState(() {
                  // Add the new record to the top of the list
                  allExpenses.insert(0, newExpense);
                });
              },
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter logic based on ChoiceChip selection
    final filtered =
        selectedCategory == 'All'
            ? allExpenses
            : allExpenses.where((e) => e['type'] == selectedCategory).toList();

    return Scaffold(
      backgroundColor: Colors.white,

      // --- FLOATING ACTION BUTTON ---
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddExpense,
        backgroundColor: const Color(0xFF1C345C), // Navy theme
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),

      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search expenses...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),
          ),

          // Horizontal Category Filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children:
                  categories
                      .map(
                        (cat) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(cat),
                            selected: selectedCategory == cat,
                            onSelected:
                                (val) => setState(() => selectedCategory = cat),
                            selectedColor: const Color(0xFF1C345C),
                            labelStyle: TextStyle(
                              color:
                                  selectedCategory == cat
                                      ? Colors.white
                                      : Colors.black,
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),

          // Expense List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final e = filtered[index];
                return buildExpenseCard(
                  company: e['company'],
                  type: e['type'],
                  status: e['status'],
                  amount: e['amount'],
                  tax: e['tax'],
                  date: e['date'],
                  hasBill: e['bill'],
                  onTap: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// --- REUSABLE COMPONENT: EXPENSE CARD ---
Widget buildExpenseCard({
  required String company,
  required String type,
  required String status,
  required String amount,
  required String tax,
  required String date,
  required bool hasBill,
  required VoidCallback onTap,
}) {
  // Status styling logic
  Color statusBg;
  Color statusText;
  if (status.toLowerCase() == 'approved') {
    statusBg = const Color(0xFFE8F5E9);
    statusText = const Color(0xFF2E7D32);
  } else if (status.toLowerCase() == 'rejected') {
    statusBg = const Color(0xFFFFEBEE);
    statusText = const Color(0xFFC62828);
  } else {
    statusBg = const Color(0xFFFFF8E1);
    statusText = const Color(0xFFF9A825);
  }

  return Card(
    margin: const EdgeInsets.only(bottom: 16),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Colors.grey.shade200),
    ),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.receipt_long,
                  color: Colors.blueGrey,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    type,
                    style: const TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusText,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                company,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _detailColumn('Amount', amount),
                _detailColumn('Tax', tax),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      hasBill ? Icons.check_circle : Icons.error_outline,
                      size: 14,
                      color: hasBill ? Colors.green : Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      hasBill ? 'Bill Attached' : 'No Bill',
                      style: TextStyle(
                        fontSize: 12,
                        color: hasBill ? Colors.green : Colors.grey,
                      ),
                    ),
                  ],
                ),
                Text(
                  date,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _detailColumn(String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      const SizedBox(height: 4),
      Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    ],
  );
}
