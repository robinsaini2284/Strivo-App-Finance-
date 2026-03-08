import 'package:flutter/material.dart';

class AddExpensePage extends StatefulWidget {
  // Callback function to send the new record back to ExpensesPage
  final Function(Map<String, dynamic>) onSave;

  const AddExpensePage({super.key, required this.onSave});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  // --- FORM CONTROLLERS & STATE ---
  String selectedCategory = 'Material';
  String selectedProject = 'Choose a project';

  final TextEditingController _vendorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController(
    text: "0",
  );
  double taxPercent = 18.0;

  // --- CALCULATION LOGIC ---
  double get baseAmount => double.tryParse(_amountController.text) ?? 0;
  double get taxAmount => (baseAmount * taxPercent) / 100;
  double get totalAmount => baseAmount + taxAmount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add Expense'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. EXPENSE CATEGORY SELECTION
            const Text(
              "Expense Category *",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.5,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                _buildCategoryCard(
                  'Material',
                  Icons.grid_view_rounded,
                  Colors.deepOrangeAccent,
                ),
                _buildCategoryCard('Labour', Icons.person, Colors.orange),
                _buildCategoryCard(
                  'Machinery',
                  Icons.agriculture_rounded,
                  Colors.green,
                ),
                _buildCategoryCard(
                  'Transport',
                  Icons.local_shipping,
                  Colors.blueGrey,
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Text(
              "Expense Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 2. PROJECT SELECTION
            const Text(
              "Select Project *",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildProjectDropdown(),

            const SizedBox(height: 16),

            // 3. VENDOR & DESCRIPTION
            const Text(
              "Vendor Name *",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _vendorController,
              decoration: _inputDecoration("Enter vendor/supplier name"),
            ),
            const SizedBox(height: 16),
            const Text(
              "Description",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _descriptionController,
              decoration: _inputDecoration("Brief description of expense"),
            ),

            const SizedBox(height: 16),

            // 4. AMOUNT & TAX INPUTS
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Amount *",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        controller: _amountController,
                        onChanged: (val) => setState(() {}),
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration("₹ 0.00"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Tax %",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: _inputDecoration("18"),
                        onChanged:
                            (val) => setState(
                              () => taxPercent = double.tryParse(val) ?? 0,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 5. SUMMARY SECTION
            _buildSummaryWidget(),

            const SizedBox(height: 16),

            // 6. APPROVAL NOTE
            _buildApprovalNote(),

            const SizedBox(height: 24),

            // 7. SUBMIT BUTTON
            _buildSubmitButton(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildCategoryCard(String label, IconData icon, Color color) {
    bool isSelected = selectedCategory == label;
    return InkWell(
      onTap: () => setState(() => selectedCategory = label),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? const Color(0xFF1C345C) : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedProject,
          isExpanded: true,
          items:
              [
                    'Choose a project',
                    'Metro Station Phase 2',
                    'Highway Expansion',
                    'Tower A',
                  ]
                  .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                  .toList(),
          onChanged: (val) => setState(() => selectedProject = val!),
        ),
      ),
    );
  }

  Widget _buildSummaryWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF1C345C)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Summary",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const Divider(height: 24),
          _summaryRow("Base Amount", "₹${baseAmount.toStringAsFixed(2)}"),
          _summaryRow(
            "Tax ($taxPercent%)",
            "+ ₹${taxAmount.toStringAsFixed(2)}",
            color: Colors.green,
          ),
          const Divider(height: 24),
          _summaryRow(
            "Total Amount",
            "₹${totalAmount.toStringAsFixed(2)}",
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalNote() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Text(
        'Note: This expense will be submitted for approval and will appear in the pending approvals section.',
        style: TextStyle(color: Colors.blue.shade900, fontSize: 13),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1C345C),
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          if (_vendorController.text.isNotEmpty && baseAmount > 0) {
            final newExpense = {
              'company': _vendorController.text,
              'type': selectedCategory,
              'status': 'Pending', // New expenses start as pending
              'amount': '₹${totalAmount.toStringAsFixed(0)}',
              'tax': '₹${taxAmount.toStringAsFixed(0)}',
              'date': '08 Mar 2026',
              'bill': true, // Default for demo
            };

            widget.onSave(newExpense); // Pass record back to list
            Navigator.pop(context);
          }
        },
        child: const Text(
          "Submit Expense",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
    );
  }

  Widget _summaryRow(
    String label,
    String value, {
    bool isBold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color ?? Colors.black,
              fontSize: isBold ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
