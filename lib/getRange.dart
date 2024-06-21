import 'package:flutter/material.dart';

class getgradeRange extends StatefulWidget {
  const getgradeRange({super.key});

  @override
  State<getgradeRange> createState() => _getgradeRangeState();
}

//1. error handling on AlertDialog
//2. validation on AlertDialog

class _getgradeRangeState extends State<getgradeRange> {
  TextEditingController rangeAAController = TextEditingController();
  TextEditingController rangeA1Controller = TextEditingController();
  TextEditingController rangeA0Controller = TextEditingController();
  TextEditingController rangeB1Controller = TextEditingController();
  TextEditingController rangeB0Controller = TextEditingController();
  TextEditingController rangeCController = TextEditingController();
  TextEditingController rangeDController = TextEditingController();
  TextEditingController rangeEController = TextEditingController();
  TextEditingController rangeFController = TextEditingController();

  // Map<String, String> gradeRanges = {};
  // void addGradeRange(String section, String range) {
  //   setState(() {
  //     gradeRanges[section] = range;
  //   });
  // }

  List<Map<String, String>> gradeRanges = [];

  void addGradeRange(String section, String range) {
    setState(() {
      bool found = false;
      for (int i = 0; i < gradeRanges.length; i++) {
        if (gradeRanges[i].containsKey(section)) {
          // If the section exists, update its range
          gradeRanges[i][section] = range;
          found = true;
          break;
        }
      }
      if (!found) {
        gradeRanges.add({section: range});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grade Range Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
                          addGradeRange('B', rangeB1Controller.text);
                          addGradeRange('B-', rangeB0Controller.text);
                          addGradeRange('C', rangeCController.text);
                          addGradeRange('D', rangeDController.text);
                          addGradeRange('E', rangeEController.text);
                          addGradeRange('F', rangeFController.text);
                        },
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Add Grade Range'),
            ),
            SizedBox(height: 16.0),
            Text('Grade Ranges:'),
            Expanded(
              child: ListView.builder(
                itemCount: gradeRanges.length,
                itemBuilder: (context, index) {
                  final grade = gradeRanges[index].keys.first;
                  final range = gradeRanges[index][grade];
                  return ListTile(
                    title: Text('$grade: $range'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
