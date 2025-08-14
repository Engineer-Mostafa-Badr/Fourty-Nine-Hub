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
      try {
        if (isConnected) {
          // Only emit if state actually changed to prevent unnecessary rebuilds
          if (state != NetworkConnectivityState.connected) {
            emit(NetworkConnectivityState.connected);
            _handleReconnection();
          }
        } else {
          // Only emit if state actually changed to prevent unnecessary rebuilds
          if (state != NetworkConnectivityState.disconnected) {
            _saveCurrentRoute();
            emit(NetworkConnectivityState.disconnected);
          }
        }
      } catch (e) {
        print('Error in network status change handler: $e');
        // Don't emit new states on error to prevent widget tree corruption
      }
    });
    
    // Initial check
    _networkManager.checkActualInternetAccess().then((isConnected) {
      try {
        if (!isConnected && state != NetworkConnectivityState.disconnected) {
          emit(NetworkConnectivityState.disconnected);
        }
      } catch (e) {
        print('Error in initial network check: $e');
      }
    }).catchError((e) {
      print('Failed to perform initial network check: $e');
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
          final router = GoRouter.of(context);
          final currentRoute = router.routerDelegate.currentConfiguration.uri.toString();
          
          // Only navigate if we're not already on the target route to prevent unnecessary rebuilds
          if (currentRoute != _lastRoute) {
            // Use a small delay to ensure the network is stable before navigation
            Future.delayed(const Duration(milliseconds: 500), () {
              try {
                final currentContext = navigatorKey.currentContext;
                if (currentContext != null) {
                  final currentRouter = GoRouter.of(currentContext);
                  currentRouter.go(_lastRoute!);
                }
              } catch (e) {
                print('Could not navigate to last route during reconnection: $e');
              }
            });
          }
        }
      } catch (e) {
        print('Could not handle reconnection: $e');
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