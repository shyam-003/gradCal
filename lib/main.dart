import 'package:flutter/material.dart';
import 'package:gradtry4/homepage.dart';
import 'package:gradtry4/login.dart';
import 'package:gradtry4/signIn.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const MyHomePage(title: 'Grade Cal',),
        '/login': (context) =>  LoginScreen(),
        '/signIn': (context) =>  signInScreen(),
      },
    );
  }
}
