import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/core/services/utils_service.dart';
import 'package:inventory_platform/data/models/organization_model.dart';
import 'package:inventory_platform/data/repositories/organization_repository.dart';
import 'package:inventory_platform/features/common/controllers/carousel_section_controller.dart';

class HomeController extends GetxController {
  final CarouselSectionController carouselController =
      Get.find<CarouselSectionController>();
  final UtilsService _utilsService = UtilsService();
  final OrganizationRepository organizationRepository =
      Get.find<OrganizationRepository>();

  final RxList<OrganizationModel> organizations = <OrganizationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrganizations();
  }

  void fetchOrganizations() {
    organizations.assignAll(organizationRepository.getAllOrganizations());
  }

  void createOrganization(BuildContext context) {
    debugPrint("Criar um novo departamento");
    _utilsService.showUnderDevelopmentNotice(context);
  }

  void joinOrganization(BuildContext context) {
    debugPrint("Participar de um departamento");
    _utilsService.showUnderDevelopmentNotice(context);
  }
}
