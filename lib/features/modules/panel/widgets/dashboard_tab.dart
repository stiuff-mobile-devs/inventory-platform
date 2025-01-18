import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/core/services/mock_service.dart';
import 'package:inventory_platform/data/models/domain_model.dart';
import 'package:inventory_platform/data/models/inventory_model.dart';
import 'package:inventory_platform/data/models/member_model.dart';
import 'package:inventory_platform/data/models/organization_model.dart';
import 'package:inventory_platform/data/models/reader_model.dart';
import 'package:inventory_platform/data/models/tag_model.dart';
import 'package:inventory_platform/features/modules/panel/widgets/status_chart.dart';
import 'package:inventory_platform/features/modules/panel/widgets/update_chart.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  List<InventoryModel> _allInventories = [];
  List<DomainModel> _allDomains = [];
  List<TagModel> _allTags = [];
  List<ReaderModel> _allReaders = [];
  List<MemberModel> _allMembers = [];

  final OrganizationModel organization = Get.arguments;
  int _currentIndex = 0;

  Widget _buildHeader(OrganizationModel organization) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: 120,
              child: Image.asset(
                organization.imagePath!,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 16.0,
              left: 16.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dashboard',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 4.0,
                          color: Colors.black54,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                  ),
                  _buildOrganizationContainer(organization.title),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrganizationContainer(String organizationName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.greenAccent.shade700,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        organizationName,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCountersGrid() {
    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      child: GridView.count(
        padding: const EdgeInsets.all(16.0),
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildCard('Inventários', _allInventories.length,
              Icons.inventory_rounded, Colors.blueAccent),
          _buildCard('Domains', _allDomains.length, Icons.data_object,
              Colors.orangeAccent),
          _buildCard('Tags', _allTags.length, Icons.tag, Colors.purpleAccent),
          _buildCard('Readers', _allReaders.length, Icons.device_hub_rounded,
              Colors.tealAccent),
          _buildCard('Members', _allMembers.length, Icons.groups_rounded,
              Colors.redAccent),
        ],
      ),
    );
  }

  Widget _buildCard(String title, int count, IconData icon, Color color) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36.0, color: color),
            const SizedBox(height: 8.0),
            Text(
              count.toString(),
              style:
                  const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4.0),
            Text(
              title,
              style: const TextStyle(fontSize: 16.0, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mockService = Get.find<MockService>();
    _allInventories =
        mockService.getInventoriesForOrganization(organization.id);
    _allDomains = mockService.getDomainsForOrganization(organization.id);
    _allTags = mockService.getTagsForOrganization(organization.id);
    _allReaders = mockService.getReadersForOrganization(organization.id);
    _allMembers = mockService.getMembersForOrganization(organization.id);

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: ListView(
        children: [
          _buildHeader(organization),
          Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                CarouselSlider(
                  items: [
                    StatusChart(inventories: _allInventories),
                    UpdateChart(inventories: _allInventories),
                  ],
                  options: CarouselOptions(
                    height: 350.0,
                    initialPage: 0,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    2,
                    (index) => Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == index
                            ? Colors.blueAccent
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildCountersGrid(),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
