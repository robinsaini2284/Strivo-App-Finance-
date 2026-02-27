import 'package:flutter/material.dart';

class InvoicesPage extends StatefulWidget {
  const InvoicesPage({super.key});

  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  // Sample data list
  final List<Map<String, String>> allInvoices = [
    {
      'id': 'INV-2026-001',
      'status': 'Sent',
      'company': 'Metro Rail Corporation',
      'project': 'Metro Station Construction - Phase 2',
      'amount': '₹45,00,000',
      'date': '20 Feb 2026',
    },
    {
      'id': 'INV-2026-002',
      'status': 'Paid',
      'company': 'Highway Authority',
      'project': 'Highway Bridge Expansion',
      'amount': '₹28,00,000',
      'date': '15 Feb 2026',
    },
    {
      'id': 'INV-2026-003',
      'status': 'Overdue',
      'company': 'Urban Developers Ltd',
      'project': 'Commercial Complex - Tower A',
      'amount': '₹32,00,000',
      'date': '30 Jan 2026',
    },
  ];

  // List to hold filtered results
  List<Map<String, String>> filteredInvoices = [];

  @override
  void initState() {
    super.initState();
    filteredInvoices = allInvoices;
  }

  // Search logic
  void _runFilter(String enteredKeyword) {
    List<Map<String, String>> results = [];
    if (enteredKeyword.isEmpty) {
      results = allInvoices;
    } else {
      results =
          allInvoices
              .where(
                (inv) =>
                    inv["id"]!.toLowerCase().contains(
                      enteredKeyword.toLowerCase(),
                    ) ||
                    inv["company"]!.toLowerCase().contains(
                      enteredKeyword.toLowerCase(),
                    ),
              )
              .toList();
    }

    setState(() {
      filteredInvoices = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // --- SEARCH BAR SECTION ---
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                hintText: 'Search invoices...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF1C345C)),
                ),
              ),
            ),
          ),

          // --- INVOICE LIST SECTION ---
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredInvoices.length,
              itemBuilder: (context, index) {
                final inv = filteredInvoices[index];
                return buildInvoiceCard(
                  invNumber: inv['id']!,
                  status: inv['status']!,
                  company: inv['company']!,
                  project: inv['project']!,
                  amount: inv['amount']!,
                  dueDate: inv['date']!,
                  onTap: () => print("Clicked ${inv['id']}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Function to build invoice card widget

Widget buildInvoiceCard({
  required String invNumber,
  required String company,
  required String project,
  required String amount,
  required String dueDate,
  required String status,
  required VoidCallback onTap, // Added this parameter
}) {
  Color statusBg;
  Color statusText;

  switch (status.toLowerCase()) {
    case 'paid':
      statusBg = Colors.green.shade50;
      statusText = Colors.green.shade700;
      break;
    case 'overdue':
      statusBg = Colors.red.shade50;
      statusText = Colors.red.shade700;
      break;
    case 'sent':
      statusBg = Colors.orange.shade50;
      statusText = Colors.orange.shade700;
      break;
    default:
      statusBg = Colors.grey.shade100;
      statusText = Colors.grey.shade700;
  }

  return Card(
    margin: const EdgeInsets.only(bottom: 16),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Colors.grey.shade200),
    ),
    child: InkWell(
      // Added InkWell for clickability
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  invNumber,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 10),
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
            Text(
              company,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              project,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            ),
            const Divider(height: 24),
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
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Due Date',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dueDate,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
