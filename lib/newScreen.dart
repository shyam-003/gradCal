import 'dart:io' as io;
import 'dart:io';
import 'dart:math';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row;
import 'package:universal_io/io.dart';

class newPageScreen extends StatefulWidget {
  @override
  _newPageScreenState createState() => _newPageScreenState();
}

class _newPageScreenState extends State<newPageScreen> {
  String _filePath = 'No file selected';

  List<double> studentsMarks = [];

  List<List<dynamic>> excelData = [];
  List<List<dynamic>> modifiedExcelData = [];

  List<String> marksRanges = [];

  List<String> studentGrades = [];

  List<Map<String, dynamic>> gradeRanges = [
    {'grade': 'A*', 'lowRange': 90, 'highRange': 100},
    {'grade': 'A', 'lowRange': 80, 'highRange': 89},
    {'grade': 'A-', 'lowRange': 70, 'highRange': 79},
    {'grade': 'B', 'lowRange': 60, 'highRange': 69},
    {'grade': 'B-', 'lowRange': 50, 'highRange': 59},
    {'grade': 'C', 'lowRange': 45, 'highRange': 49},
    {'grade': 'C-', 'lowRange': 40, 'highRange': 45},
    {'grade': 'D', 'lowRange': 30, 'highRange': 39},
    {'grade': 'E', 'lowRange': 20, 'highRange': 29},
    {'grade': 'F', 'lowRange': 0, 'highRange': 19},
  ];

  List<Map<String, dynamic>> twentyPerGradeRange = [
    {'grade': 'A*', 'lowRange': 90, 'highRange': 100},
    {'grade': 'A', 'lowRange': 80, 'highRange': 89},
    {'grade': 'A-', 'lowRange': 70, 'highRange': 79},
    {'grade': 'B', 'lowRange': 60, 'highRange': 69},
    {'grade': 'B-', 'lowRange': 50, 'highRange': 59},
    {'grade': 'C', 'lowRange': 45, 'highRange': 49},
    {'grade': 'C-', 'lowRange': 40, 'highRange': 45},
    {'grade': 'D', 'lowRange': 30, 'highRange': 39},
    {'grade': 'E', 'lowRange': 20, 'highRange': 29},
    {'grade': 'F', 'lowRange': 0, 'highRange': 19},
  ];

// text editing controller
  List<TextEditingController> lowerRangeControllers = [];

  @override
  void initState() {
    super.initState();
    // Initialize controllers for each grade range
    for (int i = 0; i < twentyPerGradeRange.length; i++) {
      lowerRangeControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    // Dispose controllers to free resources
    for (var controller in lowerRangeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

// file picker
  void _openFilePicker() async {
    modifiedExcelData.clear();
    excelData.clear();
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
          var dataRows = table?.rows;
          if (dataRows != null) {
            excelData = dataRows
                .map((row) => row.map((cell) => cell?.value).toList())
                .toList();

            print(excelData);
            print('rows:${excelData.length}');
            print('col:${excelData[0].length}');
            generateDataFromExcel();
          }
        }
        setState(() {
          _filePath = filePath ?? 'No file selected';
          for (int i = 0; i < twentyPerGradeRange.length; i++) {
            lowerRangeControllers[i].text =
                '${twentyPerGradeRange[i]['lowRange']} - ${twentyPerGradeRange[i]['highRange']}';
          }
          modifiedExcelData = excelData;
        });
      } else {
        print('User canceled the file picking');
      }
    } catch (e) {
      print("Error picking file: $e");
    }
  }

  bool marksHeaderFound = false;

  void generateDataFromExcel() {
    marksRanges.clear();
    studentsMarks.clear();

    print('print');
    int marksColumnIndex = -1;
    for (int i = 0; i < excelData[0].length; i++) {
      print('Checking header: ${excelData[0][i]}');
      if (excelData[0][i]?.toString().toLowerCase() == 'marks') {
        marksColumnIndex = i;
        print('header index - ${marksColumnIndex}');
        break;
      }
    }
    print('index: ${marksColumnIndex}');
    if (marksColumnIndex != -1) {
      marksHeaderFound = true;
      for (int i = 1; i < excelData.length; i++) {
        var cellValue = excelData[i][marksColumnIndex];
        if (cellValue != null) {
          if (cellValue is double) {
            studentsMarks.add(cellValue);
          } else if (cellValue is String) {
            try {
              double marks = double.parse(cellValue);
              studentsMarks.add(marks);
            } catch (e) {
              print("Error parsing marks: $e");
            }
          }
        }
      }
    } else {
      marksHeaderFound = false;
      print('error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Marks column not found in Excel data. Please follow the format'),
          duration: Duration(seconds: 3),
        ),
      );
    }

    if (marksHeaderFound) {
      print('Student Marks: $studentsMarks');
      twenPerRange();
    }
  }

  void addGrade(List<Map<String, dynamic>> updatedRanges) {
    studentGrades.clear();
    for (var mark in studentsMarks) {
      for (var grad in updatedRanges) {
        if (mark >= grad['lowRange'] && mark <= grad['highRange']) {
          studentGrades.add(grad['grade']);
          break;
        }
      }
    }
    print(studentGrades);
  }

  void updateData() {
    addGrade(twentyPerGradeRange);

    int gradeColumnIndex = -1;
    for (int i = 0; i < modifiedExcelData[0].length; i++) {
      if (modifiedExcelData[0][i] == 'Grade') {
        gradeColumnIndex = i;
        break;
      }
    }

    if (gradeColumnIndex == -1) {
      for (int i = 0; i < modifiedExcelData.length; i++) {
        if (i == 0) {
          modifiedExcelData[i].add('Grade');
        } else {
          modifiedExcelData[i].add(studentGrades[i - 1]);
        }
      }
    } else {
      for (int i = 0; i < modifiedExcelData.length; i++) {
        if (i == 0) {
        } else {
          modifiedExcelData[i][gradeColumnIndex] = studentGrades[i - 1];
        }
      }
    }

    print('Excel data : ${excelData}');
    print('Modified data : ${modifiedExcelData}');
  }

// get grade range
  double toTwoDecimal(double value) {
    return double.parse(value.toStringAsFixed(2));
  }

  void twenPerRange() {
    double highestMarks = findMax(studentsMarks);
    double lowestMarks = findMin(studentsMarks);
    double avg = calculateAverage(studentsMarks);
    print('highest marks: ${highestMarks}');
    print('lowest marks: ${lowestMarks}');
    print('avg: ${avg}');

    double intv = (avg * .15).toDouble()..toStringAsFixed(2);

// Directly assign values to 'A+' grade
    twentyPerGradeRange[0]['highRange'] = toTwoDecimal(100.00);
    twentyPerGradeRange[0]['lowRange'] =
        toTwoDecimal(min(96.00, (avg + 4 * intv).toDouble()));

// Directly assign values to 'A' grade
    twentyPerGradeRange[1]['highRange'] =
        toTwoDecimal((avg + 4 * intv).toDouble());
    twentyPerGradeRange[1]['lowRange'] =
        toTwoDecimal((avg + 3 * intv).toDouble());

// Directly assign values to 'A-' grade
    twentyPerGradeRange[2]['highRange'] =
        toTwoDecimal((avg + 3 * intv).toDouble());
    twentyPerGradeRange[2]['lowRange'] =
        toTwoDecimal((avg + 2 * intv).toDouble());

// Directly assign values to 'B' grade
    twentyPerGradeRange[3]['highRange'] =
        toTwoDecimal((avg + 2 * intv).toDouble());
    twentyPerGradeRange[3]['lowRange'] = toTwoDecimal((avg + intv).toDouble());

// Directly assign values to 'B-' grade
    twentyPerGradeRange[4]['highRange'] = toTwoDecimal((avg + intv).toDouble());
    twentyPerGradeRange[4]['lowRange'] = toTwoDecimal(avg.toDouble());

// Directly assign values to 'C' grade
    twentyPerGradeRange[5]['highRange'] = toTwoDecimal(avg.toDouble());
    twentyPerGradeRange[5]['lowRange'] = toTwoDecimal((avg - intv).toDouble());

// Directly assign values to 'C-' grade
    twentyPerGradeRange[6]['highRange'] = toTwoDecimal((avg - intv).toDouble());
    twentyPerGradeRange[6]['lowRange'] =
        toTwoDecimal((avg - 2 * intv).toDouble());

// Directly assign values to 'D' grade
    twentyPerGradeRange[7]['highRange'] =
        toTwoDecimal((avg - 2 * intv).toDouble());
    twentyPerGradeRange[7]['lowRange'] =
        toTwoDecimal((avg - 3 * intv).toDouble());

    // Directly assign values to 'E' grade
    twentyPerGradeRange[8]['highRange'] =
        toTwoDecimal((avg - 3 * intv).toDouble());
    twentyPerGradeRange[8]['lowRange'] =
        toTwoDecimal((avg - 4 * intv).toDouble());

// Directly assign values to 'F' grade
    twentyPerGradeRange[9]['highRange'] =
        toTwoDecimal(
          // max(
          // 23.00, 
          (avg - 4 * intv).toDouble()
          // )
          );
    twentyPerGradeRange[9]['lowRange'] = toTwoDecimal(0.00);

    print(twentyPerGradeRange);
  }

  double findMax(List<double> numbers) {
    if (numbers.isEmpty) {
      throw ArgumentError("List must not be empty");
    }
    return numbers.reduce((max, element) => max > element ? max : element);
  }

  double findMin(List<double> numbers) {
    if (numbers.isEmpty) {
      throw ArgumentError("List must not be empty");
    }
    return numbers.reduce((min, element) => min < element ? min : element);
  }

  double calculateAverage(List<double> numbers) {
    if (numbers.isEmpty) return 0.0;
    double sum = numbers.reduce((value, element) => value + element);
    return sum / numbers.length;
  }

// body
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo'),
        backgroundColor: Color.fromARGB(255, 190, 155, 250),
      ),
      body: SingleChildScrollView(
        child: Center(
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
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
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
                      content: SingleChildScrollView(
                        child: Column(
                          children: List.generate(
                            twentyPerGradeRange.length,
                            (index) => Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: lowerRangeControllers[index],
                                    decoration: InputDecoration(
                                      labelText:
                                          '${twentyPerGradeRange[index]['grade']} Range (e.g. ${twentyPerGradeRange[index]['lowRange']} - ${twentyPerGradeRange[index]['highRange']})',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // Update twentyPerGradeRange based on controller values
                            for (int i = 0;
                                i < twentyPerGradeRange.length;
                                i++) {
                              List<String> ranges =
                                  lowerRangeControllers[i].text.split('-');
                              twentyPerGradeRange[i]['lowRange'] =
                                  double.parse(ranges[0].trim());
                              twentyPerGradeRange[i]['highRange'] =
                                  double.parse(ranges[1].trim());
                            }
                            // updateData();
                            setState(() {
                              // updateData();
                            });
                            Navigator.of(context).pop();
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
              Container(
                height: 300,
                child: ListView.builder(
                  // scrollDirection: Axis.horizontal,
                  itemCount: twentyPerGradeRange.length,
                  itemBuilder: (context, index) {
                    final grade = twentyPerGradeRange[index]['grade'];
                    final lowerRange = twentyPerGradeRange[index]['lowRange'];
                    final higherRange = twentyPerGradeRange[index]['highRange'];
                    return Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 235, 230, 244),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      // width: 200,
                      padding: EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text('$grade: $lowerRange - $higherRange'),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20.0),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     ElevatedButton(
              //       onPressed: () {
              //         print(excelData);
              //       },
              //       child: Text('Get Excel Data on Console '),
              //     ),
              //     SizedBox(height: 10.0),
              //     ElevatedButton(
              //       onPressed: updateData,
              //       child: Text('Get Updated Data '),
              //     ),
              //   ],
              // ),
              SizedBox(height: 20.0),
              _buildBarChart(_filePath, studentsMarks, twentyPerGradeRange),
              SizedBox(height: 60.0),
              ElevatedButton(
                onPressed: () {
                  getExcelFile(context);
                  // createExcel();
                },
                child: Text('Open Updated Excel File'),
              ),
            ],
          ),
        ),
      ),
    );
  }

//get excel file
  void getExcelFile(BuildContext context) async {
    try {
      updateData();
      final Workbook workbook = Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      int rowIndex = 1;
      for (var rowData in modifiedExcelData) {
        for (int colIndex = 0; colIndex < rowData.length; colIndex++) {
          sheet
              .getRangeByIndex(rowIndex, colIndex + 1)
              .setValue(rowData[colIndex]);
          print('Data written - ${rowData[colIndex]}');
        }
        rowIndex++;
      }

      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      // if (kIsWeb) {
      //   AnchorElement(
      //       href:
      //           'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
      //     ..setAttribute('download', 'Output.xlsx')
      //     ..click();
      //   // downloadOnWeb(bytes);
      //   //  downloadOnWeb(bytes, 'Output.xlsx');
      // } else {
      final String path = (await getApplicationSupportDirectory()).path;
      final String fileName =
          // Platform.isWindows ? '$path\\file.xlsx' :
          '$path/file.xlsx';
      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);

      // }
      // Show a dialog with download confirmation
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Open file'),
            content: Text(
                'do you want to open this file. Ensure that you have excel reader installed,And before you open Click on Get Updated data to update data on file'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  // updateData()
                  OpenFile.open(fileName);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred: $e'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

// bar plot
  List<int> numberOfStudents = [];

  void generateSampleData(
      List<double> studentMarks, List<Map<String, dynamic>> gradeRange) {
    numberOfStudents.clear();
    for (int j = 0; j < gradeRange.length; j++) {
      int count = 0;
      for (int i = 0; i < studentMarks.length; i++) {
        if (studentMarks[i] >= gradeRange[j]['lowRange'] &&
            studentMarks[i] <= gradeRange[j]['highRange']) {
          count++;
        }
      }
      numberOfStudents.add(count);
    }
    print(
        'number of students: ${numberOfStudents}, student marks: ${studentMarks}');
  }

  Widget _buildBarChart(String? _filePath, List<double> studentMarks,
      final List<Map<String, dynamic>> gradeRange) {
    generateSampleData(studentMarks, twentyPerGradeRange);
    if (_filePath == 'No file selected' || studentMarks.isEmpty) {
      print('no data, file-path: ${_filePath}, student marks: ${studentMarks}');
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
        height: 300,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: numberOfStudents.isNotEmpty
                ? numberOfStudents
                    .reduce(
                        (value, element) => value > element ? value : element)
                    .toDouble()
                : 0,
            barGroups: List.generate(gradeRange.length, (index) {
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
                interval: 1,
                rotateAngle: 90,
                getTitles: (double value) {
                  if (value.toInt() >= 0 && value.toInt() < gradeRange.length) {
                    return '${gradeRange[value.toInt()]['grade']} : ${gradeRange[value.toInt()]['lowRange']}-${gradeRange[value.toInt()]['highRange']}';
                  }
                  return '';
                },
              ),
              leftTitles: SideTitles(
                showTitles: true,
                getTextStyles: (value) => const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ),
          ),
        ),
      );
    }
  }
}
