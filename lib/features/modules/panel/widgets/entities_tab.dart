import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:inventory_platform/core/services/mock_service.dart';
import 'package:inventory_platform/features/data/models/entity_model.dart';
import 'package:inventory_platform/features/data/models/organization_model.dart';
import 'package:inventory_platform/features/widgets/temporary_message_display.dart';
import 'package:inventory_platform/features/widgets/custom_progress_indicator.dart';
import 'package:inventory_platform/features/widgets/list_item_skeleton.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EntitiesTab extends StatefulWidget {
  const EntitiesTab({super.key});

  @override
  State<EntitiesTab> createState() => _EntitiesTabState();
}

class _EntitiesTabState extends State<EntitiesTab> {
  static const int pageSize = 4;
  final PagingController<int, EntityModel> _pagingController =
      PagingController(firstPageKey: 0);
  List<EntityModel> _allEntities = [];
  List<EntityModel> _filteredEntities = [];
  final OrganizationModel organization = Get.arguments;
  late final MockService mockService;

  final Map<String, bool> _groupExpansionState = {};

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) => _fetchPage(pageKey));
    mockService = Get.find<MockService>();
    _allEntities = mockService.getEntitiesForOrganization(organization.id)
      ..sort((a, b) => a.type.compareTo(b.type));
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      _allEntities = mockService.getEntitiesForOrganization(organization.id)
        ..sort((a, b) => a.type.compareTo(b.type));

      _filteredEntities = List.from(_allEntities);
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

    final paginatedEntities = _filteredEntities.sublist(
      startIndex,
      endIndex > _filteredEntities.length ? _filteredEntities.length : endIndex,
    );

    final isLastPage = endIndex >= _filteredEntities.length;

    if (mounted) {
      if (isLastPage) {
        _pagingController.appendLastPage(paginatedEntities);
      } else {
        _pagingController.appendPage(paginatedEntities, pageKey + 1);
      }
    }
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
          _buildEntityList(),
        ],
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
          const Text(
            'Entidades',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
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

  Widget _buildEntityList() {
    return Expanded(
      child: PagedListView<int, EntityModel>(
        padding: const EdgeInsets.only(
            left: 16.0, right: 16.0, top: 16.0, bottom: 32.0),
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<EntityModel>(
          itemBuilder: (context, entity, index) {
            final groupType = entity.type;
            return _buildEntityGroup(entity, groupType, index);
          },
          firstPageProgressIndicatorBuilder: (_) =>
              const CustomProgressIndicator(),
          newPageProgressIndicatorBuilder: (_) =>
              const Skeletonizer(child: ListItemSkeleton()),
          noItemsFoundIndicatorBuilder: (_) =>
              const TemporaryMessageDisplay(message: "Nenhum item encontrado."),
        ),
      ),
    );
  }

  Widget _buildEntityGroup(EntityModel entity, String groupType, int index) {
    final isFirstItemInGroup = _isFirstItemInGroup(index, groupType);
    final isLastItemInGroup = _isLastItemInGroup(index, groupType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isFirstItemInGroup) _buildGroupButton(groupType),
        _buildEntityItem(entity, groupType),
        if (isLastItemInGroup) const Divider(),
      ],
    );
  }

  bool _isFirstItemInGroup(int index, String groupType) {
    return index == 0 ||
        _pagingController.itemList![index - 1].type != groupType;
  }

  bool _isLastItemInGroup(int index, String groupType) {
    return index == _pagingController.itemList!.length - 1 ||
        _pagingController.itemList![index + 1].type != groupType;
  }

  Widget _buildGroupButton(String groupType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: const BorderSide(color: Colors.black12)),
          ),
          onPressed: () => _toggleGroupExpansionState(groupType),
          child: Text(
            groupType,
            style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
        ),
      ),
    );
  }

  void _toggleGroupExpansionState(String groupType) {
    setState(() {
      _groupExpansionState[groupType] =
          !_groupExpansionState.containsKey(groupType) ||
              !_groupExpansionState[groupType]!;
    });
  }

  Widget _buildEntityItem(EntityModel entity, String groupType) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 300),
      firstChild: const Center(child: SizedBox.shrink()),
      secondChild: AnimatedOpacity(
        duration: const Duration(milliseconds: 0),
        opacity: _groupExpansionState[groupType] == true ? 1.0 : 0.0,
        child: ListTile(
          title: Text(entity.name),
        ),
      ),
      crossFadeState: _groupExpansionState[groupType] == true
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
