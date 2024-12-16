import 'package:get/get.dart';
import 'package:inventory_platform/features/data/services/connection_service.dart';

class ConnectionController extends GetxController {
  late ConnectionService _connectionService;
  var isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    _connectionService = Get.find<ConnectionService>();
    _connectionService.startMonitoring();
    _connectionService.connectionStatus.listen((status) {
      updateConnectionStatus(status);
    });
  }

  @override
  void onClose() {
    _connectionService.stopMonitoring();
    super.onClose();
  }

  void updateConnectionStatus(bool status) {
    isConnected.value = status;
  }
}
