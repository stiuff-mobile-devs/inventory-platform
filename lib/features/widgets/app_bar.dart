import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inventory_platform/features/modules/home/home_controller.dart';
import 'package:inventory_platform/features/widgets/connection_status_icon.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final HomeController controller;

  const CustomAppBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SafeArea(
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            _buildAppBarContent(),
            _buildDrawerToggleButton(),
            _buildConnectionStateIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/icons/EnhancedAppIcon.svg',
          height: 42,
        ),
        const SizedBox(width: 5),
        const Text(
          'Inventário Universal',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 36, 36, 36),
            fontSize: 18.0,
          ),
        ),
      ],
    );
  }

  Widget _buildDrawerToggleButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Builder(
        builder: (BuildContext context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(
              Icons.list,
              size: 28,
              color: Colors.black,
            ),
          );
        },
      ),
    );
  }

  Widget _buildConnectionStateIcon() {
    return const ConnectionStatusIcon();
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
