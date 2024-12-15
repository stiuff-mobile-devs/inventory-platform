import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectionService {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectionSubscription;

  final StreamController<bool> _connectionStatusController =
      StreamController<bool>.broadcast();
  Stream<bool> get connectionStatus => _connectionStatusController.stream;

  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void startMonitoring() {
    _connectionSubscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.isEmpty || results.first == ConnectivityResult.none) {
        _connectionStatusController.add(false);
        debugPrint('Conexão com a internet perdida.');
      } else {
        _connectionStatusController.add(true);
        debugPrint('Conexão com a internet obtida. ${results.first.name}.');
      }
    });
  }

  void stopMonitoring() {
    _connectionSubscription.cancel();
  }
}
