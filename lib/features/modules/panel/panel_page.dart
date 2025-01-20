import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/core/enums/tab_type_enum.dart';
import 'package:inventory_platform/data/models/organization_model.dart';
import 'package:inventory_platform/features/modules/panel/panel_controller.dart';
import 'package:inventory_platform/features/modules/panel/widgets/admin_tab.dart';
import 'package:inventory_platform/features/modules/panel/widgets/dashboard_tab.dart';
import 'package:inventory_platform/features/modules/panel/widgets/entities_tab.dart';
import 'package:inventory_platform/features/modules/panel/widgets/generic_list_tab.dart';
import 'package:inventory_platform/features/common/widgets/base_scaffold.dart';
import 'package:inventory_platform/features/common/widgets/scrollable_bottom_nav_bar.dart';

class PanelPage extends StatefulWidget {
  const PanelPage({super.key});

  @override
  State<PanelPage> createState() => _PanelPageState();
}

class _PanelPageState extends State<PanelPage> {
  int _selectedTabIndex = 0;
  late final OrganizationModel organization;

  final PanelController _panelController = Get.find<PanelController>();

  List<Widget> _tabs = [
    const DashboardTab(),
  ];

  @override
  void initState() {
    super.initState();

    organization = Get.arguments;

    _panelController.updateItems(organization);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabs = [
        const DashboardTab(),
        GenericListTab(
          tabType: TabType.inventories,
          items: _panelController.inventories,
          searchParameters: 'Título ou Id',
          firstDetailFieldName: 'Criado em',
          secondDetailFieldName: 'Última atualização em',
        ),
        GenericListTab(
          tabType: TabType.domains,
          items: _panelController.domains,
          searchParameters: 'Título ou Id',
          firstDetailFieldName: 'Criado em',
          secondDetailFieldName: 'Última atualização em',
        ),
        GenericListTab(
          tabType: TabType.tags,
          items: _panelController.tags,
          searchParameters: 'Serial ou Id',
          firstDetailFieldName: 'Criado em',
          secondDetailFieldName: 'Visto pela última vez em',
        ),
        GenericListTab(
          tabType: TabType.readers,
          items: _panelController.readers,
          searchParameters: 'Nome ou MAC',
          firstDetailFieldName: 'Criado em',
          secondDetailFieldName: 'Visto pela última vez em',
        ),
        GenericListTab(
          tabType: TabType.members,
          items: _panelController.members,
          searchParameters: 'Nome ou Email',
          firstDetailFieldName: 'Criado em',
          secondDetailFieldName: 'Visto pela última vez em',
        ),
        const EntitiesTab(),
        const AdminTab(),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PanelController>(
      builder: (_) {
        _panelController.updateItems(organization);
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
      },
    );
  }
}
