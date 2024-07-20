import 'package:flutter/material.dart';
import 'package:gradtry4/newScreen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Material(
                color: Color.fromARGB(255, 191, 161, 242),
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top, bottom: 24),
                    child: Column(
                      children: const [
                        SizedBox(
                          height: 12,
                        ),
                        CircleAvatar(
                          radius: 52,
                          backgroundImage:
                              AssetImage('assets/images/profile.jpeg'),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          '@sophia.com',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    leading: Icon(Icons.home_outlined),
                    title: Text('Home'),
                    onTap: () {},
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    color: Colors.black45,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  ListTile(
                    leading: Icon(Icons.logout_sharp),
                    title: Text('Log out'),
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => newPageScreen()),
                );
              },
              child: Text('Grad Calculate Screen'),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: Text(
                      '1. Please ensure that there should be no blank row or columns.',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Text(
                      '2. First row should be header e.g Rollno, Name, Marks',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Text(
                      '3. Please ensure that \'Marks\' column should be present',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
