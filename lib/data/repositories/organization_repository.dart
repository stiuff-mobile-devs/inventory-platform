import 'package:inventory_platform/data/models/organization_model.dart';

class OrganizationRepository {
  final List<OrganizationModel> _organizations = [];

  List<OrganizationModel> getAllOrganizations() {
    return _organizations;
  }

  OrganizationModel? getOrganizationById(String id) {
    return _organizations.firstWhere((organization) => organization.id == id);
  }

  void addOrganization(OrganizationModel organization) {
    _organizations.add(organization);
  }

  void updateOrganization(OrganizationModel updatedOrganization) {
    final index = _organizations.indexWhere(
        (organization) => organization.id == updatedOrganization.id);
    if (index != -1) {
      _organizations[index] = updatedOrganization;
    }
  }

  void deleteOrganization(String id) {
    _organizations.removeWhere((organization) => organization.id == id);
  }
}
