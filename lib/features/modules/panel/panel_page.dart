import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/core/enums/tab_type_enum.dart';
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
  final PanelController _panelController = Get.find<PanelController>();

  List<Widget> _tabs = [
    const DashboardTab(),
  ];

  @override
  void initState() {
    super.initState();

    _panelController.setCurrentOrganization(Get.arguments);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabs = [
        const DashboardTab(),
        const GenericListTab(
          tabType: TabType.inventories,
          searchParameters: 'Título ou Id',
          firstDetailFieldName: 'Criado em',
          secondDetailFieldName: 'Última atualização em',
        ),
        const GenericListTab(
          tabType: TabType.domains,
          searchParameters: 'Título ou Id',
          firstDetailFieldName: 'Criado em',
          secondDetailFieldName: 'Última atualização em',
        ),
        const GenericListTab(
          tabType: TabType.tags,
          searchParameters: 'Serial ou Id',
          firstDetailFieldName: 'Criado em',
          secondDetailFieldName: 'Visto pela última vez em',
        ),
        const GenericListTab(
          tabType: TabType.readers,
          searchParameters: 'Nome ou MAC',
          firstDetailFieldName: 'Criado em',
          secondDetailFieldName: 'Visto pela última vez em',
        ),
        const GenericListTab(
          tabType: TabType.members,
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
        _panelController.refreshItems();
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
    );
  }
}
