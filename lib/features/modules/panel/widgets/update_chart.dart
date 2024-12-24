import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:inventory_platform/features/data/models/inventory_model.dart';

class UpdateChart extends StatefulWidget {
  final List<InventoryModel> inventories;

  const UpdateChart({super.key, required this.inventories});

  @override
  UpdateChartState createState() => UpdateChartState();
}

class UpdateChartState extends State<UpdateChart> {
  List<int> updatesPerDay = [];
  String? selectedDate;
  int? selectedUpdates;
  Offset? touchPosition;

  @override
  void initState() {
    super.initState();
    updatesPerDay = _getUpdatesPerDay();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            elevation: 3,
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Atualizações de Inventários (Últimos 30 dias)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 72.0),
          padding: const EdgeInsets.only(
              left: 8.0, top: 16.0, bottom: 16.0, right: 34.0),
          child: Center(
            child: SizedBox(
              height: 200.0,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        updatesPerDay.length,
                        (index) => FlSpot(
                            index.toDouble(), updatesPerDay[index].toDouble()),
                      ),
                      isCurved: false,
                      color: Colors.green,
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 5,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < updatesPerDay.length) {
                            return Text((30 - index).toString());
                          } else {
                            return const Text('');
                          }
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  lineTouchData: LineTouchData(
                    touchCallback:
                        (FlTouchEvent event, LineTouchResponse? response) {
                      if (response != null && response.lineBarSpots != null) {
                        final touchedSpot = response.lineBarSpots!.first;
                        final touchedIndex = touchedSpot.x.toInt();

                        final selectedDate = DateTime.now()
                            .subtract(Duration(days: 29 - touchedIndex));
                        final selectedUpdates = updatesPerDay[touchedIndex];

                        setState(() {
                          touchPosition = event.localPosition;
                          this.selectedDate =
                              selectedDate.toIso8601String().substring(0, 10);
                          this.selectedUpdates = selectedUpdates;
                        });
                      } else if (event is FlPanEndEvent ||
                          event is FlTapUpEvent) {
                        setState(() {
                          selectedDate = null;
                          selectedUpdates = null;
                          touchPosition = null;
                        });
                      }
                    },
                    handleBuiltInTouches: true,
                  ),
                ),
              ),
            ),
          ),
        ),
        // if (selectedDate != null &&
        //     selectedUpdates != null &&
        //     touchPosition != null)
        //   Positioned(
        //     left: touchPosition!.dx - 20,
        //     top: touchPosition!.dy + 40,
        //     child: Card(
        //       elevation: 4.0,
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(8.0),
        //       ),
        //       child: Padding(
        //         padding:
        //             const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        //         child: Text(
        //           'Data: $selectedDate\nAtualizações: $selectedUpdates',
        //           style: const TextStyle(
        //             fontSize: 14.0,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
      ],
    );
  }

  List<int> _getUpdatesPerDay() {
    final updates = <DateTime, int>{};

    for (var inventory in widget.inventories) {
      final date = inventory.lastUpdatedAt?.toIso8601String().substring(0, 10);
      if (date != null) {
        updates[DateTime.parse(date)] =
            (updates[DateTime.parse(date)] ?? 0) + 1;
      }
    }

    final sortedUpdates = updates.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return List.generate(30, (index) {
      final date = DateTime.now().subtract(Duration(days: index));
      final formattedDate = DateTime(date.year, date.month, date.day);

      return sortedUpdates
          .firstWhere(
            (entry) => entry.key.isAtSameMomentAs(formattedDate),
            orElse: () => MapEntry(formattedDate, 0),
          )
          .value;
    }).reversed.toList();
  }
}