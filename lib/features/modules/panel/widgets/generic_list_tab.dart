import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:inventory_platform/features/data/models/generic_list_item_model.dart';
import 'package:inventory_platform/features/data/models/organization_model.dart';
import 'package:inventory_platform/features/widgets/custom_progress_indicator.dart';
import 'package:inventory_platform/features/widgets/list_item_skeleton.dart';
import 'package:inventory_platform/features/widgets/temporary_message_display.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GenericListTab extends StatefulWidget {
  final List<GenericListItemModel> items;
  final String tabName;
  final String? searchParameters;

  const GenericListTab({
    super.key,
    this.searchParameters,
    required this.tabName,
    required this.items,
  });

  @override
  State<GenericListTab> createState() => _GenericListTabState();
}

class _GenericListTabState extends State<GenericListTab> {
  final OrganizationModel organization = Get.arguments;
  final TextEditingController _searchController = TextEditingController();
  final PagingController<int, GenericListItemModel> _pagingController =
      PagingController(firstPageKey: 0);
  List<GenericListItemModel> _allItemsList = [];
  List<GenericListItemModel> _filteredItemsList = [];

  int pageSize = 4;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) => _fetchPage(pageKey));
    _searchController.addListener(_filterInventories);
    _allItemsList = widget.items
      ..sort((a, b) => b.initialDate!.compareTo(a.initialDate!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (mounted) _pagingController.refresh();

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

  Future<void> _fetchPage(int pageKey) async {
    try {
      _allItemsList = widget.items
        ..sort((a, b) => b.initialDate!.compareTo(a.initialDate!));

      _filteredItemsList = List.from(_allItemsList);
      _updatePagingController(pageKey);
    } catch (error, stackTrace) {
      debugPrint('Error fetching page: $error');
      debugPrint('Stack trace: $stackTrace');
      if (mounted) {
        _pagingController.error = error;
      }
    }
  }

  void _updatePagingController(int pageKey) {
    final startIndex = pageKey * pageSize;
    final endIndex = startIndex + pageSize;

    final paginatedInventories = _filteredItemsList.sublist(
      startIndex,
      endIndex > _filteredItemsList.length
          ? _filteredItemsList.length
          : endIndex,
    );

    final isLastPage = endIndex >= _filteredItemsList.length;

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
      _filteredItemsList = _allItemsList.where((inventory) {
        return inventory.upperHeaderField.toLowerCase().contains(query) ||
            (inventory.id ?? ' ').toLowerCase().contains(query);
      }).toList();
    });
    _pagingController.itemList?.clear();
    _updatePagingController(0);
  }

  Future<void> _onRefresh() async {
    if (mounted) _pagingController.refresh();
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
              Text(
                widget.tabName,
                style: const TextStyle(
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
                    '${_allItemsList.length}',
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
            hintText: 'Pesquisar por ${widget.searchParameters ?? '...'}',
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

  Widget _buildInventoryCard(GenericListItemModel item) {
    final formattedOpenedAt = formatDate(item.initialDate);
    final formattedLastUpdatedAt = formatDate(item.lastUpdatedAt);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 4.0,
      color: Colors.white,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        title: Text(item.upperHeaderField,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.black87)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.lowerHeaderField,
                style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 4),
            Text('Aberto em: $formattedOpenedAt',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12.0)),
            Text('Atualizado em: $formattedLastUpdatedAt',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12.0))
          ],
        ),
        trailing: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              item.status == "open"
                  ? Icons.circle_outlined
                  : Icons.circle_outlined,
              color: item.status == "open" ? Colors.green : Colors.red,
              size: 20.0,
            ),
            Icon(
              item.status == "open" ? Icons.circle : Icons.circle,
              color: item.status == "open" ? Colors.green : Colors.red,
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

  Widget _buildInventoryList() {
    return Expanded(
      child: PagedListView<int, GenericListItemModel>(
        padding: const EdgeInsets.only(
            left: 16.0, right: 16.0, top: 16.0, bottom: 32.0),
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<GenericListItemModel>(
          itemBuilder: (context, inventory, index) {
            return _buildInventoryCard(inventory);
          },
          firstPageProgressIndicatorBuilder: (_) =>
              const CustomProgressIndicator(),
          newPageProgressIndicatorBuilder: (_) =>
              const Skeletonizer(child: ListItemSkeleton()),
          newPageErrorIndicatorBuilder: (_) => const TemporaryMessageDisplay(
              message: "Não foi possível carregar mais itens."),
          noMoreItemsIndicatorBuilder: (_) => const TemporaryMessageDisplay(
              message: "Não há mais itens para listar."),
          noItemsFoundIndicatorBuilder: (_) =>
              const TemporaryMessageDisplay(message: "Nenhum item encontrado."),
          firstPageErrorIndicatorBuilder: (_) => const TemporaryMessageDisplay(
              message: "Algo deu errado. Tente novamente."),
        ),
      ),
    );
  }
}
