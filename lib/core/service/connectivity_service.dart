import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkManager {
  static final NetworkManager _instance = NetworkManager._internal();
  factory NetworkManager() => _instance;
  NetworkManager._internal();

  final _connectivity = Connectivity();
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  Stream<bool> get onStatusChange => _controller.stream;

  void initialize() {
    _connectivity.onConnectivityChanged.listen((_) async {
      final hasInternet = await _checkActualInternetAccess();
      _controller.add(hasInternet);
    });

    // Optional: Run check on init
    _checkActualInternetAccess().then((hasInternet) {
      _controller.add(hasInternet);
    });
  }

  Future<bool> checkActualInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } catch (_) {}
    return false;
  }

  Future<bool> _checkActualInternetAccess() async {
    return checkActualInternetAccess();
  }

  void dispose() {
    _controller.close();
  }
}
