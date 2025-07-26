import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart

class AnalysisPage extends StatefulWidget {
  // We'll pass the habit data to the analysis page
  final List<Map<String, dynamic>> habits;

  const AnalysisPage({Key? key, required this.habits}) : super(key: key);

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  int totalTasks = 0;
  int completedTasks = 0;
  int pendingTasks = 0;

  @override
  void initState() {
    super.initState();
    _calculateTaskCounts();
  }

  // Recalculate counts if habits data changes (though for now, it's static)
  @override
  void didUpdateWidget(covariant AnalysisPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.habits != widget.habits) {
      _calculateTaskCounts();
    }
  }

  void _calculateTaskCounts() {
    totalTasks = widget.habits.length;
    completedTasks =
        widget.habits.where((habit) => habit['isCompleted'] == true).length;
    pendingTasks = totalTasks - completedTasks;
    setState(() {}); // Update UI with new counts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Analysis'),
        centerTitle: true,
        elevation: 4,
      ),
      body: totalTasks == 0
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.analytics_outlined,
                      size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 20),
                  const Text(
                    'No tasks to analyze yet!',
                    style: TextStyle(fontSize: 20, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Add some habits to see your progress.',
                    style: TextStyle(fontSize: 16, color: Colors.black45),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overall Progress',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  // Task Counts Summary
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildCountRow(
                              'Total Tasks:', totalTasks, Colors.blueAccent),
                          _buildCountRow('Completed Tasks:', completedTasks,
                              const Color.fromARGB(255, 157, 245, 62)),
                          _buildCountRow('Pending Tasks:', pendingTasks,
                              const Color(0xFFD2DE32)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Completed vs. Pending',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  // Pie Chart
                  SizedBox(
                    height: 250, // Fixed height for the chart
                    child: PieChart(
                      PieChartData(
                        sections: _buildPieChartSections(),
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        pieTouchData: PieTouchData(touchCallback:
                            (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              return;
                            }
                            // Optional: Add interaction feedback like highlighting touched section
                            // You can expand on this to show details on tap
                          });
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Legend for Pie Chart
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLegendItem(
                          const Color.fromARGB(255, 157, 245, 62), 'Completed'),
                      _buildLegendItem(const Color(0xFFD2DE32), 'Pending'),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  // Helper to build count rows
  Widget _buildCountRow(String title, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            count.toString(),
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Helper to build pie chart sections
  List<PieChartSectionData> _buildPieChartSections() {
    final double completedPercentage =
        totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0;
    final double pendingPercentage =
        totalTasks > 0 ? (pendingTasks / totalTasks) * 100 : 0;

    return [
      PieChartSectionData(
        color: const Color.fromARGB(255, 157, 245, 62), // Completed color
        value: completedTasks.toDouble(),
        title: '${completedPercentage.toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: completedTasks > 0
            ? _buildBadge(Icons.check_circle, Colors.white)
            : null,
        badgePositionPercentageOffset: 1.0,
      ),
      PieChartSectionData(
        color: const Color(0xFFD2DE32), // Pending color
        value: pendingTasks.toDouble(),
        title: '${pendingPercentage.toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        badgeWidget: pendingTasks > 0
            ? _buildBadge(Icons.hourglass_empty, Colors.black)
            : null,
        badgePositionPercentageOffset: 1.0,
      ),
    ];
  }

  // Helper for pie chart section badges
  Widget _buildBadge(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, size: 20, color: color),
    );
  }

  // Helper to build legend items
  Widget _buildLegendItem(Color color, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
          const SizedBox(width: 12),
          Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
