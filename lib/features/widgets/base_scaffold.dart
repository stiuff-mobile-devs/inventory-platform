import 'package:flutter/material.dart';
import 'package:inventory_platform/core/theme/app_theme.dart';
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
    return Scaffold(
      appBar: showAppBar ? const CustomAppBar() : null,
      drawer: CustomSidebar(),
      body: body,
      backgroundColor: globalTheme.scaffoldBackgroundColor,
    );
  }
}
