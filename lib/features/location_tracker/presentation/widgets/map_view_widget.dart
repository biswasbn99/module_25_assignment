import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:module_25_assignment/core/constants/app_constants.dart';
import 'package:module_25_assignment/features/location_tracker/providers/location_tracker_provider.dart';
import 'package:provider/provider.dart';

class MapViewWidget extends StatelessWidget {
  const MapViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationTrackerProvider>(
      builder: (context, provider, child) {
        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: provider.currentLatLng,
            zoom: AppConstants.defaultZoom,
          ),
          onMapCreated: (controller) {
            provider.setMapController(controller);
          },
          markers: provider.markers,
          polylines: provider.polylines,
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: true,
          compassEnabled: true,
          mapToolbarEnabled: true,
        );
      },
    );
  }
}