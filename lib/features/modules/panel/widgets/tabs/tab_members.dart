import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:inventory_platform/core/enums/tab_type_enum.dart';
import 'package:inventory_platform/core/services/utils_service.dart';
import 'package:inventory_platform/data/models/member_model.dart';
import 'package:inventory_platform/features/modules/panel/panel_controller.dart';
import 'package:inventory_platform/features/modules/panel/widgets/details_dialog.dart';
import 'package:inventory_platform/features/modules/panel/widgets/list_item_widget.dart';
import 'package:inventory_platform/features/modules/panel/widgets/search_bar_widget.dart';
import 'package:inventory_platform/features/common/widgets/temporary_message_display.dart';
import 'package:inventory_platform/routes/routes.dart';

class TabMembers extends StatefulWidget {
  const TabMembers({super.key});

  @override
  State<TabMembers> createState() => _TabMembersState();
}

class _TabMembersState extends State<TabMembers> {
  final _panelController = Get.find<PanelController>();
  final _utilsService = UtilsService();

  final FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _panelController.searchController.addListener(() {
      _filterMembers(_panelController.searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: Colors.white,
      onRefresh: _panelController.refreshPage,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SearchBarWidget(
            searchController: _panelController.searchController,
            hintText: 'Pesquisar por MAC Address',
            onSearchTextChanged: _filterMembers,
            focusNode: searchFocusNode,
          ),
          _buildList(),
        ],
      ),
    );
  }

  void _filterMembers(String query) {
    if (query.isEmpty) {
      _panelController
          .updateItemsBasedOnTab(_panelController.selectedTabIndex.value);
      return;
    }

    final filteredList = _panelController.members
        .where(
            (member) => member.id.toLowerCase().contains(query.toLowerCase()))
        .toList();

    _panelController.listedItems.assignAll(filteredList);
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleWithCount(),
          const SizedBox(height: 8),
          _buildOrganizationInfo(),
        ],
      ),
    );
  }

  Widget _buildTitleWithCount() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Membros',
          style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87),
        ),
        const SizedBox(width: 8),
        Obx(() => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                '${_panelController.listedItems.length}',
                style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            )),
      ],
    );
  }

  Widget _buildOrganizationInfo() {
    final organization = _panelController.getCurrentOrganization();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (organization != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: Colors.greenAccent.shade700,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Text(
              organization.title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        TextButton.icon(
          onPressed: () {
            _utilsService.showUnderDevelopmentNotice(context);
            // searchFocusNode.unfocus();
            // Get.toNamed(AppRoutes.form, arguments: [TabType.members]);
          },
          icon: const Icon(Icons.add),
          label: const Text('Adicionar Membro'),
          style: TextButton.styleFrom(foregroundColor: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildList() {
    return Expanded(
      child: Obx(() {
        final items = _panelController.listedItems;

        if (items.isEmpty) {
          return const TemporaryMessageDisplay(
            message: "Não há itens para serem listados.",
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          itemCount: items.isNotEmpty ? items.length + 1 : 0,
          itemBuilder: (context, index) {
            if (index == items.length) {
              return const TemporaryMessageDisplay(
                message: "Não há mais itens para serem listados.",
              );
            }

            if (items[index] is MemberModel) {
              MemberModel item = items[index];
              return ListItemWidget(
                attributes: {
                  'Nome': 'Name Unavailable',
                  'Email': 'Email Unavailable',
                  'Criado em': _utilsService.formatDate(item.createdAt),
                  'Visto em': _utilsService.formatDate(item.lastSeen),
                },
                isActive: item.isActive,
                icon: Icons.donut_large_rounded,
                onTap: (context) {
                  searchFocusNode.unfocus();
                  showDetailsDialog(
                    context,
                    {
                      'Nome': 'Name Unavailable',
                      'Email': 'Email Unavailable',
                      'Está Ativo?': item.isActive == 1 ? 'Sim' : 'Não',
                      'Data de Criação':
                          _utilsService.formatDate(item.createdAt),
                      'Visto pela Última Vez':
                          _utilsService.formatDate(item.lastSeen),
                    },
                    () async {
                      searchFocusNode.unfocus();
                      Navigator.of(context).pop();
                      await Get.toNamed(
                        AppRoutes.form,
                        arguments: [
                          _utilsService.tabIndexToEnum(
                              _panelController.selectedTabIndex.value),
                          _panelController.members
                              .firstWhere((e) => e.id == item.id),
                        ],
                      );
                    },
                  );
                },
              );
            }
            return null;
          },
        );
      }),
    );
  }
}
