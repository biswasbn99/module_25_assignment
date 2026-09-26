import 'package:flutter/material.dart';

class MyAppHomeScreen extends StatefulWidget {
  const MyAppHomeScreen({super.key});

  static const String name='/';

  @override
  State<MyAppHomeScreen> createState() => _MyAppHomeScreenState();
}

class _MyAppHomeScreenState extends State<MyAppHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Module 25 Assignment'),
        centerTitle: true,

        backgroundColor: const Color.fromARGB(75, 158, 158, 158),
      ),
    );
  }
}