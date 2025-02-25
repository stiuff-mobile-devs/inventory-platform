import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/core/services/utils_service.dart';
import 'package:inventory_platform/features/common/controllers/sidebar_controller.dart';
import 'package:inventory_platform/routes/routes.dart';
import 'package:sidebarx/sidebarx.dart';

class CustomSidebar extends StatelessWidget {
  CustomSidebar({super.key});
  final controller = Get.find<SidebarController>();
  final UtilsService utilsService = UtilsService();

  final SidebarXController sidebarController =
      SidebarXController(selectedIndex: 0, extended: true);

  final List<String> routes = [
    AppRoutes.home,
    AppRoutes.settings,
    AppRoutes.help,
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
      extendedTheme: SidebarXTheme(
        width: MediaQuery.of(context).size.width > 600 ? 300 : 260,
      ),
      headerBuilder: (context, extended) {
        return Padding(
          padding: EdgeInsets.only(
            top: 30.0,
            bottom: GetPlatform.isWeb ? 15.0 : 0.0,
          ),
          child: _buildUserHeader(controller, extended),
        );
      },
      items: [
        SidebarXItem(
          icon: Icons.home_rounded,
          label: 'Home',
          onTap: () {
            Get.offAllNamed(AppRoutes.home);
            sidebarController.selectIndex(0);
          },
        ),
        SidebarXItem(
          icon: Icons.settings_applications,
          label: 'Configurações',
          onTap: () {
            Get.offAllNamed(AppRoutes.settings);
            sidebarController.selectIndex(1);
          },
        ),
        SidebarXItem(
          icon: Icons.help,
          label: 'Ajuda',
          onTap: () {
            Get.offAllNamed(AppRoutes.help);
            sidebarController.selectIndex(2);
          },
        ),
        SidebarXItem(
          icon: Icons.logout,
          label: 'Logout',
          onTap: () =>
              utilsService.showLogoutNotice(context, controller.signOut),
        ),
      ],
    );
  }

  Widget _buildUserHeader(SidebarController controller, bool extended) {
    return Obx(
      () {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 57, 15, 107),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildUserAvatar(controller, extended),
              if (extended) const SizedBox(width: 16),
              if (extended) _buildUserInfo(controller),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserAvatar(SidebarController controller, bool extended) {
    final double radius = extended ? 30 : 16;
    final double size = extended ? 60 : 32;
    final double iconSize = extended ? 48 : 24;

    return FutureBuilder<String?>(
      future: controller.getProfileImageUrl(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircleAvatar(
            radius: radius,
            backgroundColor: Colors.grey.shade200,
            child: const CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          return CircleAvatar(
            radius: radius,
            backgroundColor: Colors.grey.shade200,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: snapshot.data!,
                fit: BoxFit.cover,
                width: size,
                height: size,
                placeholder: (context, url) => const CircularProgressIndicator(
                  strokeWidth: 2.0,
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.person,
                  size: iconSize,
                  color: Colors.grey,
                ),
              ),
            ),
          );
        }

        return CircleAvatar(
          radius: radius,
          backgroundColor: Colors.grey.shade200,
          child: Icon(
            Icons.person,
            size: iconSize,
            color: Colors.grey,
          ),
        );
      },
    );
  }

  Widget _buildUserInfo(SidebarController controller) {
    return Column(
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
    );
  }
}
