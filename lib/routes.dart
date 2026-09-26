import 'package:flutter/material.dart';
import 'package:module_25_assignment/features/presentations/home_screen.dart';

class AppRoutes{
  static Route<dynamic>? onGenerateRoute(RouteSettings settings){
    late Widget widget;

    switch(settings.name){
      case MyAppHomeScreen.name:
      widget=MyAppHomeScreen();
    } 
    
    return MaterialPageRoute(builder:(_)=>widget);
  }
}