import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:inventory_platform/data/models/inventory_model.dart';

class StatusChart extends StatelessWidget {
  final List<InventoryModel> inventories;

  const StatusChart({super.key, required this.inventories});

  @override
  Widget build(BuildContext context) {
    final openedCount = _getOpenedInventoryCount();
    final closedCount = _getClosedInventoryCount();

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 1.0,
                  color: Colors.black38,
                  offset: Offset(1.0, 1.0),
                  spreadRadius: 0.5,
                ),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Situação dos Inventários (Últimos 30 dias)',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48.0),
          padding: const EdgeInsets.only(
              left: 10.0, top: 16.0, bottom: 16.0, right: 38.0),
          child: Center(child: _buildBarChart(openedCount, closedCount)),
        ),
      ],
    );
  }

  int _getOpenedInventoryCount() {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));

    return inventories.where((inventory) {
      return inventory.createdAt != null &&
          inventory.createdAt!.isAfter(thirtyDaysAgo);
    }).length;
  }

  int _getClosedInventoryCount() {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));

    return inventories.where((inventory) {
      return inventory.lastUpdatedAt != null &&
          inventory.lastUpdatedAt!.isAfter(thirtyDaysAgo) &&
          inventory.isActive == 0;
    }).length;
  }

  Widget _buildBarChart(int openedCount, int closedCount) {
    double maxY =
        [openedCount, closedCount].reduce((a, b) => a > b ? a : b).toDouble() +
            1;

    return SizedBox(
      height: 200.0,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return _getChartTitle(value);
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: [
            _buildBarGroupData(0, openedCount, Colors.blue),
            _buildBarGroupData(1, closedCount, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _getChartTitle(double value) {
    switch (value.toInt()) {
      case 0:
        return const Text('Abertos', style: TextStyle(fontSize: 12));
      case 1:
        return const Text('Fechados', style: TextStyle(fontSize: 12));
      default:
        return const Text('');
    }
  }

  BarChartGroupData _buildBarGroupData(int x, int count, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(toY: count.toDouble(), color: color),
      ],
    );
  }
}
