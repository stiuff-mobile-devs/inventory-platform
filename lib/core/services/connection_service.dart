import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:inventory_platform/core/debug/logger.dart';
import 'package:inventory_platform/core/services/http_service.dart';

class ConnectionService {
  final Connectivity _connectivity = Connectivity();
  final HttpService _httpService = HttpService();
  late StreamSubscription<List<ConnectivityResult>> _connectionSubscription;

  final StreamController<bool> _connectionStatusController =
      StreamController<bool>.broadcast();
  Stream<bool> get connectionStatus => _connectionStatusController.stream;

  Future<bool> checkInternetConnection() async {
    try {
      final response = await _httpService.get('https://httpbin.org/get');
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  void startMonitoring() {
    _connectionSubscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) async {
      if (results.isEmpty || results.first == ConnectivityResult.none) {
        _connectionStatusController.add(false);
        Logger.warning('Conexão com a internet perdida.');
      } else {
        final hasInternet = await checkInternetConnection();
        _connectionStatusController.add(hasInternet);
        Logger.info('Conexão com a internet obtida. ${results.first.name}.');
      }
    });
  }

  void stopMonitoring() {
    _connectionSubscription.cancel();
  }
}
