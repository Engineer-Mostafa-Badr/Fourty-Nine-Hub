import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_cubit/main_categories_cubit.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:geolocator/geolocator.dart';

class LocationServiceWatcher {
  static final LocationServiceWatcher _instance = LocationServiceWatcher._internal();
  factory LocationServiceWatcher() => _instance;
  LocationServiceWatcher._internal();

  StreamSubscription<ServiceStatus>? _subscription;
  bool? _lastStatus;

  /// Start watching location service changes
  Future<void> start() async {
    // Initial check
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    _lastStatus = serviceEnabled;
    print("🔍 Initial Location Service: ${serviceEnabled ? 'ENABLED' : 'DISABLED'}");

    // Start listening to changes
    _subscription = Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
      bool isEnabled = status == ServiceStatus.enabled;
      var currentContext = AppPages.router.configuration.navigatorKey.currentContext!;

      if (_lastStatus != isEnabled) {
        _lastStatus = isEnabled;

        if (isEnabled) {
          currentContext.read<MainCategoriesCubit>().updateSettings(true);
          print("✅ Location Service ENABLED");
        } else {
          currentContext.read<MainCategoriesCubit>().updateSettings(false);
          print("❌ Location Service DISABLED");
        }
      }
    });
  }

  /// Stop listening (optional)
  void stop() {
    _subscription?.cancel();
    _subscription = null;
  }
}