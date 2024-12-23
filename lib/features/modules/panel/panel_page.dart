import 'package:flutter/material.dart';
import 'package:inventory_platform/features/modules/panel/widgets/dashboard_tab.dart';
import 'package:inventory_platform/features/modules/panel/widgets/inventory_tab.dart';
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
    const InventoryTab(),
    const Center(child: Text('Entities')),
    const Center(child: Text('Tags')),
    const Center(child: Text('Readers')),
    const Center(child: Text('Members')),
    const Center(child: Text('Info')),
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
