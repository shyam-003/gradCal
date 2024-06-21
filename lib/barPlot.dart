import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class barGraph extends StatefulWidget {
  const barGraph({super.key});

  @override
  State<barGraph> createState() => _barGraphState();
}

class _barGraphState extends State<barGraph> {
  List<String> marksRanges = [];
  List<int> numberOfStudents = [2, 3, 4, 7, 8, 7, 4, 2, 2];
  List<Map<String, String>> gradeRanges = [
    {'grade': 'A+', 'range': '90-100'},
    {'grade': 'A', 'range': '80-89'},
    {'grade': 'A-', 'range': '70-79'},
    {'grade': 'B+', 'range': '60-69'},
    {'grade': 'B', 'range': '50-59'},
    {'grade': 'B-', 'range': '40-49'},
    {'grade': 'C', 'range': '30-39'},
    {'grade': 'D', 'range': '20-29'},
    {'grade': 'F', 'range': '0-19'},
  ];
  bool isPressed = false;
  Widget? barChart;

  void generateDataFromExcel() {
    marksRanges.clear();

    for (var gradeRange in gradeRanges) {
      int count = 0;
      var rangeValues = (gradeRange['range'] ?? '')
          .split('-')
          .map((e) => int.parse(e))
          .toList();

      marksRanges.add(gradeRange['range'] ?? '');
    }
    for (var i = 0; i < marksRanges.length; i++) {
      print(marksRanges[i]);
    }
  }

  void printnoStudents() {
    print('No. of students');
    for (int i = 0; i < numberOfStudents.length; i++) {
      print(numberOfStudents[i]);
    }
  }

  Widget _buildBarChart() {
    return SizedBox(
      width: 700,
      height: 300,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: numberOfStudents
              .reduce((value, element) => value > element ? value : element)
              .toDouble(),
          barGroups: List.generate(marksRanges.length, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  y: numberOfStudents[index].toDouble(),
                  colors: [Colors.blue],
                  width: 20,
                ),
              ],
            );
          }),
          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (value) => const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0),
              margin: 20,
              getTitles: (double value) {
                if (value.toInt() >= 0 && value.toInt() < marksRanges.length) {
                  return marksRanges[value.toInt()];
                }
                return '';
              },
            ),
            leftTitles: SideTitles(
                showTitles: true,
                getTextStyles: (value) => const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bar Plot Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: generateDataFromExcel,
              child: Text('print data range'),
            ),
            ElevatedButton(
              onPressed: printnoStudents,
              child: Text('students list'),
            ),
            SizedBox(height: 20.0),
            if (barChart != null) barChart!,
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  barChart = _buildBarChart();
                });
              },
              child: Text('Plot bar'),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
