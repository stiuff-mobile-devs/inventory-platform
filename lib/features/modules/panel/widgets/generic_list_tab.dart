import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:inventory_platform/features/data/models/generic_list_item_model.dart';
import 'package:inventory_platform/features/data/models/organization_model.dart';
import 'package:inventory_platform/features/modules/panel/widgets/generic_list_header.dart';
import 'package:inventory_platform/features/modules/panel/widgets/generic_list_item_card.dart';
import 'package:inventory_platform/features/modules/panel/widgets/search_bar_widget.dart';
import 'package:inventory_platform/features/widgets/custom_progress_indicator.dart';
import 'package:inventory_platform/features/widgets/list_item_skeleton.dart';
import 'package:inventory_platform/features/widgets/temporary_message_display.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GenericListTab extends StatefulWidget {
  final List<GenericListItemModel> items;
  final String tabName;
  final String? searchParameters;
  final String? firstDetailFieldName;
  final String? secondDetailFieldName;

  const GenericListTab({
    super.key,
    this.searchParameters,
    this.firstDetailFieldName,
    this.secondDetailFieldName,
    required this.tabName,
    required this.items,
  });

  @override
  State<GenericListTab> createState() => _GenericListTabState();
}

class _GenericListTabState extends State<GenericListTab> {
  final OrganizationModel _organization = Get.arguments;
  final TextEditingController _searchController = TextEditingController();
  final PagingController<int, GenericListItemModel> _pagingController =
      PagingController(firstPageKey: 0);
  List<GenericListItemModel> _allItemsList = [];
  List<GenericListItemModel> _filteredItemsList = [];

  int pageSize = 4;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) => _fetchPage(pageKey));
    _searchController.addListener(_filterItems);
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
          GenericListHeader(
            tabName: widget.tabName,
            itemCount: _allItemsList.length,
            organizationName: _organization.title,
          ),
          SearchBarWidget(
            searchController: _searchController,
            hintText: 'Pesquisar por ${widget.searchParameters ?? '...'}',
          ),
          _buildList(),
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

    final paginatedItems = _filteredItemsList.sublist(
      startIndex,
      endIndex > _filteredItemsList.length
          ? _filteredItemsList.length
          : endIndex,
    );

    final isLastPage = endIndex >= _filteredItemsList.length;

    if (mounted) {
      if (isLastPage) {
        _pagingController.appendLastPage(paginatedItems);
      } else {
        _pagingController.appendPage(paginatedItems, pageKey + 1);
      }
    }
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItemsList = _allItemsList.where((item) {
        return item.upperHeaderField.toLowerCase().contains(query) ||
            (item.id ?? ' ').toLowerCase().contains(query);
      }).toList();
    });
    _pagingController.itemList?.clear();
    _updatePagingController(0);
  }

  Future<void> _onRefresh() async {
    if (mounted) _pagingController.refresh();
  }

  Widget _buildList() {
    return Expanded(
      child: PagedListView<int, GenericListItemModel>(
        padding: const EdgeInsets.only(
            left: 16.0, right: 16.0, top: 16.0, bottom: 32.0),
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<GenericListItemModel>(
          itemBuilder: (context, item, index) {
            return GenericListItemCard(
              item: item,
              firstDetailFieldName: widget.firstDetailFieldName ?? '',
              secondDetailFieldName: widget.secondDetailFieldName ?? '',
              key: ValueKey(item.id),
            );
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
