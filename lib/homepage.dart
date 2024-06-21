import 'package:flutter/material.dart';
import 'package:gradtry4/filePicker.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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
                          backgroundImage: AssetImage('assets/images/profile.jpeg'),
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
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FilePickerScreen()),
                );
              },
              child: Text('File Picker Screen'),
            ),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
