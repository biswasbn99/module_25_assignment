import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:module_25_assignment/core/constants/app_constants.dart';
import 'package:module_25_assignment/core/services/location_service.dart';

class LocationTrackerProvider extends ChangeNotifier {
  final LocationService _locationService;

  LocationTrackerProvider({LocationService? locationService})
      : _locationService = locationService ?? LocationService();

  GoogleMapController? _mapController;
  Position? _currentPosition;
  final List<LatLng> _polylineCoordinates = [];
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  Timer? _periodicTimer;

  bool _isLoading = true;
  String? _errorMessage;

  Position? get currentPosition => _currentPosition;
  List<LatLng> get polylineCoordinates => List.unmodifiable(_polylineCoordinates);
  Set<Marker> get markers => _markers;
  Set<Polyline> get polylines => _polylines;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  LatLng get currentLatLng => _currentPosition != null
      ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
      : AppConstants.defaultLocation;

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
    if (_currentPosition != null) {
      animateToCurrentLocation();
    }
  }

  Future<void> initializeTracking() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final bool hasPermission = await _locationService.checkAndRequestPermission();
    if (!hasPermission) {
      _isLoading = false;
      _errorMessage =
          'Location permission or GPS is disabled. Please enable GPS and grant permission to track location.';
      notifyListeners();
      return;
    }

    final initialPos = await _locationService.getCurrentPosition();
    if (initialPos != null) {
      _applyNewPosition(initialPos);
      animateToCurrentLocation();
    } else {
      _errorMessage = 'Could not fetch current location. Retrying in background...';
    }

    _isLoading = false;
    notifyListeners();

    _startPeriodicLocationUpdates();
  }

  void _startPeriodicLocationUpdates() {
    _periodicTimer?.cancel();
    _periodicTimer = Timer.periodic(
      const Duration(seconds: AppConstants.locationUpdateIntervalSeconds),
      (_) async {
        await _fetchAndUpdateLocation();
      },
    );
  }

  Future<void> _fetchAndUpdateLocation() async {
    final position = await _locationService.getCurrentPosition();
    if (position != null) {
      _applyNewPosition(position);
      animateToCurrentLocation();
    }
  }

  void _applyNewPosition(Position position) {
    _currentPosition = position;
    final latLng = LatLng(position.latitude, position.longitude);

    _polylineCoordinates.add(latLng);

    _polylines = {
      Polyline(
        polylineId: const PolylineId(AppConstants.trackingPolylineId),
        points: List.from(_polylineCoordinates),
        color: AppConstants.polylineColor,
        width: AppConstants.polylineWidth,
      ),
    };

    _markers = {
      Marker(
        markerId: const MarkerId(AppConstants.currentLocationMarkerId),
        position: latLng,
        infoWindow: InfoWindow(
          title: AppConstants.markerTitle,
          snippet: '${position.latitude}, ${position.longitude}',
        ),
      ),
    };

    notifyListeners();
  }

  Future<void> animateToCurrentLocation() async {
    if (_mapController == null || _currentPosition == null) return;

    final target = LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
    await _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: target,
          zoom: AppConstants.defaultZoom,
        ),
      ),
    );
  }

  Future<void> retry() async {
    await initializeTracking();
  }

  @override
  void dispose() {
    _periodicTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }
}