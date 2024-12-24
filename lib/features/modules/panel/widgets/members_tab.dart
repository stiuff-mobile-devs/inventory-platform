import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:inventory_platform/core/services/mock_service.dart';
import 'package:inventory_platform/features/data/models/member_model.dart';
import 'package:inventory_platform/features/data/models/organization_model.dart';
import 'package:inventory_platform/features/modules/panel/widgets/custom_error_message.dart';
import 'package:inventory_platform/features/modules/panel/widgets/custom_progress_indicator.dart';
import 'package:inventory_platform/features/modules/panel/widgets/list_item_skeleton.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MembersTab extends StatefulWidget {
  const MembersTab({super.key});

  @override
  State<MembersTab> createState() => _MembersTabState();
}

class _MembersTabState extends State<MembersTab> {
  static const int pageSize = 4;
  final PagingController<int, MemberModel> _pagingController =
      PagingController(firstPageKey: 0);
  final TextEditingController _searchController = TextEditingController();
  List<MemberModel> _allMembers = [];
  List<MemberModel> _filteredMembers = [];
  final OrganizationModel organization = Get.arguments;
  late final MockService mockService;

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) => _fetchPage(pageKey));
    _searchController.addListener(_filterMembers);
    mockService = Get.find<MockService>();
    _allMembers = mockService.getMembersForOrganization(organization.id)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      _allMembers = mockService.getMembersForOrganization(organization.id)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      _filteredMembers = List.from(_allMembers);
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

    final paginatedMembers = _filteredMembers.sublist(
      startIndex,
      endIndex > _filteredMembers.length ? _filteredMembers.length : endIndex,
    );

    final isLastPage = endIndex >= _filteredMembers.length;

    if (mounted) {
      if (isLastPage) {
        _pagingController.appendLastPage(paginatedMembers);
      } else {
        _pagingController.appendPage(paginatedMembers, pageKey + 1);
      }
    }
  }

  void _filterMembers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMembers = _allMembers.where((member) {
        return member.name.toLowerCase().contains(query) ||
            member.email.toLowerCase().contains(query);
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
          _buildMemberList(),
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
            hintText: 'Pesquisar por Nome ou Email',
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
                'Membros',
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
                    '${_allMembers.length}',
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

  Widget _buildMemberList() {
    return Expanded(
      child: PagedListView<int, MemberModel>(
        padding: const EdgeInsets.only(
            left: 16.0, right: 16.0, top: 16.0, bottom: 32.0),
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<MemberModel>(
          itemBuilder: (context, member, index) {
            return _buildMemberItem(member, index);
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

  Widget _buildMemberItem(MemberModel member, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 4.0,
      color: Colors.white,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        title: Text(member.name,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.black87)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Criado em: ${formatDate(member.createdAt)}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12.0)),
            Text('Status: ${member.status}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12.0)),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  String formatDate(DateTime date) {
    return DateFormat.yMMMMd().add_Hms().format(date);
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
