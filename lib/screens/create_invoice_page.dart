import 'package:flutter/material.dart';

// 1. DATA MODEL FOR LINE ITEMS
class InvoiceItem {
  String description;
  double quantity;
  double rate;

  InvoiceItem({this.description = '', this.quantity = 0, this.rate = 0});

  double get total => quantity * rate;
}

class CreateInvoicePage extends StatefulWidget {
  final String nextId; // Unique ID passed from InvoicesPage
  final Function(Map<String, String>) onSave;

  const CreateInvoicePage({
    super.key,
    required this.nextId,
    required this.onSave,
  });

  @override
  State<CreateInvoicePage> createState() => _CreateInvoicePageState();
}

class _CreateInvoicePageState extends State<CreateInvoicePage> {
  // --- FORM STATE ---
  String selectedProject = 'Choose a project';
  List<InvoiceItem> lineItems = [InvoiceItem()]; // Starts with one empty item

  double gstPercent = 18.0;
  double tdsPercent = 2.0;

  // --- CALCULATIONS ---
  double get subtotal => lineItems.fold(0, (sum, item) => sum + item.total);
  double get gstAmount => (subtotal * gstPercent) / 100;
  double get tdsAmount => (subtotal * tdsPercent) / 100;
  double get netPayable => subtotal + gstAmount - tdsAmount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Invoice ${widget.nextId}'), // Displays unique ID in header
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
            // 2. PROJECT SELECTION
            _buildSectionLabel("Select Project *"),
            const SizedBox(height: 8),
            _buildProjectDropdown(),

            const SizedBox(height: 24),

            // 3. DYNAMIC LINE ITEMS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Line Items",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed:
                      () => setState(
                        () => lineItems.add(InvoiceItem()),
                      ), // Logic to add new item
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text("Add Item"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C345C),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...lineItems
                .asMap()
                .entries
                .map((entry) => _buildItemCard(entry.key, entry.value))
                .toList(),

            const SizedBox(height: 24),

            // 4. TAX DETAILS
            const Text(
              "Tax Details",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTaxInput(
                    "GST %",
                    (val) =>
                        setState(() => gstPercent = double.tryParse(val) ?? 0),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTaxInput(
                    "TDS %",
                    (val) =>
                        setState(() => tdsPercent = double.tryParse(val) ?? 0),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // 5. SUMMARY CARD
            _buildSummaryCard(),

            const SizedBox(height: 40),

            // 6. SAVE BUTTON
            _buildSaveButton(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
                    'Metro Station Construction - Phase 2',
                    'Highway Bridge Expansion',
                    'Commercial Complex - Tower A',
                  ]
                  .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                  .toList(),
          onChanged: (val) => setState(() => selectedProject = val!),
        ),
      ),
    );
  }

  Widget _buildItemCard(int index, InvoiceItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Item ${index + 1}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
                if (lineItems.length > 1)
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 20,
                    ),
                    onPressed: () => setState(() => lineItems.removeAt(index)),
                  ),
              ],
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: "Description",
                hintText: "Work Description",
              ),
              onChanged: (val) => item.description = val,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Quantity"),
                    onChanged:
                        (val) => setState(
                          () => item.quantity = double.tryParse(val) ?? 0,
                        ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Rate (₹)"),
                    onChanged:
                        (val) => setState(
                          () => item.rate = double.tryParse(val) ?? 0,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Total: ₹${item.total.toStringAsFixed(2)}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaxInput(String label, Function(String) onChanged) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1C345C), width: 1),
      ),
      child: Column(
        children: [
          _summaryRow("Subtotal", "₹${subtotal.toStringAsFixed(2)}"),
          _summaryRow(
            "GST ($gstPercent%)",
            "+ ₹${gstAmount.toStringAsFixed(2)}",
            color: Colors.green,
          ),
          _summaryRow(
            "TDS ($tdsPercent%)",
            "- ₹${tdsAmount.toStringAsFixed(2)}",
            color: Colors.red,
          ),
          const Divider(height: 24),
          _summaryRow(
            "Net Payable",
            "₹${netPayable.toStringAsFixed(2)}",
            isBold: true,
          ),
        ],
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
              fontSize: isBold ? 18 : 14,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
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
          if (selectedProject != 'Choose a project' && subtotal > 0) {
            widget.onSave({
              'id': widget.nextId, // Uses the unique incrementing ID
              'status': 'Draft',
              'company': 'Project Client',
              'project': selectedProject,
              'amount': netPayable.toStringAsFixed(0),
              'date': '08 Mar 2026',
            });
            Navigator.pop(context);
          }
        },
        child: const Text(
          "Save Invoice",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
