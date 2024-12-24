import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/core/services/mock_service.dart';
import 'package:inventory_platform/features/data/models/organization_model.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:inventory_platform/features/modules/panel/widgets/custom_error_message.dart';
import 'package:inventory_platform/features/modules/panel/widgets/custom_progress_indicator.dart';
import 'package:inventory_platform/features/modules/panel/widgets/inventory_skeleton.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:inventory_platform/features/data/models/inventory_model.dart';
import 'package:intl/intl.dart';

class InventoryTab extends StatefulWidget {
  const InventoryTab({super.key});

  @override
  State<InventoryTab> createState() => _InventoryTabState();
}

class _InventoryTabState extends State<InventoryTab> {
  static const int pageSize = 4;
  final PagingController<int, InventoryModel> _pagingController =
      PagingController(firstPageKey: 0);
  final TextEditingController _searchController = TextEditingController();
  List<InventoryModel> _allInventories = [];
  List<InventoryModel> _filteredInventories = [];
  final OrganizationModel organization = Get.arguments;
  late final MockService mockService;

  final Map<String, bool> _groupExpansionState = {};

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
                'Meus Inventários',
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
            final monthYear =
                DateFormat('MMMM yyyy').format(inventory.openedAt!);
            return _buildInventoryGroup(inventory, monthYear, index);
          },
          firstPageProgressIndicatorBuilder: (_) =>
              const CustomProgressIndicator(),
          newPageProgressIndicatorBuilder: (_) =>
              const Skeletonizer(child: InventorySkeleton()),
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

  Widget _buildInventoryGroup(
      InventoryModel inventory, String monthYear, int index) {
    final isFirstItemInGroup = _isFirstItemInGroup(index, monthYear);
    final isLastItemInGroup = _isLastItemInGroup(index, monthYear);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isFirstItemInGroup) _buildMonthYearButton(monthYear),
        _buildInventoryItem(inventory, monthYear),
        if (isLastItemInGroup) const Divider(),
      ],
    );
  }

  bool _isFirstItemInGroup(int index, String monthYear) {
    return index == 0 ||
        DateFormat('MMMM yyyy')
                .format(_pagingController.itemList![index - 1].openedAt!) !=
            monthYear;
  }

  bool _isLastItemInGroup(int index, String monthYear) {
    return index == _pagingController.itemList!.length - 1 ||
        DateFormat('MMMM yyyy')
                .format(_pagingController.itemList![index + 1].openedAt!) !=
            monthYear;
  }

  Widget _buildMonthYearButton(String monthYear) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: const BorderSide(color: Colors.black12)),
        ),
        onPressed: () => _toggleGroupExpansionState(monthYear),
        child: Text(
          monthYear,
          style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87),
        ),
      ),
    );
  }

  void _toggleGroupExpansionState(String monthYear) {
    setState(() {
      _groupExpansionState[monthYear] =
          !_groupExpansionState.containsKey(monthYear) ||
              !_groupExpansionState[monthYear]!;
    });
  }

  Widget _buildInventoryItem(InventoryModel inventory, String monthYear) {
    final formattedOpenedAt = formatDate(inventory.openedAt);
    final formattedLastUpdatedAt = formatDate(inventory.lastUpdatedAt);
    final formattedClosedAt = formatDate(inventory.closedAt);

    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 300),
      firstChild: const Center(child: SizedBox.shrink()),
      secondChild: AnimatedOpacity(
        duration: const Duration(milliseconds: 0),
        opacity: _groupExpansionState[monthYear] == true ? 1.0 : 0.0,
        child: _buildInventoryCard(inventory, formattedOpenedAt,
            formattedLastUpdatedAt, formattedClosedAt),
      ),
      crossFadeState: _groupExpansionState[monthYear] == true
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
    );
  }

  Widget _buildInventoryCard(InventoryModel inventory, String formattedOpenedAt,
      String formattedLastUpdatedAt, String formattedClosedAt) {
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
            Text('Nº de revisão: ${inventory.revisionNumber}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12.0)),
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
