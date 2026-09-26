import 'package:flutter/material.dart';
import 'package:module_25_assignment/core/constants/app_constants.dart';
import 'package:module_25_assignment/features/location_tracker/providers/location_tracker_provider.dart';
import 'package:module_25_assignment/features/presentations/home_screen.dart';
import 'package:module_25_assignment/routes.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LocationTrackerProvider(),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appTitle,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        navigatorKey: MyApp.navigatorKey,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        initialRoute: MyAppHomeScreen.name,
      ),
    );
  }
}