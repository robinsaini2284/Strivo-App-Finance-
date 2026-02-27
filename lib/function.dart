import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// --- 1. MONTHLY CASH FLOW CHART ---
Widget buildMonthlyCashFlowCard({
  required List<Map<String, dynamic>> chartData,
  double maxY = 100,
}) {
  return Card(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: Colors.grey.shade200),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Monthly Cash Flow',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D1E3D),
                ),
              ),
              Row(
                children: [
                  _legendItem('Inflow', Colors.green),
                  const SizedBox(width: 12),
                  _legendItem('Outflow', Colors.red),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceBetween,
                maxY: maxY,
                minY: 0,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    // FIXED: In newer fl_chart versions, use tooltipBgColor
                    tooltipBgColor: const Color(0xFF0D1E3D),
                    tooltipRoundedRadius: 8,
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      String type = rodIndex == 0 ? "Inflow" : "Outflow";
                      return BarTooltipItem(
                        '$type\n',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        children: [
                          TextSpan(
                            text: '₹${rod.toY.toInt()}L',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY / 4,
                  getDrawingHorizontalLine:
                      (value) =>
                          FlLine(color: Colors.grey.shade100, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35,
                      getTitlesWidget:
                          (value, meta) => Text(
                            '${value.toInt()}L',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index < chartData.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              chartData[index]['month'],
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                barGroups:
                    chartData.asMap().entries.map((entry) {
                      return BarChartGroupData(
                        x: entry.key,
                        barsSpace: 4,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value['inflow'].toDouble(),
                            color: Colors.green,
                            width: 12,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(2),
                            ),
                          ),
                          BarChartRodData(
                            toY: entry.value['outflow'].toDouble(),
                            color: Colors.red,
                            width: 12,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(2),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// --- 2. SUMMARY CARD (COST/REVENUE) ---
Widget buildSummaryCard({
  required String label,
  required String amount,
  required String percentText,
  required IconData icon,
  required Color iconColor,
  bool isTrendingUp = true,
}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D1E3D),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      isTrendingUp ? Icons.north_east : Icons.south_east,
                      size: 14,
                      color: isTrendingUp ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$percentText ',
                      style: TextStyle(
                        color: isTrendingUp ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'vs last month',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
        ],
      ),
    ),
  );
}

// --- 3. ALERT BANNER (CLICKABLE) ---
Widget buildAlertBanner({
  required String title,
  required String subtitle,
  required IconData icon,
  required VoidCallback onTap,
  Color bgColor = const Color(0xFFFFF9E7),
  Color borderColor = const Color(0xFFFFE082),
  Color iconBgColor = const Color(0xFFFFF0C2),
  Color iconColor = const Color(0xFFD97706),
}) {
  return Material(
    // Added Material to prevent yellow underlines
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D1E3D),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blueGrey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black26,
              size: 16,
            ),
          ],
        ),
      ),
    ),
  );
}

// --- HELPERS ---
Widget _legendItem(String label, Color color) {
  return Row(
    children: [
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
    ],
  );
}

//Quick Action Card
Widget buildQuickActionButton({
  required String label,
  required IconData icon,
  required Color color,
  required VoidCallback onTap, // This handles the click action
  bool hasBorder = false,
  Color textColor = Colors.white,
}) {
  return Expanded(
    child: Material(
      color: Colors.transparent, // Allows the Container's color to show
      child: InkWell(
        onTap: onTap, // The function called when clicked
        borderRadius: BorderRadius.circular(12),
        splashColor: textColor.withOpacity(0.1), // Subtle ripple color
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            border: hasBorder ? Border.all(color: Colors.grey.shade300) : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: textColor, size: 28),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

//Invoice Page Function
