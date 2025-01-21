import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/core/enums/tab_type_enum.dart';
import 'package:inventory_platform/data/models/entity_model.dart';
import 'package:inventory_platform/data/models/organization_model.dart';
import 'package:inventory_platform/data/repositories/organization_repository.dart';
import 'package:inventory_platform/routes/routes.dart';

class EntitiesTab extends StatefulWidget {
  const EntitiesTab({super.key});

  @override
  State<EntitiesTab> createState() => _EntitiesTabState();
}

class _EntitiesTabState extends State<EntitiesTab> {
  List<EntityModel> _allEntities = [];
  final OrganizationModel organization = Get.arguments;

  final OrganizationRepository _organizationRepository =
      Get.find<OrganizationRepository>();

  final Map<String, bool> _groupExpansionState = {};

  @override
  void initState() {
    super.initState();
    _allEntities = _organizationRepository
        .getEntitiesForOrganization(organization.id)
      ..sort((a, b) => a.type.compareTo(b.type));
  }

  Future<void> _onRefresh() async {
    setState(() {
      _allEntities = _organizationRepository
          .getEntitiesForOrganization(organization.id)
        ..sort((a, b) => a.type.compareTo(b.type));
    });
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
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
              const SizedBox(width: 8.0),
              TextButton.icon(
                onPressed: () async {
                  await Get.toNamed(
                    AppRoutes.form,
                    arguments: [
                      TabType.entities,
                      organization,
                    ],
                  );
                  _onRefresh();
                },
                label: const Text('Adicionar Entidade'),
                icon: const Icon(Icons.add),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEntityList() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.only(
            left: 16.0, right: 16.0, top: 16.0, bottom: 32.0),
        itemCount: _allEntities.length,
        itemBuilder: (context, index) {
          final entity = _allEntities[index];
          final groupType = entity.type;
          return _buildEntityGroup(entity, groupType, index);
        },
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
    return index == 0 || _allEntities[index - 1].type != groupType;
  }

  bool _isLastItemInGroup(int index, String groupType) {
    return index == _allEntities.length - 1 ||
        _allEntities[index + 1].type != groupType;
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
          title: Text(entity.title),
        ),
      ),
      crossFadeState: _groupExpansionState[groupType] == true
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
    );
  }
}
