import 'package:flutter/material.dart';

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
    {
      'company': 'Heavy Equipment Rentals',
      'type': 'Machinery',
      'status': 'Pending',
      'amount': '₹3,20,000',
      'tax': '₹57,600',
      'date': '5 Feb 2026',
      'bill': true,
    },
    {
      'company': 'Logistics Solutions Ltd',
      'type': 'Transport',
      'status': 'Approved',
      'amount': '₹1,25,000',
      'tax': '₹22,500',
      'date': '2 Feb 2026',
      'bill': false,
    },
    {
      'company': 'Skilled Workforce Agency',
      'type': 'Labour',
      'status': 'Rejected',
      'amount': '₹2,80,000',
      'tax': '₹0',
      'date': '30 Jan 2026',
      'bill': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered =
        selectedCategory == 'All'
            ? allExpenses
            : allExpenses.where((e) => e['type'] == selectedCategory).toList();

    return Scaffold(
      backgroundColor: Colors.white,
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

//Fuction to

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
  // Define status colors
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

  // Define Category Icons
  Widget categoryIcon;
  switch (type.toLowerCase()) {
    case 'material':
      categoryIcon = const Icon(
        Icons.grid_view_rounded,
        color: Colors.deepOrangeAccent,
      );
      break;
    case 'labour':
      categoryIcon = const Icon(Icons.person, color: Colors.orange);
      break;
    case 'machinery':
      categoryIcon = const Icon(Icons.agriculture_rounded, color: Colors.green);
      break;
    case 'transport':
      categoryIcon = const Icon(Icons.local_shipping, color: Colors.blueGrey);
      break;
    default:
      categoryIcon = const Icon(Icons.receipt);
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
                categoryIcon,
                const SizedBox(width: 12),
                // Category Label
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
                // Status Label
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
            const SizedBox(height: 8),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Amount',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      amount,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tax',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tax,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Bill Status Button
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        hasBill
                            ? const Color(0xFFE8F5E9)
                            : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        hasBill ? Icons.upload_file : Icons.block,
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
