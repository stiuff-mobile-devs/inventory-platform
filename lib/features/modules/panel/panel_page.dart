import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/core/services/mock_service.dart';
import 'package:inventory_platform/features/data/models/domain_model.dart';
import 'package:inventory_platform/features/data/models/generic_list_item_model.dart';
import 'package:inventory_platform/features/data/models/inventory_model.dart';
import 'package:inventory_platform/features/data/models/member_model.dart';
import 'package:inventory_platform/features/data/models/organization_model.dart';
import 'package:inventory_platform/features/data/models/reader_model.dart';
import 'package:inventory_platform/features/data/models/tag_model.dart';
import 'package:inventory_platform/features/modules/panel/widgets/admin_tab.dart';
import 'package:inventory_platform/features/modules/panel/widgets/dashboard_tab.dart';
import 'package:inventory_platform/features/modules/panel/widgets/entities_tab.dart';
import 'package:inventory_platform/features/modules/panel/widgets/generic_list_tab.dart';
import 'package:inventory_platform/features/widgets/base_scaffold.dart';
import 'package:inventory_platform/features/widgets/scrollable_bottom_nav_bar.dart';

class PanelPage extends StatefulWidget {
  const PanelPage({super.key});

  @override
  State<PanelPage> createState() => _PanelPageState();
}

class _PanelPageState extends State<PanelPage> {
  int _selectedTabIndex = 0;
  late final MockService mockService;
  late final OrganizationModel organization;

  List<Widget> _tabs = [
    const DashboardTab(),
  ];

  @override
  void initState() {
    super.initState();

    organization = Get.arguments;

    mockService = Get.find<MockService>();

    List<GenericListItemModel> inventories =
        InventoryModel.turnAllIntoGenericListItemModel(
            mockService.getInventoriesForOrganization(organization.id));

    List<GenericListItemModel> domains =
        DomainModel.turnAllIntoGenericListItemModel(
            mockService.getDomainsForOrganization(organization.id));

    List<GenericListItemModel> tags = TagModel.turnIntoGenericListItemModel(
        mockService.getTagsForOrganization(organization.id));

    List<GenericListItemModel> readers =
        ReaderModel.turnAllIntoGenericListItemModel(
            mockService.getReadersForOrganization(organization.id));

    List<GenericListItemModel> members =
        MemberModel.turnAllIntoGenericListItemModel(
            mockService.getMembersForOrganization(organization.id));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabs = [
        const DashboardTab(),
        GenericListTab(
          tabName: 'Inventories',
          items: inventories,
          searchParameters: 'Título ou Id',
          firstDetailFieldName: 'Criado em',
          secondDetailFieldName: 'Última atualização em',
        ),
        GenericListTab(
          tabName: 'Domains',
          items: domains,
          searchParameters: 'Título ou Id',
          firstDetailFieldName: 'Criado em',
          secondDetailFieldName: 'Última atualização em',
        ),
        GenericListTab(
          tabName: 'Tags',
          items: tags,
          searchParameters: 'Serial ou Id',
          firstDetailFieldName: 'Criado em',
          secondDetailFieldName: 'Visto pela última vez em',
        ),
        GenericListTab(
          tabName: 'Readers',
          items: readers,
          searchParameters: 'Nome ou MAC',
          firstDetailFieldName: 'Criado em',
          secondDetailFieldName: 'Visto pela última vez em',
        ),
        GenericListTab(
          tabName: 'Members',
          items: members,
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
