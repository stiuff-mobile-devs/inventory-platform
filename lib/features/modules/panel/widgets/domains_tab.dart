import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:inventory_platform/core/services/mock_service.dart';
import 'package:inventory_platform/features/data/models/domain_model.dart';
import 'package:inventory_platform/features/data/models/organization_model.dart';
import 'package:inventory_platform/features/modules/panel/widgets/custom_error_message.dart';
import 'package:inventory_platform/features/modules/panel/widgets/custom_progress_indicator.dart';
import 'package:inventory_platform/features/modules/panel/widgets/list_item_skeleton.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DomainsTab extends StatefulWidget {
  const DomainsTab({super.key});

  @override
  State<DomainsTab> createState() => _DomainsTabState();
}

class _DomainsTabState extends State<DomainsTab> {
  static const int pageSize = 4;
  final PagingController<int, DomainModel> _pagingController =
      PagingController(firstPageKey: 0);
  final TextEditingController _searchController = TextEditingController();
  List<DomainModel> _allDomains = [];
  List<DomainModel> _filteredDomains = [];
  final OrganizationModel organization = Get.arguments;
  late final MockService mockService;

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) => _fetchPage(pageKey));
    _searchController.addListener(_filterDomains);
    mockService = Get.find<MockService>();
    _allDomains = mockService.getDomainsForOrganization(organization.id)
      ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      _allDomains = mockService.getDomainsForOrganization(organization.id)
        ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

      _filteredDomains = List.from(_allDomains);
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

    final paginatedDomains = _filteredDomains.sublist(
      startIndex,
      endIndex > _filteredDomains.length ? _filteredDomains.length : endIndex,
    );

    final isLastPage = endIndex >= _filteredDomains.length;

    if (mounted) {
      if (isLastPage) {
        _pagingController.appendLastPage(paginatedDomains);
      } else {
        _pagingController.appendPage(paginatedDomains, pageKey + 1);
      }
    }
  }

  void _filterDomains() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredDomains = _allDomains.where((domain) {
        return domain.name.toLowerCase().contains(query) ||
            domain.id.toLowerCase().contains(query);
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
          _buildDomainList(),
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
                'Domínios',
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
                    '${_allDomains.length}',
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

  Widget _buildDomainList() {
    return Expanded(
      child: PagedListView<int, DomainModel>(
        padding: const EdgeInsets.only(
            left: 16.0, right: 16.0, top: 16.0, bottom: 32.0),
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<DomainModel>(
          itemBuilder: (context, domain, index) {
            return _buildDomainItem(domain, index);
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

  Widget _buildDomainItem(DomainModel domain, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 4.0,
      color: Colors.white,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        title: Text(domain.name,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.black87)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (domain.description != null)
              Text(domain.description!,
                  style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 4),
            Text('Criado em: ${formatDate(domain.createdAt)}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12.0)),
            Text('Atualizado em: ${formatDate(domain.lastUpdatedAt)}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12.0)),
          ],
        ),
        trailing: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              domain.status == "active"
                  ? Icons.circle_outlined
                  : Icons.circle_outlined,
              color: domain.status == "active" ? Colors.green : Colors.red,
              size: 20.0,
            ),
            Icon(
              domain.status == "active" ? Icons.circle : Icons.circle,
              color: domain.status == "active" ? Colors.green : Colors.red,
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
