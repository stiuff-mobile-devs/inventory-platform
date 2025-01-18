import 'package:get/get.dart';
import 'package:inventory_platform/core/services/auth_service.dart';
import 'package:inventory_platform/routes/routes.dart';

class SidebarController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  var userName = ''.obs;
  var userEmail = ''.obs;
  var userPhotoUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserInfo();
  }

  Future<String?> getProfileImageUrl() {
    return _authService.getProfileImageUrl();
  }

  void _loadUserInfo() {
    var user = _authService.currentUser;
    if (user != null) {
      userName.value = user.displayName ?? 'Usuário';
      userEmail.value = user.email ?? '';
      userPhotoUrl.value = user.photoURL ?? '';
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    Get.offAllNamed(AppRoutes.login);
  }
}
