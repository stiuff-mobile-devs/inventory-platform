import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/core/enums/tab_type_enum.dart';
import 'package:inventory_platform/core/services/utils_service.dart';
import 'package:inventory_platform/features/modules/panel/panel_controller.dart';
import 'package:inventory_platform/routes/routes.dart';

class GenericListHeader extends StatelessWidget {
  final TabType tabType;
  final UtilsService _utilsService;
  final PanelController _panelController;

  GenericListHeader({
    super.key,
    required this.tabType,
  })  : _utilsService = UtilsService(),
        _panelController = Get.find<PanelController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 16.0, right: 16.0, top: 20.0, bottom: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _utilsService.tabName(tabType),
                style: const TextStyle(
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
                  child: Obx(
                    () => Text(
                      '${_panelController.allTabItemsGeneralized.length}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
                  _panelController.getCurrentOrganization().title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              TextButton.icon(
                onPressed: () async {
                  if (tabType != TabType.members) {
                    await Get.toNamed(
                      AppRoutes.form,
                      arguments: [
                        tabType,
                      ],
                    );
                  } else {
                    _utilsService.showUnderDevelopmentNotice(context);
                  }
                },
                label: Text(
                    'Adicionar ${_utilsService.tabNameToSingular(tabType)}'),
                icon: const Icon(Icons.add),
                style: TextButton.styleFrom(
                  foregroundColor:
                      (tabType != TabType.members) ? Colors.blue : Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
