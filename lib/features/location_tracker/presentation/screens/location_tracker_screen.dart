import 'package:flutter/material.dart';
import 'package:module_25_assignment/core/constants/app_constants.dart';
import 'package:module_25_assignment/features/location_tracker/presentation/widgets/location_error_banner.dart';
import 'package:module_25_assignment/features/location_tracker/presentation/widgets/map_view_widget.dart';
import 'package:module_25_assignment/features/location_tracker/providers/location_tracker_provider.dart';
import 'package:provider/provider.dart';

class MyAppHomeScreen extends StatefulWidget {
  const MyAppHomeScreen({super.key});

  static const String name = '/';

  @override
  State<MyAppHomeScreen> createState() => _MyAppHomeScreenState();
}

class _MyAppHomeScreenState extends State<MyAppHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationTrackerProvider>().initializeTracking();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppConstants.appTitle,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 2,
      ),
      body: Stack(
        children: [
          const MapViewWidget(),
          const LocationErrorBanner(),
          Consumer<LocationTrackerProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text(
                              'Fetching current location...',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<LocationTrackerProvider>().animateToCurrentLocation();
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        tooltip: 'My Location',
        child: const Icon(Icons.my_location),
      ),
    );
  }
}