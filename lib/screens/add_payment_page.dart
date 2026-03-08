import 'package:flutter/material.dart';

class AddPaymentPage extends StatefulWidget {
  // Callback to return data and the list of actual invoices from InvoicesPage
  final Function(Map<String, String>) onSave;
  final List<Map<String, String>> existingInvoices;

  const AddPaymentPage({
    super.key,
    required this.onSave,
    required this.existingInvoices,
  });

  @override
  State<AddPaymentPage> createState() => _AddPaymentPageState();
}

class _AddPaymentPageState extends State<AddPaymentPage> {
  // State variables for form management
  String selectedInvoice = 'Choose an invoice';
  String selectedMode = 'Bank Transfer';

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _transactionController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add Payment'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. SELECT INVOICE (Filtered from InvoicesPage)
            const Text(
              "Select Invoice *",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedInvoice,
                  isExpanded: true,
                  hint: const Text("Choose an invoice"),
                  items: [
                    const DropdownMenuItem(
                      value: 'Choose an invoice',
                      child: Text('Choose an invoice'),
                    ),
                    // Dynamically building items from the passed invoice list
                    ...widget.existingInvoices.map((inv) {
                      return DropdownMenuItem<String>(
                        value: inv['id'],
                        child: Text("${inv['id']} - ${inv['company']}"),
                      );
                    }).toList(),
                  ],
                  onChanged: (val) => setState(() => selectedInvoice = val!),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 2. PAYMENT AMOUNT
            const Text(
              "Payment Amount *",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: '₹ ',
                hintText: '0.00',
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 3. PAYMENT MODE SELECTION
            const Text(
              "Payment Mode *",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                _buildModeCard('Bank Transfer', Icons.account_balance_rounded),
                _buildModeCard('UPI', Icons.qr_code_2_rounded),
                _buildModeCard('Cheque', Icons.edit_note_rounded),
                _buildModeCard('Cash', Icons.payments_rounded),
              ],
            ),
            const SizedBox(height: 20),

            // 4. TRANSACTION DETAILS
            const Text(
              "Transaction ID / Reference Number",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _transactionController,
              decoration: InputDecoration(
                hintText: 'Enter transaction/reference number',
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 5. REMARKS (OPTIONAL)
            const Text(
              "Remarks (Optional)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _remarksController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Add any additional notes...',
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // 6. RECORD PAYMENT BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1C345C), // Navy blue
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Basic validation before saving
                  if (selectedInvoice != 'Choose an invoice' &&
                      _amountController.text.isNotEmpty) {
                    final newPayment = {
                      'id': 'PAY-2026-00${DateTime.now().second}',
                      'status': 'Paid',
                      'invoice': selectedInvoice,
                      'mode': selectedMode,
                      'date': '08 Mar 2026',
                      'amount': '₹${_amountController.text}',
                    };

                    widget.onSave(newPayment);
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  "Record Payment",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Helper to build selectable payment mode cards
  Widget _buildModeCard(String label, IconData icon) {
    bool isSelected = selectedMode == label;
    return InkWell(
      onTap: () => setState(() => selectedMode = label),
      child: Container(
        decoration: BoxDecoration(
          color:
              isSelected
                  ? const Color(0xFF1C345C).withOpacity(0.05)
                  : Colors.transparent,
          border: Border.all(
            color: isSelected ? const Color(0xFF1C345C) : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? const Color(0xFF1C345C) : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? const Color(0xFF1C345C) : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
