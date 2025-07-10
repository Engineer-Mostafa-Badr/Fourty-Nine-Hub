import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'connectivity_service.dart';

enum NetworkConnectivityState { connected, disconnected }

class NetworkConnectivityCubit extends Cubit<NetworkConnectivityState> {
  final NetworkManager _networkManager = NetworkManager();
  StreamSubscription<bool>? _networkSubscription;
  String? _lastRoute;
  final GlobalKey<NavigatorState> navigatorKey;

  NetworkConnectivityCubit({required this.navigatorKey}) : super(NetworkConnectivityState.connected) {
    _initializeNetworkMonitoring();
  }

  void _initializeNetworkMonitoring() {
    _networkSubscription = _networkManager.onStatusChange.listen((isConnected) {
      if (isConnected) {
        emit(NetworkConnectivityState.connected);
        _handleReconnection();
      } else {
        _saveCurrentRoute();
        emit(NetworkConnectivityState.disconnected);
      }
    });
    
    // Initial check
    _networkManager.checkActualInternetAccess().then((isConnected) {
      if (!isConnected) {
        emit(NetworkConnectivityState.disconnected);
      }
    });
  }

  void _saveCurrentRoute() {
    try {
      final context = navigatorKey.currentContext;
      if (context != null) {
        final router = GoRouter.of(context);
        // Use routerDelegate.currentConfiguration.uri.toString() instead of location
        _lastRoute = router.routerDelegate.currentConfiguration.uri.toString();
      }
    } catch (e) {
      // Handle case where context is not available
      print('Could not save current route: $e');
    }
  }

  void _handleReconnection() {
    if (_lastRoute != null) {
      try {
        final context = navigatorKey.currentContext;
        if (context != null) {
          // Navigate back to the last route and reinitialize
          final router = GoRouter.of(context);
          router.go(_lastRoute!);
        }
      } catch (e) {
        // Handle case where context is not available
        print('Could not navigate to last route: $e');
      } finally {
        _lastRoute = null;
      }
    }
  }

  @override
  Future<void> close() {
    _networkSubscription?.cancel();
    return super.close();
  }
} 