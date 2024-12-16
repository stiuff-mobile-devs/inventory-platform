import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:inventory_platform/features/modules/home/home_controller.dart';

class CustomSidebar extends StatelessWidget {
  final HomeController controller;

  CustomSidebar({super.key, required this.controller});

  final SidebarXController sidebarController =
      SidebarXController(selectedIndex: 0, extended: true);

  final List<String> routes = [
    '/home',
    '/settings',
    '/help',
  ];

  void _updateSelectedIndex(String route) {
    final index = routes.indexOf(route);
    if (index != -1) {
      sidebarController.selectIndex(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSelectedIndex(Get.currentRoute);
    });

    return SidebarX(
      controller: sidebarController,
      theme: SidebarXTheme(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        decoration: BoxDecoration(
          color: const Color(0xFF4A148C),
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
        selectedTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        itemMargin: const EdgeInsets.symmetric(horizontal: 10),
        selectedItemMargin: const EdgeInsets.symmetric(horizontal: 10),
        itemTextPadding: const EdgeInsets.only(left: 20),
        selectedItemTextPadding: const EdgeInsets.only(left: 20),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.transparent,
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(122, 124, 58, 204),
          border: Border.all(
            color: const Color.fromARGB(255, 123, 58, 204),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        selectedIconTheme: const IconThemeData(color: Colors.white),
      ),
      extendedTheme: const SidebarXTheme(
        width: 260,
      ),
      headerBuilder: (context, extended) => Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: _buildUserHeader(controller, extended),
      ),
      items: [
        SidebarXItem(
          icon: Icons.dashboard_rounded,
          label: 'Home',
          onTap: () {
            Get.offAllNamed('/home');
            sidebarController.selectIndex(0);
          },
        ),
        SidebarXItem(
          icon: Icons.settings_applications,
          label: 'Configurações',
          onTap: () {
            Get.toNamed('/settings');
            sidebarController.selectIndex(1);
          },
        ),
        SidebarXItem(
          icon: Icons.help,
          label: 'Ajuda',
          onTap: () {
            Get.toNamed('/help');
            sidebarController.selectIndex(2);
          },
        ),
        SidebarXItem(
          icon: Icons.logout,
          label: 'Logout',
          onTap: controller.signOut,
        ),
      ],
    );
  }

  Widget _buildUserHeader(HomeController controller, bool extended) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color(0xFF4A148C),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: (extended) ? 30 : 16,
              backgroundImage: controller.userPhotoUrl.value.isNotEmpty
                  ? NetworkImage(controller.userPhotoUrl.value)
                  : null,
              child: controller.userPhotoUrl.value.isEmpty
                  ? const Icon(Icons.person, size: 24)
                  : null,
            ),
            if (extended) const SizedBox(width: 16),
            if (extended)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.userName.value.split(' ')[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    controller.userEmail.value,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
          ],
        ),
      );
    });
  }
}
