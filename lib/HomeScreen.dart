import 'package:flutter/material.dart';
import 'package:app_usage/app_usage.dart';
import 'package:intl/intl.dart';

void main() => runApp(HomeScreen());

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, int> _usageMap = {};

  @override
  void initState() {
    super.initState();
  }

void getUsageStats() async {
  try {
    // get usage stats for the past 7 days
    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(Duration(days: 6));

    // get app usage for each day and store it in a map
    for (int i = 0; i < 7; i++) {
      DateTime day = startDate.add(Duration(days: i));
      List<AppUsageInfo> infoList =
          await AppUsage().getAppUsage(day, day.add(Duration(days: 1)));

      int totalUsage = 0;
      for (var info in infoList) {
        if (info.packageName == "com.example.testappno") {
          totalUsage += info.usage.inMinutes;
        }
      }

      // use DateFormat.EEEE to get the full name of the weekday
      _usageMap[DateFormat.EEEE().format(day)] = totalUsage;
    }

    setState(() {});
  } on AppUsageException catch (exception) {
    print(exception);
  }
}
String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitHours = twoDigits(duration.inHours);
  return "$twoDigitHours Hour $twoDigitMinutes minute";
}

 @override
Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('App Usage Example'),
        backgroundColor: Colors.green,
      ),
      body: _usageMap.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    "Usage for com.example.testappno",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                ..._usageMap.entries.map((entry) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        " ${entry.key}:             ${formatDuration(Duration(minutes: entry.value))}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ))
              ],
            )
          : Center(
              child: Text("Press the button to get usage stats"),
            ),
      floatingActionButton: FloatingActionButton(
          onPressed: getUsageStats, child: Icon(Icons.file_download)),
    ),
  );
}


}