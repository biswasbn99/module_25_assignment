import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppConstants {
  static const String appTitle = 'Real-Time Location Tracker';
  static const int locationUpdateIntervalSeconds = 10;
  static const double defaultZoom = 16.0;
  static const LatLng defaultLocation = LatLng(23.7216771, 90.4165835);
  static const String currentLocationMarkerId = 'current_location_marker';
  static const String trackingPolylineId = 'tracking_route_polyline';
  static const Color polylineColor = Colors.blue;
  static const int polylineWidth = 6;
  static const String markerTitle = 'My Current Location';
}