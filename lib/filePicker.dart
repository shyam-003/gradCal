import 'dart:io' as io;

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gradtry4/barPlot.dart';
import 'package:gradtry4/getRange.dart';

class FilePickerScreen extends StatefulWidget {
  @override
  _FilePickerScreenState createState() => _FilePickerScreenState();
}

class _FilePickerScreenState extends State<FilePickerScreen> {
  String _filePath = 'No file selected';
  TextEditingController rangeAAController = TextEditingController();
  TextEditingController rangeA1Controller = TextEditingController();
  TextEditingController rangeA0Controller = TextEditingController();
  TextEditingController rangeB1Controller = TextEditingController();
  TextEditingController rangeB0Controller = TextEditingController();
  TextEditingController rangeCController = TextEditingController();
  TextEditingController rangeDController = TextEditingController();
  TextEditingController rangeEController = TextEditingController();
  TextEditingController rangeFController = TextEditingController();

  List<double> studentsMarks = [];

  List<List<dynamic>> excelData = [];

  List<int> numberOfStudents = [];
  List<String> marksRanges = [];
  List<Map<String, String>> gradeRanges = [
    {'grade': 'A+', 'range': '90-100'},
    {'grade': 'A', 'range': '80-89'},
    {'grade': 'A-', 'range': '70-79'},
    {'grade': 'B+', 'range': '60-69'},
    {'grade': 'B-', 'range': '50-59'},
    {'grade': 'C', 'range': '40-49'},
    {'grade': 'D', 'range': '30-39'},
    {'grade': 'E', 'range': '20-29'},
    {'grade': 'F', 'range': '0-19'},
  ];

  void addGradeRange(String section, String range) {
    setState(() {
      if (range.isNotEmpty) {
        bool found = false;
        for (int i = 0; i < gradeRanges.length; i++) {
          if (gradeRanges[i]['grade'] == section) {
            gradeRanges[i]['range'] = range;
            found = true;
            break;
          }
        }
        if (!found) {
          // gradeRanges.add({'grade': section, 'range': range});
          int insertIndex = 0;
          for (int i = 0; i < gradeRanges.length; i++) {
            List<int> existingRange = (gradeRanges[i]['range'] ?? '')
                .split('-')
                .map(int.parse)
                .toList();
            List<int> newRange = range.split('-').map(int.parse).toList();
            if (newRange[0] > existingRange[0]) {
              insertIndex = i + 1;
            }
          }
          gradeRanges.insert(insertIndex, {'grade': section, 'range': range});
        }
      } else {
        gradeRanges.removeWhere((element) => element['grade'] == section);
      }
      generateDataFromExcel();
    });
  }

  void generateDataFromExcel() {
    marksRanges.clear();
    numberOfStudents.clear();

    for (var gradeRange in gradeRanges) {
      int count = 0;
      var rangeValues = (gradeRange['range'] ?? '')
          .split('-')
          .map((e) => int.parse(e))
          .toList();

      for (var row in excelData) {
        double marks = row[1] as double;
        if (marks >= rangeValues[0] && marks <= rangeValues[1]) {
          count++;
        }
      }
      marksRanges.add(gradeRange['range'] ?? '');
      numberOfStudents.add(count);
    }
  }

  void _openFilePicker() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );
      if (result != null) {
        String? filePath = result.files.single.path;
        if (filePath != null) {
          var file = Excel.decodeBytes(io.File(filePath).readAsBytesSync());
          var table = file.tables['Sheet1'];
          var dataRows = table?.rows.skip(1);
          if (dataRows != null) {
            excelData = dataRows
                .map((row) => row.map((cell) => cell?.value).toList())
                .toList();

            generateDataFromExcel();
            for (var i = 0; i < marksRanges.length; i++) {
              print(marksRanges[i]);
            }
            for (var i = 0; i < numberOfStudents.length; i++) {
              print(numberOfStudents[i]);
            }
          }
        }
        setState(() {
          _filePath = filePath ?? 'No file selected';
        });
      } else {
        print('User canceled the file picking');
      }
    } catch (e) {
      print("Error picking file: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    generateDataFromExcel();
  }

  void printExceldata() {
    for (var row in excelData) {
      for (var cell in row) {
        print(cell);
      }
    }
  }

  void printmarksrange() {
    for (var row in marksRanges) {
      print(row);
    }
  }

  String getRange(String grade) {
    for (var i = 0; i < gradeRanges.length; i++) {
      if (gradeRanges[i]['grade'] == grade) {
        return gradeRanges[i]['range'] ?? '';
      }
    }
    return '';
  }

  Widget _buildBarChart() {
    if (_filePath == 'No file selected' || excelData.isEmpty) {
      return SizedBox(
        width: 700,
        height: 300,
        child: Container(
          color: Colors.grey[200],
          child: Center(
            child: Text(
              'No data available',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ),
      );
    } else {
      return SizedBox(
        width: 700,
        height: 600,
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
                  if (value.toInt() >= 0 &&
                      value.toInt() < marksRanges.length) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Picker Demo'),
        backgroundColor: Color.fromARGB(255, 190, 155, 250),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 25.0),
            Text(
              'Selected File:',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            Text(
              _filePath,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _openFilePicker,
              child: Text('Open File '),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Enter Grade Range'),
                    content: Column(
                      children: [
                        TextField(
                          controller: rangeAAController,
                          onChanged: (value) {
                            setState(() {
                              rangeAAController.text = value;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'A+(e.g. 90-100)',
                          ),
                        ),
                        TextField(
                          controller: rangeA1Controller,
                          onChanged: (value) {
                            setState(() {
                              rangeA1Controller.text = value;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'A',
                          ),
                        ),
                        TextField(
                          controller: rangeA0Controller,
                          onChanged: (value) {
                            setState(() {
                              rangeA0Controller.text = value;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'A-',
                          ),
                        ),
                        TextField(
                          controller: rangeB1Controller,
                          onChanged: (value) {
                            setState(() {
                              rangeB1Controller.text = value;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'B',
                          ),
                        ),
                        TextField(
                          controller: rangeB0Controller,
                          onChanged: (value) {
                            setState(() {
                              rangeB0Controller.text = value;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'B-',
                          ),
                        ),
                        TextField(
                          controller: rangeCController,
                          onChanged: (value) {
                            setState(() {
                              rangeCController.text = value;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'C',
                          ),
                        ),
                        TextField(
                          controller: rangeDController,
                          onChanged: (value) {
                            setState(() {
                              rangeDController.text = value;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'D',
                          ),
                        ),
                        TextField(
                          controller: rangeEController,
                          onChanged: (value) {
                            setState(() {
                              rangeEController.text = value;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'E',
                          ),
                        ),
                        TextField(
                          controller: rangeFController,
                          onChanged: (value) {
                            setState(() {
                              rangeFController.text = value;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'F',
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          addGradeRange('A+', rangeAAController.text);
                          addGradeRange('A', rangeA1Controller.text);
                          addGradeRange('A-', rangeA0Controller.text);
                          addGradeRange('B+', rangeB1Controller.text);
                          addGradeRange('B-', rangeB0Controller.text);
                          addGradeRange('C', rangeCController.text);
                          addGradeRange('D', rangeDController.text);
                          addGradeRange('E', rangeEController.text);
                          addGradeRange('F', rangeFController.text);

                          rangeAAController.text = getRange('A+');
                          rangeA1Controller.text = getRange('A');
                          rangeA0Controller.text = getRange('A-');
                          rangeB1Controller.text = getRange('B+');
                          rangeB0Controller.text = getRange('B-');
                          rangeCController.text = getRange('C');
                          rangeDController.text = getRange('D');
                          rangeEController.text = getRange('E');
                          rangeFController.text = getRange('F');
                        },
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Update Grade Range'),
            ),
            SizedBox(height: 16.0),
            Text('Grade Ranges:'),
            Expanded(
              child: ListView.builder(
                itemCount: gradeRanges.length,
                itemBuilder: (context, index) {
                  final grade = gradeRanges[index]['grade'];
                  final range = gradeRanges[index]['range'];
                  return ListTile(
                    title: Text('$grade: $range'),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: printExceldata,
              child: Text('excel data'),
            ),
            ElevatedButton(
              onPressed: printmarksrange,
              child: Text('print range'),
            ),
            Expanded(
              child: _buildBarChart(),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => barGraph()),
                );
              },
              child: Text('Bar Graph Screen'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => getgradeRange()),
                );
              },
              child: Text('Get Grade Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
