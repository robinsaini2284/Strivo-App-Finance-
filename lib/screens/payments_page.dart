import 'package:flutter/material.dart';
import 'add_payment_page.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  // 1. DATA SOURCE
  // In a real app, 'allInvoices' would likely come from a shared provider or database
  final List<Map<String, String>> allInvoices = [
    {'id': 'INV-2026-001', 'company': 'Metro Rail Corporation'},
    {'id': 'INV-2026-002', 'company': 'Highway Authority'},
    {'id': 'INV-2026-003', 'company': 'Urban Developers Ltd'},
  ];

  final List<Map<String, String>> allPayments = [
    {
      'id': 'PAY-2026-001',
      'status': 'Paid',
      'invoice': 'INV-2026-002',
      'mode': 'Bank',
      'date': '10 Feb 2026',
      'amount': '₹28,00,000',
    },
    {
      'id': 'PAY-2026-002',
      'status': 'Paid',
      'invoice': 'INV-2025-045',
      'mode': 'UPI',
      'date': '8 Feb 2026',
      'amount': '₹15,00,000',
    },
  ];

  List<Map<String, String>> filteredPayments = [];

  @override
  void initState() {
    super.initState();
    filteredPayments = allPayments;
  }

  // --- NAVIGATION LOGIC ---
  void _navigateToAddPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => AddPaymentPage(
              // Pass the list of invoices so the dropdown works
              existingInvoices: allInvoices,
              onSave: (Map<String, String> newPayment) {
                setState(() {
                  allPayments.insert(0, newPayment);
                  filteredPayments = List.from(allPayments);
                });
              },
            ),
      ),
    );
  }

  void _filter(String query) {
    setState(() {
      filteredPayments =
          allPayments
              .where(
                (p) =>
                    p['id']!.toLowerCase().contains(query.toLowerCase()) ||
                    p['invoice']!.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddPayment,
        backgroundColor: const Color(0xFFE67E4D), // Orange theme
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Add Payment",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _filter,
              decoration: InputDecoration(
                hintText: 'Search payments...',
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

          // Payment List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredPayments.length,
              itemBuilder: (context, index) {
                final pay = filteredPayments[index];
                return buildPaymentCard(
                  payNumber: pay['id']!,
                  status: pay['status']!,
                  linkedInvoice: pay['invoice']!,
                  paymentMode: pay['mode']!,
                  date: pay['date']!,
                  amount: pay['amount']!,
                  onTap: () => print('Tapped ${pay['id']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// --- REUSABLE PAYMENT CARD COMPONENT ---
Widget buildPaymentCard({
  required String payNumber,
  required String linkedInvoice,
  required String paymentMode,
  required String date,
  required String amount,
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
                  payNumber,
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
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _detailColumn('Payment Mode', paymentMode)),
                Expanded(child: _detailColumn('Date', date)),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Paid Amount',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Text(
              amount,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.green,
              ),
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
      Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
    ],
  );
}
