import 'package:flutter/material.dart';

class ApprovalsPage extends StatelessWidget {
  const ApprovalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Approvals'),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: const Text(
                    '7',
                    style: TextStyle(color: Colors.white, fontSize: 8),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Yellow Informational Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9E7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFE082)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.orange),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '5 Pending Approvals',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Review and take action on submitted items',
                        style: TextStyle(color: Colors.blueGrey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // List of Approval Cards
          buildApprovalCard(
            type: 'Invoice',
            title: 'Invoice INV-2026-006',
            subtitle: 'Metro Station Construction - Phase 2',
            amount: '₹52,00,000',
            submittedBy: 'Rajesh Kumar',
            date: '5 Feb 2026',
            description: 'Monthly billing for civil work completion',
            onTap: () {},
          ),
          buildApprovalCard(
            type: 'Expense',
            title: 'Material Purchase - Steel',
            subtitle: 'Highway Bridge Expansion',
            amount: '₹8,50,000',
            submittedBy: 'Priya Sharma',
            date: '4 Feb 2026',
            description: 'Steel rods and beams for structural work',
            onTap: () {},
          ),
          buildApprovalCard(
            type: 'Vendor Payment',
            title: 'Vendor Payment - Heavy Equipment',
            subtitle: 'Commercial Complex - Tower A',
            amount: '₹3,20,00,000',
            submittedBy: 'Amit Patel',
            date: '5 Feb 2026',
            description: 'Crane rental for 15 days',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

//Function to build each approval card

Widget buildApprovalCard({
  required String type, // 'Invoice', 'Expense', or 'Vendor Payment'
  required String title,
  required String subtitle,
  required String amount,
  required String submittedBy,
  required String date,
  required String description,
  required VoidCallback onTap,
}) {
  // Define styles based on type
  IconData icon;
  Color themeColor;

  if (type == 'Invoice') {
    icon = Icons.description;
    themeColor = Colors.blue;
  } else if (type == 'Expense') {
    icon = Icons.payments;
    themeColor = Colors.green;
  } else {
    icon = Icons.account_balance_wallet;
    themeColor = Colors.purple;
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: themeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: themeColor, size: 24),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: themeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    type,
                    style: TextStyle(
                      color: themeColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoColumn('Amount', amount, isBold: true),
                _buildInfoColumn(
                  'Submitted by',
                  submittedBy,
                  isRightAligned: true,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_buildInfoColumn('Date', date)],
            ),
            const Divider(height: 24),
            Text(
              description,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildInfoColumn(
  String label,
  String value, {
  bool isBold = false,
  bool isRightAligned = false,
}) {
  return Column(
    crossAxisAlignment:
        isRightAligned ? CrossAxisAlignment.end : CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      const SizedBox(height: 4),
      Text(
        value,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          fontSize: isBold ? 15 : 13,
        ),
      ),
    ],
  );
}
