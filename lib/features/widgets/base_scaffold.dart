import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/core/theme/app_theme.dart';
import 'package:inventory_platform/features/modules/home/home_controller.dart';
import 'package:inventory_platform/features/widgets/app_bar.dart';
import 'package:inventory_platform/features/widgets/sidebar.dart';

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final bool showAppBar;

  const BaseScaffold({
    super.key,
    required this.body,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();

    return Scaffold(
      appBar: showAppBar ? CustomAppBar(controller: controller) : null,
      drawer: CustomSidebar(controller: controller),
      body: body,
      backgroundColor: globalTheme.scaffoldBackgroundColor,
    );
  }
}
