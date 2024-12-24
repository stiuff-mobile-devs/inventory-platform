import 'package:flutter/material.dart';
import 'package:inventory_platform/features/modules/panel/widgets/admin_tab.dart';
import 'package:inventory_platform/features/modules/panel/widgets/dashboard_tab.dart';
import 'package:inventory_platform/features/modules/panel/widgets/domains_tab.dart';
import 'package:inventory_platform/features/modules/panel/widgets/entities_tab.dart';
import 'package:inventory_platform/features/modules/panel/widgets/inventories_tab.dart';
import 'package:inventory_platform/features/modules/panel/widgets/members_tab.dart';
import 'package:inventory_platform/features/modules/panel/widgets/readers_tab.dart';
import 'package:inventory_platform/features/modules/panel/widgets/tags_tab.dart';
import 'package:inventory_platform/features/widgets/base_scaffold.dart';
import 'package:inventory_platform/features/widgets/scrollable_bottom_nav_bar.dart';

class PanelPage extends StatefulWidget {
  const PanelPage({super.key});

  @override
  State<PanelPage> createState() => _PanelPageState();
}

class _PanelPageState extends State<PanelPage> {
  int _selectedTabIndex = 0;

  final List<Widget> _tabs = [
    const DashboardTab(),
    const InventoriesTab(),
    const DomainsTab(),
    const TagsTab(),
    const ReadersTab(),
    const MembersTab(),
    const EntitiesTab(),
    const AdminTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      hideTitle: true,
      showBackButton: true,
      body: Stack(
        children: [
          _tabs[_selectedTabIndex],
          Align(
            alignment: Alignment.bottomCenter,
            child: ScrollableBottomNavigationBar(
              onTabSelected: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              selectedTabIndex: _selectedTabIndex,
            ),
          ),
        ],
      ),
    );
  }
}
