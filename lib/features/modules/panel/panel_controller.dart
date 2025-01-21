import 'package:get/get.dart';
import 'package:inventory_platform/data/models/domain_model.dart';
import 'package:inventory_platform/data/models/generic_list_item_model.dart';
import 'package:inventory_platform/data/models/inventory_model.dart';
import 'package:inventory_platform/data/models/member_model.dart';
import 'package:inventory_platform/data/models/reader_model.dart';
import 'package:inventory_platform/data/models/tag_model.dart';
import 'package:inventory_platform/data/models/organization_model.dart';
import 'package:inventory_platform/data/repositories/organization_repository.dart';

class PanelController extends GetxController {
  final OrganizationRepository organizationRepository =
      Get.find<OrganizationRepository>();

  RxList<GenericListItemModel> organizations = <GenericListItemModel>[].obs;
  RxList<GenericListItemModel> entities = <GenericListItemModel>[].obs;
  RxList<GenericListItemModel> tags = <GenericListItemModel>[].obs;
  RxList<GenericListItemModel> domains = <GenericListItemModel>[].obs;
  RxList<GenericListItemModel> inventories = <GenericListItemModel>[].obs;
  RxList<GenericListItemModel> members = <GenericListItemModel>[].obs;
  RxList<GenericListItemModel> readers = <GenericListItemModel>[].obs;

  void updateItems(OrganizationModel organization) {
    final organizationId = organization.id;

    inventories.value = InventoryModel.turnAllIntoGenericListItemModel(
        organizationRepository.getInventoriesForOrganization(organizationId));

    domains.value = DomainModel.turnAllIntoGenericListItemModel(
        organizationRepository.getDomainsForOrganization(organizationId));

    tags.value = TagModel.turnIntoGenericListItemModel(
        organizationRepository.getTagsForOrganization(organizationId));

    readers.value = ReaderModel.turnAllIntoGenericListItemModel(
        organizationRepository.getReadersForOrganization(organizationId));

    members.value = MemberModel.turnAllIntoGenericListItemModel(
        organizationRepository.getMembersForOrganization(organizationId));
  }
}
