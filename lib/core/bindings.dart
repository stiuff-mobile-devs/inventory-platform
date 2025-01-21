import 'package:get/get.dart';
import 'package:inventory_platform/core/services/auth_service.dart';
import 'package:inventory_platform/core/services/connection_service.dart';
import 'package:inventory_platform/core/services/error_service.dart';
import 'package:inventory_platform/core/services/warning_service.dart';
import 'package:inventory_platform/data/repositories/domain_repository.dart';
import 'package:inventory_platform/data/repositories/entity_repository.dart';
import 'package:inventory_platform/data/repositories/inventory_repository.dart';
import 'package:inventory_platform/data/repositories/material_repository.dart';
import 'package:inventory_platform/data/repositories/member_repository.dart';
import 'package:inventory_platform/data/repositories/organization_repository.dart';
import 'package:inventory_platform/data/repositories/reader_repository.dart';
import 'package:inventory_platform/data/repositories/tag_repository.dart';
import 'package:inventory_platform/data/repositories/user_repository.dart';
import 'package:inventory_platform/features/common/controllers/connection_controller.dart';
import 'package:inventory_platform/features/common/controllers/sidebar_controller.dart';
import 'package:inventory_platform/core/services/mock_service.dart';

class CoreBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<ConnectionService>(ConnectionService());
    Get.put<ErrorService>(ErrorService());
    Get.put<WarningService>(WarningService());

    Get.put<MemberRepository>(MemberRepository());
    Get.put<DomainRepository>(DomainRepository());
    Get.put<EntityRepository>(EntityRepository());
    Get.put<InventoryRepository>(InventoryRepository());
    Get.put<MaterialRepository>(MaterialRepository());
    Get.put<ReaderRepository>(ReaderRepository());
    Get.put<TagRepository>(TagRepository());
    Get.put<UserRepository>(UserRepository());

    Get.put<OrganizationRepository>(OrganizationRepository());

    Get.put<AuthService>(AuthService());

    Get.put<ConnectionController>(ConnectionController());
    Get.put<SidebarController>(SidebarController());

    Get.put<MockService>(
      MockService(
        organizationRepository: Get.find<OrganizationRepository>(),
      ),
    );
  }
}
