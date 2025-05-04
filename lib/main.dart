import 'package:flutter/material.dart';
import 'package:it_department/presentation/screens/home/home_screen.dart';
import 'package:it_department/presentation/screens/login/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "IT DEPARTMENT",
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        brightness: Brightness.light,
      ),
      home: Scaffold(
        // appBar: AppBar(title: Text("Home"), backgroundColor: Colors.blueGrey),
        body: SafeArea(child: LoginScreen()),
      ),
    );
  }
}
