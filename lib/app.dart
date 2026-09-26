import 'package:flutter/material.dart';
import 'package:module_25_assignment/features/presentations/home_screen.dart';
import 'package:module_25_assignment/routes.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  
  static GlobalKey<NavigatorState> navigatorKey=GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Module 25 - Assignment ',
      navigatorKey: MyApp.navigatorKey,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      initialRoute: MyAppHomeScreen.name,
      debugShowCheckedModeBanner: false,
      
    );
  }
}