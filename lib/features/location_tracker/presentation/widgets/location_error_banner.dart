import 'package:flutter/material.dart';
import 'package:module_25_assignment/features/location_tracker/providers/location_tracker_provider.dart';
import 'package:provider/provider.dart';

class LocationErrorBanner extends StatelessWidget {
  const LocationErrorBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationTrackerProvider>(
      builder: (context, provider, child) {
        if (provider.errorMessage == null) {
          return const SizedBox.shrink();
        }

        return Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 30),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      provider.errorMessage!,
                      style: const TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => provider.retry(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}