import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Downloadable Reports Section
            buildDownloadReportCard(
              title: 'Profit & Loss',
              subtitle: 'Project-wise financial overview',
              icon: Icons.trending_up,
              iconColor: Colors.green,
              onCardTap: () => print("P&L Card Tapped"),
              onPdfTap: () => print("P&L PDF Downloading..."),
              onExcelTap: () => print("P&L Excel Downloading..."),
            ),
            buildDownloadReportCard(
              title: 'Outstanding Payments',
              subtitle: 'Pending receivables report',
              icon: Icons.trending_down,
              iconColor: Colors.orange,
              onCardTap: () => print("Outstanding Card Tapped"),
              onPdfTap: () => print("Outstanding PDF Downloading..."),
              onExcelTap: () => print("Outstanding Excel Downloading..."),
            ),
            buildDownloadReportCard(
              title: 'Expense Summary',
              subtitle: 'Category-wise expense breakdown',
              icon: Icons.receipt_long,
              iconColor: Colors.blue,
              onCardTap: () => print("Expense Card Tapped"),
              onPdfTap: () => print("Expense PDF Downloading..."),
              onExcelTap: () => print("Expense Excel Downloading..."),
            ),

            const SizedBox(height: 24),

            // 2. Bar Chart Section
            const Text(
              'Profit & Loss by Project',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 200,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const titles = [
                            'Metro Ph 2',
                            'Highway',
                            'Tower A',
                            'Smart City',
                          ];
                          return Text(
                            titles[value.toInt()],
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    _makeGroupData(0, 120, 90, 30),
                    _makeGroupData(1, 80, 60, 20),
                    _makeGroupData(2, 100, 85, 15),
                    _makeGroupData(3, 180, 150, 30),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // 3. Expense Breakdown Section
            const Text(
              'Expense Breakdown',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // Pie Chart
                SizedBox(
                  height: 180,
                  width: 180,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 35,
                      sections: [
                        PieChartSectionData(
                          value: 45,
                          title: '45%',
                          color: Colors.blue,
                          radius: 45,
                          titleStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PieChartSectionData(
                          value: 30,
                          title: '30%',
                          color: Colors.orange,
                          radius: 45,
                          titleStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PieChartSectionData(
                          value: 15,
                          title: '15%',
                          color: Colors.green,
                          radius: 45,
                          titleStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PieChartSectionData(
                          value: 10,
                          title: '10%',
                          color: Colors.amber,
                          radius: 45,
                          titleStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                // Color Legend
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _chartLegend(Colors.blue, 'Material (45%)'),
                      _chartLegend(Colors.orange, 'Labour (30%)'),
                      _chartLegend(Colors.green, 'Machinery (15%)'),
                      _chartLegend(Colors.amber, 'Transport (10%)'),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
            _buildOutstandingSummary(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _chartLegend(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.blueGrey),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double rev, double exp, double prof) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(toY: rev, color: const Color(0xFF1C345C), width: 8),
        BarChartRodData(toY: exp, color: Colors.red.shade400, width: 8),
        BarChartRodData(toY: prof, color: Colors.green.shade400, width: 8),
      ],
    );
  }

  Widget _buildOutstandingSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Outstanding Payments Summary',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Divider(height: 24),
          _summaryRow('0-30 days', '₹15,00,000'),
          _summaryRow('31-60 days', '₹12,00,000'),
          _summaryRow('61-90 days', '₹6,00,000'),
          _summaryRow('90+ days', '₹2,00,000', isCritical: true),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Total Outstanding',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '₹35,00,000',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1C345C),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isCritical = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isCritical ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// Updated Interactive Functions
Widget buildDownloadReportCard({
  required String title,
  required String subtitle,
  required IconData icon,
  required Color iconColor,
  required VoidCallback onCardTap,
  required VoidCallback onPdfTap,
  required VoidCallback onExcelTap,
}) {
  return Card(
    margin: const EdgeInsets.only(bottom: 12),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Colors.grey.shade200),
    ),
    child: InkWell(
      onTap: onCardTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _reportActionBtn(Icons.picture_as_pdf, 'PDF', onPdfTap),
                      const SizedBox(width: 8),
                      _reportActionBtn(Icons.table_view, 'Excel', onExcelTap),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    ),
  );
}

Widget _reportActionBtn(IconData icon, String label, VoidCallback onTap) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: Colors.blueGrey),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
