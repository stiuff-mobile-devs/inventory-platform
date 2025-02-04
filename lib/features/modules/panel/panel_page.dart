import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/features/modules/panel/panel_controller.dart';
import 'package:inventory_platform/features/modules/panel/widgets/tabs/tab_admin.dart';
import 'package:inventory_platform/features/modules/panel/widgets/tabs/tab_dashboard.dart';
import 'package:inventory_platform/features/modules/panel/widgets/tabs/tab_domains.dart';
import 'package:inventory_platform/features/modules/panel/widgets/tabs/tab_entities.dart';
import 'package:inventory_platform/features/modules/panel/widgets/tabs/tab_inventories.dart';
import 'package:inventory_platform/features/common/widgets/base_scaffold.dart';
import 'package:inventory_platform/features/common/widgets/scrollable_bottom_nav_bar.dart';
import 'package:inventory_platform/features/modules/panel/widgets/tabs/tab_members.dart';
import 'package:inventory_platform/features/modules/panel/widgets/tabs/tab_readers.dart';
import 'package:inventory_platform/features/modules/panel/widgets/tabs/tab_tags.dart';

class PanelPage extends StatefulWidget {
  const PanelPage({super.key});

  @override
  State<PanelPage> createState() => _PanelPageState();
}

class _PanelPageState extends State<PanelPage> {
  late final PanelController _panelController;

  List<Widget> _tabs = [
    const DashboardTab(),
  ];

  @override
  void initState() {
    super.initState();

    _panelController = Get.find<PanelController>();

    _panelController.setCurrentOrganization(Get.arguments);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabs = [
        const DashboardTab(),
        const TabInventories(),
        const TabDomains(),
        const TabTags(),
        const TabReaders(),
        const TabMembers(),
        const EntitiesTab(),
        const AdminTab(),
      ];
    });

    _panelController.refreshItemsForTab();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: GetBuilder<PanelController>(
        builder: (_) {
          return BaseScaffold(
            hideTitle: true,
            showBackButton: true,
            body: Stack(
              children: [
                Obx(
                  () => _tabs[_panelController.selectedTabIndex.value],
                ),
                Obx(
                  () => Align(
                    alignment: Alignment.bottomCenter,
                    child: ScrollableBottomNavigationBar(
                      onTabSelected: (index) {
                        _panelController.selectedTabIndex.value = index;
                      },
                      selectedTabIndex: _panelController.selectedTabIndex.value,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
