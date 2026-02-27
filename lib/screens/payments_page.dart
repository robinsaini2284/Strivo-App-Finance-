//Common function for payments page
import 'dart:ui';

import 'package:flutter/material.dart';

Widget buildPaymentCard({
  required String payNumber,
  required String linkedInvoice,
  required String paymentMode,
  required String date,
  required String amount,
  required String status,
  required VoidCallback onTap,
}) {
  // Define status colors
  Color statusBg =
      status.toLowerCase() == 'paid'
          ? Colors.green.shade50
          : Colors.orange.shade50;
  Color statusText =
      status.toLowerCase() == 'paid'
          ? Colors.green.shade700
          : Colors.orange.shade700;

  // Define Payment Mode Icons
  IconData modeIcon;
  switch (paymentMode.toLowerCase()) {
    case 'bank':
      modeIcon = Icons.account_balance_rounded;
      break;
    case 'upi':
      modeIcon = Icons.phonelink_ring_rounded;
      break;
    case 'cheque':
      modeIcon = Icons.edit_note_rounded;
      break;
    default:
      modeIcon = Icons.payments_outlined;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
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
            const SizedBox(height: 6),
            Text(
              'Linked to $linkedInvoice',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            ),

            const SizedBox(height: 16),

            // Payment Details Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Payment Mode',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            modeIcon,
                            size: 18,
                            color: const Color(0xFF1C345C),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            paymentMode,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Date',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        date,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Text(
              'Paid Amount',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 4),
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

//Function Calling

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
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
    {
      'id': 'PAY-2026-003',
      'status': 'Pending',
      'invoice': 'INV-2026-001',
      'mode': 'Cheque',
      'date': '12 Feb 2026',
      'amount': '₹45,00,000',
    },
  ];

  List<Map<String, String>> filteredPayments = [];

  @override
  void initState() {
    super.initState();
    filteredPayments = allPayments;
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
      body: Column(
        children: [
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
