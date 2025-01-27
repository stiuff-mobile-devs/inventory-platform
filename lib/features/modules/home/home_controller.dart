import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/data/models/organization_model.dart';
import 'package:inventory_platform/data/repositories/organization_repository.dart';
import 'package:inventory_platform/features/common/controllers/carousel_section_controller.dart';

class HomeController extends GetxController {
  final CarouselSectionController carouselController = Get.find();
  final OrganizationRepository organizationRepository = Get.find();

  final RxList<OrganizationModel> organizations = <OrganizationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrganizations();
  }

  void fetchOrganizations() {
    organizations.assignAll(organizationRepository.getAllOrganizations());
  }

  void createOrganization() {
    debugPrint("Criar uma nova organização");
  }

  void joinOrganization() {
    debugPrint("Participar de uma organização");
  }
}
