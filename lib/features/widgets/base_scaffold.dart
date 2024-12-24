import 'package:flutter/material.dart';
import 'package:inventory_platform/core/theme/app_theme.dart';
import 'package:inventory_platform/features/widgets/app_bar.dart';
import 'package:inventory_platform/features/widgets/sidebar.dart';

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final bool showAppBar;
  final bool? hideTitle;
  final bool? showBackButton;

  const BaseScaffold({
    super.key,
    this.hideTitle,
    required this.body,
    this.showAppBar = true,
    this.showBackButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? CustomAppBar(
              hideTitle: hideTitle,
              showBackButton: showBackButton,
            )
          : null,
      drawer: CustomSidebar(),
      body: body,
      backgroundColor: globalTheme.scaffoldBackgroundColor,
    );
  }
}
