import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inventory_platform/features/widgets/connection_status_icon.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool? hideTitle;
  final bool? showBackButton;

  const CustomAppBar({super.key, this.hideTitle, this.showBackButton});

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
            if (showBackButton ?? false) _buildBackButton(context),
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
        Padding(
          padding: const EdgeInsets.only(left: 6.0),
          child: SvgPicture.asset(
            'assets/icons/EnhancedAppIcon.svg',
            height: 42,
          ),
        ),
        const SizedBox(width: 5),
        (hideTitle ?? false)
            ? const SizedBox.shrink()
            : const Text(
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

  Widget _buildBackButton(BuildContext context) {
    return Positioned(
      left: 45,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.keyboard_return,
            size: 28,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionStateIcon() {
    return const ConnectionStatusIcon();
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
