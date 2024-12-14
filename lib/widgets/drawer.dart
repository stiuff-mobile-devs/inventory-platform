import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/features/modules/home/home_controller.dart';

class CustomDrawer extends StatelessWidget {
  final HomeController controller;

  const CustomDrawer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          _buildUserAccountsDrawerHeader(controller),
          _buildDrawerItem(
            icon: Icons.home,
            title: 'Home',
            onTap: () => Get.offAllNamed('/home'),
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            title: 'Configurações',
            onTap: () => Get.toNamed('/settings'),
          ),
          _buildDrawerItem(
            icon: Icons.help,
            title: 'Ajuda',
            onTap: () => Get.toNamed('/help'),
          ),
          _buildDrawerItem(
            icon: Icons.logout,
            title: 'Logout',
            onTap: controller.signOut,
          ),
        ],
      ),
    );
  }

  Widget _buildUserAccountsDrawerHeader(HomeController controller) {
    return UserAccountsDrawerHeader(
      accountName: Obx(() => Text(controller.userName.value)),
      accountEmail: Obx(() => Text(controller.userEmail.value)),
      currentAccountPicture: Obx(() {
        return CircleAvatar(
          backgroundImage: controller.userPhotoUrl.value.isNotEmpty
              ? NetworkImage(controller.userPhotoUrl.value)
              : null,
          child: controller.userPhotoUrl.value.isEmpty
              ? const Icon(Icons.person, size: 40)
              : null,
        );
      }),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required Function onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () => onTap(),
    );
  }
}
