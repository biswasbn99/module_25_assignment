import 'package:flutter/material.dart';
import 'package:module_25_assignment/features/presentations/home_screen.dart';

class AppRoutes {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    late Widget widget;

    switch (settings.name) {
      case MyAppHomeScreen.name:
      default:
        widget = const MyAppHomeScreen();
        break;
    }

    return MaterialPageRoute(builder: (_) => widget, settings: settings);
  }
}