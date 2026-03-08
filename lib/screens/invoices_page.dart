import 'package:flutter/material.dart';
import 'create_invoice_page.dart'; // Ensure this matches your filename

class InvoicesPage extends StatefulWidget {
  const InvoicesPage({super.key});

  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  // 1. MAIN DATA LIST
  final List<Map<String, String>> allInvoices = [
    {
      'id': 'INV-2026-001',
      'status': 'Sent',
      'company': 'Metro Rail Corporation',
      'project': 'Metro Station Construction - Phase 2',
      'amount': '4500000',
      'date': '20 Feb 2026',
    },
    {
      'id': 'INV-2026-002',
      'status': 'Paid',
      'company': 'Highway Authority',
      'project': 'Highway Bridge Expansion',
      'amount': '2800000',
      'date': '15 Feb 2026',
    },
    {
      'id': 'INV-2026-003',
      'status': 'Overdue',
      'company': 'Urban Developers Ltd',
      'project': 'Commercial Complex - Tower A',
      'amount': '3200000',
      'date': '30 Jan 2026',
    },
    {
      'id': 'INV-2026-004',
      'status': 'Draft',
      'company': 'Smart City Mission',
      'project': 'Smart City Infrastructure',
      'amount': '6500000',
      'date': '25 Feb 2026',
    },
  ];

  List<Map<String, String>> filteredInvoices = [];

  @override
  void initState() {
    super.initState();
    filteredInvoices = allInvoices;
  }

  // --- UNIQUE ID AND NAVIGATION LOGIC ---
  void _navigateToCreateInvoice() {
    // 2. CALCULATE INCREMENTING ID
    int nextNumber = allInvoices.length + 1;
    String nextInvoiceId = 'INV-2026-${nextNumber.toString().padLeft(3, '0')}';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => CreateInvoicePage(
              nextId: nextInvoiceId, // Pass unique ID to form
              onSave: (Map<String, String> newInvoice) {
                setState(() {
                  // 3. ADD NEW RECORD AT TOP
                  allInvoices.insert(0, newInvoice);
                  filteredInvoices = List.from(allInvoices);
                });
              },
            ),
      ),
    );
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

      // + Button from image_ab53bb.png
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateInvoice,
        backgroundColor: const Color(0xFF1C345C), // Navy theme
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),

      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                hintText: 'Search invoices...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),
          ),

          // Invoice List
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
                  amount: '₹${inv['amount']}',
                  dueDate: inv['date']!,
                  onTap: () => print("Opening ${inv['id']}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable Invoice Card Component
Widget buildInvoiceCard({
  required String invNumber,
  required String company,
  required String project,
  required String amount,
  required String dueDate,
  required String status,
  required VoidCallback onTap,
}) {
  Color statusBg =
      status.toLowerCase() == 'paid'
          ? Colors.green.shade50
          : Colors.orange.shade50;
  Color statusText =
      status.toLowerCase() == 'paid'
          ? Colors.green.shade700
          : Colors.orange.shade700;

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
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _cardDetailColumn('Amount', amount, isBold: true),
                _cardDetailColumn('Due Date', dueDate),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _cardDetailColumn(String label, String value, {bool isBold = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      const SizedBox(height: 4),
      Text(
        value,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          fontSize: isBold ? 16 : 14,
        ),
      ),
    ],
  );
}
