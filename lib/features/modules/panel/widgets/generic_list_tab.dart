import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:inventory_platform/core/enums/tab_type_enum.dart';
import 'package:inventory_platform/data/models/generic_list_item_model.dart';
import 'package:inventory_platform/features/modules/panel/panel_controller.dart';
import 'package:inventory_platform/features/modules/panel/widgets/generic_list_header.dart';
import 'package:inventory_platform/features/modules/panel/widgets/generic_list_item_card.dart';
import 'package:inventory_platform/features/modules/panel/widgets/search_bar_widget.dart';
import 'package:inventory_platform/features/common/widgets/custom_progress_indicator.dart';
import 'package:inventory_platform/features/common/widgets/list_item_skeleton.dart';
import 'package:inventory_platform/features/common/widgets/temporary_message_display.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GenericListTab extends StatefulWidget {
  final TabType tabType;
  final String? searchParameters;
  final String? firstDetailFieldName;
  final String? secondDetailFieldName;

  const GenericListTab({
    super.key,
    this.searchParameters,
    this.firstDetailFieldName,
    this.secondDetailFieldName,
    required this.tabType,
  });

  @override
  State<GenericListTab> createState() => _GenericListTabState();
}

class _GenericListTabState extends State<GenericListTab> {
  final PanelController _panelController = Get.find<PanelController>();
  final TextEditingController _searchController = TextEditingController();

  int pageSize = 4;

  @override
  void initState() {
    super.initState();
    _panelController.filteredItems.value =
        _panelController.allTabItemsGeneralized;
    _panelController.pagingController.value
        .addPageRequestListener((pageKey) => _fetchPage(pageKey));
    _searchController.addListener(() => _filterItems(_searchController.text));
  }

  void _filterItems(String searchText) {
    _panelController.pagingController.value.refresh();
    _panelController.filterItems(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    _panelController.refreshItemsAndPaging();

    return Obx(
      () => RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: () async => _panelController.refreshItemsAndPaging(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GenericListHeader(
              tabType: widget.tabType,
            ),
            SearchBarWidget(
              searchController: _searchController,
              hintText: 'Pesquisar por ${widget.searchParameters ?? '...'}',
              onSearchTextChanged: (text) => _filterItems(text),
            ),
            _buildList(),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final startIndex = pageKey * pageSize;
      final endIndex = startIndex + pageSize;

      var paginatedItems = _panelController.filteredItems.sublist(
        startIndex,
        endIndex > _panelController.filteredItems.length
            ? _panelController.filteredItems.length
            : endIndex,
      );

      final isLastPage = endIndex >= _panelController.filteredItems.length;

      if (mounted) {
        if (isLastPage) {
          _panelController.pagingController.value
              .appendLastPage(paginatedItems);
        } else {
          _panelController.pagingController.value
              .appendPage(paginatedItems, pageKey + 1);
        }
      }
    } catch (error, stackTrace) {
      debugPrint('Error fetching page: $error');
      debugPrint('Stack trace: $stackTrace');
      if (mounted) {
        _panelController.pagingController.value.error = error;
      }
    }
  }

  Widget _buildList() {
    return Expanded(
      child: PagedListView<int, GenericListItemModel>(
        padding: const EdgeInsets.only(
            left: 16.0, right: 16.0, top: 16.0, bottom: 32.0),
        pagingController: _panelController.pagingController.value,
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
