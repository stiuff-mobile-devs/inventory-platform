import 'package:inventory_platform/data/models/domain_model.dart';

class DomainRepository {
  final List<DomainModel> _domains = [];

  List<DomainModel> getAllDomains() {
    return _domains;
  }

  DomainModel? getDomainById(String id) {
    return _domains.firstWhere((domain) => domain.id == id);
  }

  void addDomain(DomainModel domain) {
    _domains.add(domain);
  }

  void updateDomain(DomainModel updatedDomain) {
    final index =
        _domains.indexWhere((domain) => domain.id == updatedDomain.id);
    if (index != -1) {
      _domains[index] = updatedDomain;
    }
  }

  void deleteDomain(String id) {
    _domains.removeWhere((domain) => domain.id == id);
  }
}
