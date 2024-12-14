import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/features/data/services/auth_service.dart';
import 'package:inventory_platform/routes/routes.dart';

class HomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  var userName = ''.obs;
  var userEmail = ''.obs;
  var userPhotoUrl = ''.obs;

  var carouselIndex = 0.obs;
  var pageIndex = 0.obs;
  final List<String> inventoryItems =
      List.generate(10, (index) => 'Inventário ${index + 1}');
  final int itemsPerPage = 6;

  bool get isPortrait =>
      Get.context!.mediaQuery.orientation == Orientation.portrait;
  int get pageCount => (inventoryItems.length / itemsPerPage).ceil();

  @override
  void onInit() {
    super.onInit();
    _loadUserInfo();
  }

  void _loadUserInfo() {
    var user = _authService.currentUser;
    if (user != null) {
      userName.value = user.displayName ?? 'Usuário';
      userEmail.value = user.email ?? '';
      userPhotoUrl.value = user.photoURL ?? '';
    }
  }

  void updateCarouselIndex(int index) {
    carouselIndex.value = index;
  }

  void updatePageIndex(int index) {
    pageIndex.value = index;
  }

  Future<void> signOut() async {
    await _authService.signOut();
    Get.offAllNamed(AppRoutes.login);
  }
}
