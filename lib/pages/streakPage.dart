import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // Removed: No longer needed

class StreakPage extends StatefulWidget {
  const StreakPage({Key? key}) : super(key: key);

  @override
  State<StreakPage> createState() => _StreakPageState();
}

class _StreakPageState extends State<StreakPage> {
  // Simulate streak data for the last 21 days.
  // In a real application, this data would be fetched from your habit tracking
  // database, where each day's overall habit completion status is recorded.
  // 'completed': all habits done
  // 'incomplete': some habits done, but not all
  // 'skipped': no habits attempted or all skipped for the day
  Map<DateTime, String> _simulatedStreakData = {};

  @override
  void initState() {
    super.initState();
    _generateSimulatedStreakData();
  }

  void _generateSimulatedStreakData() {
    final now = DateTime.now();
    for (int i = 0; i < 21; i++) { // Generate data for the last 21 days
      final date = DateTime(now.year, now.month, now.day).subtract(Duration(days: 20 - i));
      String status;
      if (i % 5 == 0) { // Example: every 5th day is incomplete
        status = 'incomplete';
      } else if (i % 7 == 0) { // Example: every 7th day is skipped
        status = 'skipped';
      } else { // Most days are completed
        status = 'completed';
      }
      _simulatedStreakData[date] = status;
    }
    // Ensure today's date is included and marked as incomplete if it's the last day
    _simulatedStreakData[DateTime(now.year, now.month, now.day)] = 'incomplete';
  }

  Color _getDayColor(DateTime date) {
    final status = _simulatedStreakData[DateTime(date.year, date.month, date.day)]; // Normalize date
    switch (status) {
      case 'completed':
        return const Color.fromARGB(255, 157, 245, 62); // Completed gradient start
      case 'incomplete':
        return const Color(0xFFD2DE32); // Incomplete gradient start
      case 'skipped':
        return Colors.grey[400]!; // Grey for skipped days
      default:
        return Colors.grey[200]!; // Default for future or unknown days
    }
  }

  // Removed _getDayTooltip function as it relied on DateFormat
  // String _getDayTooltip(DateTime date) {
  //   final status = _simulatedStreakData[DateTime(date.year, date.month, date.day)];
  //   final formattedDate = DateFormat('MMM d, yyyy').format(date);
  //   return '$formattedDate: ${status ?? 'No Data'}';
  // }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final List<DateTime> last21Days = List.generate(21, (index) {
      return DateTime(now.year, now.month, now.day).subtract(Duration(days: 20 - index));
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Streak'),
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last 3 Weeks Streak',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7, // 7 days a week
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: 21, // 3 weeks * 7 days
                itemBuilder: (context, index) {
                  final date = last21Days[index];
                  return
                      // Removed Tooltip widget as it relied on _getDayTooltip
                      // Tooltip(
                      //   message: _getDayTooltip(date),
                      //   child:
                      Container(
                        decoration: BoxDecoration(
                          color: _getDayColor(date),
                          borderRadius: BorderRadius.circular(4.0), // Small rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        // Removed the Text widget that displayed the day number
                        // child: Center(
                        //   child: Text(
                        //     date.day.toString(), // Display day number
                        //     style: TextStyle(
                        //       color: Colors.white,
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: 12,
                        //       shadows: [
                        //         Shadow(
                        //           blurRadius: 2.0,
                        //           color: Colors.black.withOpacity(0.3),
                        //           offset: const Offset(1, 1),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      );
                },
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Streak Legend:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _buildLegendItem(const Color.fromARGB(255, 157, 245, 62), 'Completed All Habits'),
            _buildLegendItem(const Color(0xFFD2DE32), 'Incomplete/Some Habits Done'),
            _buildLegendItem(Colors.grey[400]!, 'Skipped/No Habits'),
          ],
        ),
      ),
    );
  }

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
