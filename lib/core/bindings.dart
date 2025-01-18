import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inventory_platform/core/services/auth_service.dart';
import 'package:inventory_platform/core/services/connection_service.dart';
import 'package:inventory_platform/core/services/error_service.dart';
import 'package:inventory_platform/core/services/warning_service.dart';
import 'package:inventory_platform/data/providers/utils_provider.dart';
import 'package:inventory_platform/features/common/controllers/connection_controller.dart';
import 'package:inventory_platform/features/common/controllers/sidebar_controller.dart';
import 'package:inventory_platform/core/services/mock_service.dart';

class CoreBindings extends Bindings {
  @override
  void dependencies() {
    final firebaseAuth = FirebaseAuth.instance;

    final googleSignIn = GoogleSignIn();

    Get.put<ConnectionService>(ConnectionService());
    Get.put<ErrorService>(ErrorService());
    Get.put<WarningService>(WarningService());

    Get.put<UtilsProvider>(UtilsProvider());

    Get.put<AuthService>(AuthService(
      firebaseAuth: firebaseAuth,
      googleSignIn: googleSignIn,
      errorService: Get.find<ErrorService>(),
      warningService: Get.find<WarningService>(),
      connectionService: Get.find<ConnectionService>(),
      utilsProvider: Get.find<UtilsProvider>(),
    ));

    Get.put<ConnectionController>(ConnectionController());
    Get.put<SidebarController>(SidebarController());
    Get.put<MockService>(MockService());
  }
}
