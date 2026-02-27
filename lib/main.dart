import 'package:finance_billing/function.dart';
import 'package:flutter/material.dart';

// --- IMPORT YOUR SEPARATE FILES HERE ---
import 'package:finance_billing/screens/invoices_page.dart';
import 'package:finance_billing/screens/payments_page.dart';
import 'package:finance_billing/screens/expenses_page.dart';
import 'package:finance_billing/screens/reports_page.dart';
import 'package:finance_billing/screens/approvals_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1C345C)),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  // Handles switching tabs from both BottomBar and Quick Actions
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Updated list calling your separate screen classes
    final List<Widget> _pages = [
      DashboardContent(onActionTap: _onItemTapped), // Index 0
      const InvoicesPage(), // Index 1
      const PaymentsPage(), // Index 2
      const ExpensesPage(), // Index 3
      const ReportsPage(), // Index 4
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Dashboard'),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              // Navigating to Approvals from notification icon as an example
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ApprovalsPage()),
              );
            },
          ),
        ],
      ),
      // IndexedStack keeps the BottomBar visible and persists page state
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1C345C),
        unselectedItemColor: Colors.blueGrey.shade300,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            label: 'Invoices',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Payments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Reports',
          ),
        ],
      ),
    );
  }
}

// --- DASHBOARD CONTENT WIDGET ---
class DashboardContent extends StatelessWidget {
  final Function(int) onActionTap;

  const DashboardContent({super.key, required this.onActionTap});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> myData = [
      {'month': 'Jan', 'inflow': 70, 'outflow': 40},
      {'month': 'Feb', 'inflow': 50, 'outflow': 60},
      {'month': 'Mar', 'inflow': 85, 'outflow': 35},
      {'month': 'Apr', 'inflow': 40, 'outflow': 20},
      {'month': 'May', 'inflow': 95, 'outflow': 50},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSummaryCard(
            label: 'Total Project Cost',
            amount: '₹4,50,00,000',
            percentText: '12%',
            icon: Icons.attach_money,
            iconColor: const Color(0xFF1C345C),
          ),
          buildSummaryCard(
            label: 'Amount Billed',
            amount: '₹3,20,00,000',
            percentText: '8%',
            icon: Icons.description,
            iconColor: Colors.orange.shade400,
          ),
          buildSummaryCard(
            label: 'Amount Received',
            amount: '₹2,85,00,000',
            percentText: '15%',
            icon: Icons.check_circle_outline,
            iconColor: Colors.green.shade600,
          ),
          buildSummaryCard(
            label: 'Outstanding Amount',
            amount: '₹35,00,000',
            percentText: '5%',
            icon: Icons.priority_high,
            iconColor: Colors.red,
            isTrendingUp: false,
          ),
          const SizedBox(height: 20),
          buildMonthlyCashFlowCard(chartData: myData, maxY: 100),
          const SizedBox(height: 20),
          // Linked to ApprovalsPage
          buildAlertBanner(
            title: 'Pending Approvals',
            subtitle: '7 items need your attention',
            icon: Icons.priority_high_rounded,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ApprovalsPage()),
              );
            },
          ),
          const SizedBox(height: 25),
          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              buildQuickActionButton(
                label: 'Create Invoice',
                icon: Icons.description_outlined,
                color: const Color(0xFF1C345C),
                onTap: () => onActionTap(1), // Navigates to Invoices Tab
              ),
              const SizedBox(width: 12),
              buildQuickActionButton(
                label: 'Record Payment',
                icon: Icons.account_balance_wallet_outlined,
                color: const Color(0xFFE67E4D),
                onTap: () => onActionTap(2), // Navigates to Payments Tab
              ),
              const SizedBox(width: 12),
              buildQuickActionButton(
                label: 'Add Expense',
                icon: Icons.receipt_long_outlined,
                color: Colors.white,
                textColor: const Color(0xFF1C345C),
                hasBorder: true,
                onTap: () => onActionTap(3), // Navigates to Expenses Tab
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
