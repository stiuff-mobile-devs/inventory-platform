import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/core/services/mock_service.dart';
import 'package:inventory_platform/features/data/models/organization_model.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:inventory_platform/features/modules/panel/widgets/custom_error_message.dart';
import 'package:inventory_platform/features/modules/panel/widgets/custom_progress_indicator.dart';
import 'package:inventory_platform/features/modules/panel/widgets/list_item_skeleton.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:inventory_platform/features/data/models/inventory_model.dart';
import 'package:intl/intl.dart';

class InventoriesTab extends StatefulWidget {
  const InventoriesTab({super.key});

  @override
  State<InventoriesTab> createState() => _InventoriesTabState();
}

class _InventoriesTabState extends State<InventoriesTab> {
  static const int pageSize = 4;
  final PagingController<int, InventoryModel> _pagingController =
      PagingController(firstPageKey: 0);
  final TextEditingController _searchController = TextEditingController();
  List<InventoryModel> _allInventories = [];
  List<InventoryModel> _filteredInventories = [];
  final OrganizationModel organization = Get.arguments;
  late final MockService mockService;

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) => _fetchPage(pageKey));
    _searchController.addListener(_filterInventories);
    mockService = Get.find<MockService>();
    _allInventories = mockService.getInventoriesForOrganization(organization.id)
      ..sort((a, b) => b.openedAt!.compareTo(a.openedAt!));
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      _allInventories = mockService
          .getInventoriesForOrganization(organization.id)
        ..sort((a, b) => b.openedAt!.compareTo(a.openedAt!));

      _filteredInventories = List.from(_allInventories);
      _updatePagingController(pageKey);
    } catch (error) {
      if (mounted) {
        _pagingController.error = error;
      }
    }
  }

  void _updatePagingController(int pageKey) {
    final startIndex = pageKey * pageSize;
    final endIndex = startIndex + pageSize;

    final paginatedInventories = _filteredInventories.sublist(
      startIndex,
      endIndex > _filteredInventories.length
          ? _filteredInventories.length
          : endIndex,
    );

    final isLastPage = endIndex >= _filteredInventories.length;

    if (mounted) {
      if (isLastPage) {
        _pagingController.appendLastPage(paginatedInventories);
      } else {
        _pagingController.appendPage(paginatedInventories, pageKey + 1);
      }
    }
  }

  void _filterInventories() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredInventories = _allInventories.where((inventory) {
        return inventory.title.toLowerCase().contains(query) ||
            inventory.id.toLowerCase().contains(query);
      }).toList();
    });
    _pagingController.itemList?.clear();
    _updatePagingController(0);
  }

  Future<void> _onRefresh() async {
    if (mounted) _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: Colors.white,
      onRefresh: _onRefresh,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(organization.title),
          _buildSearchBar(),
          _buildInventoryList(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(fontSize: 16.0),
          cursorColor: Colors.black87,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
            hintText: 'Pesquisar por Nome ou Id',
            hintStyle: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 16.0,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.black54,
            ),
            filled: true,
            fillColor: Colors.transparent,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: Colors.black.withOpacity(0.2),
                width: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String organizationName) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 16.0, right: 16.0, top: 20.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Inventários',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(121, 158, 158, 158),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Text(
                    '${_allInventories.length}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: Colors.greenAccent.shade700,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Text(
                organizationName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryList() {
    return Expanded(
      child: PagedListView<int, InventoryModel>(
        padding: const EdgeInsets.only(
            left: 16.0, right: 16.0, top: 16.0, bottom: 32.0),
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<InventoryModel>(
          itemBuilder: (context, inventory, index) {
            return _buildInventoryCard(inventory);
          },
          firstPageProgressIndicatorBuilder: (_) =>
              const CustomProgressIndicator(),
          newPageProgressIndicatorBuilder: (_) =>
              const Skeletonizer(child: ListItemSkeleton()),
          newPageErrorIndicatorBuilder: (_) => const CustomErrorMessage(
              message: "Não foi possível carregar mais itens."),
          noMoreItemsIndicatorBuilder: (_) => const CustomErrorMessage(
              message: "Não há mais itens para listar."),
          noItemsFoundIndicatorBuilder: (_) =>
              const CustomErrorMessage(message: "Nenhum item encontrado."),
          firstPageErrorIndicatorBuilder: (_) => const CustomErrorMessage(
              message: "Algo deu errado. Tente novamente."),
        ),
      ),
    );
  }

  Widget _buildInventoryCard(InventoryModel inventory) {
    final formattedOpenedAt = formatDate(inventory.openedAt);
    final formattedLastUpdatedAt = formatDate(inventory.lastUpdatedAt);
    final formattedClosedAt = formatDate(inventory.closedAt);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 4.0,
      color: Colors.white,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        title: Text(inventory.title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.black87)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(inventory.description,
                style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 4),
            Text('Aberto em: $formattedOpenedAt',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12.0)),
            !(inventory.closedAt != null)
                ? Text('Atualizado em: $formattedLastUpdatedAt',
                    style:
                        TextStyle(color: Colors.grey.shade600, fontSize: 12.0))
                : Text('Fechado em: $formattedClosedAt',
                    style:
                        TextStyle(color: Colors.grey.shade600, fontSize: 12.0)),
          ],
        ),
        trailing: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              inventory.status == "open"
                  ? Icons.circle_outlined
                  : Icons.circle_outlined,
              color: inventory.status == "open" ? Colors.green : Colors.red,
              size: 20.0,
            ),
            Icon(
              inventory.status == "open" ? Icons.circle : Icons.circle,
              color: inventory.status == "open" ? Colors.green : Colors.red,
              size: 12.0,
            ),
          ],
        ),
      ),
    );
  }

  String formatDate(DateTime? date) {
    return date != null
        ? DateFormat.yMMMMd().format(date)
        : "Data Indisponível";
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
