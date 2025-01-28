import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/core/enums/tab_type_enum.dart';
import 'package:inventory_platform/data/models/generic_list_item_model.dart';
import 'package:inventory_platform/core/services/utils_service.dart';
import 'package:inventory_platform/features/modules/panel/panel_controller.dart';
import 'package:inventory_platform/routes/routes.dart';

class DetailsDialog extends StatelessWidget {
  final GenericListItemModel item;
  final UtilsService _utilsService = UtilsService();
  final PanelController _panelController = Get.find<PanelController>();

  DetailsDialog({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(0.0),
          bottomLeft: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0),
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item.upperHeaderField,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (item.lowerHeaderField != null)
                    _buildReadOnlyField('Subtítulo', item.lowerHeaderField!),
                  _buildReadOnlyField(
                    'Ativo',
                    item.isActive == 1 ? 'Sim' : 'Não',
                  ),
                  _buildReadOnlyField(
                    'Criado em',
                    _utilsService.formatDate(item.initialDate),
                  ),
                  _buildReadOnlyField(
                    _panelController.selectedTabIndex.value == 3 ||
                            _panelController.selectedTabIndex.value == 4
                        ? 'Visto pela última vez em'
                        : 'Última atualização',
                    _utilsService.formatDate(item.lastUpdatedAt),
                  ),
                  const SizedBox(height: 8.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _panelController.selectedTabIndex.value == 1
                          ? ElevatedButton.icon(
                              onPressed: () => {
                                _utilsService
                                    .showUnderDevelopmentNotice(context),
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              label: const Text('Itens do Inventário'),
                              icon:
                                  const Icon(Icons.format_list_bulleted_sharp),
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(width: 16.0),
                      TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop();

                          await Get.toNamed(
                            AppRoutes.form,
                            arguments: [
                              _utilsService.tabIndexToEnum(
                                  _panelController.selectedTabIndex.value),
                              () {
                                switch (_utilsService.tabIndexToEnum(
                                    _panelController.selectedTabIndex.value)) {
                                  case TabType.inventories:
                                    debugPrint("HERE I AM!");
                                    return _panelController.inventories
                                        .firstWhere(
                                            (item) => item.id == this.item.id);
                                  case TabType.domains:
                                    return _panelController.domains.firstWhere(
                                        (item) => item.id == this.item.id);
                                  case TabType.tags:
                                    return _panelController.tags.firstWhere(
                                        (item) => item.id == this.item.id);
                                  case TabType.readers:
                                    return _panelController.readers.firstWhere(
                                        (item) => item.mac == this.item.id);
                                  case TabType.members:
                                    return _panelController.members.firstWhere(
                                        (item) => item.id == this.item.id);
                                  default:
                                    return null;
                                }
                              }(),
                            ],
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Ver Detalhes | Editar Informações'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: -4.0,
            right: 0.0,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 6.0),
              child: ElevatedButton(
                onPressed: () => {
                  Navigator.of(context).pop(),
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0.0),
                      topRight: Radius.circular(0.0),
                      bottomLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(0.0),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 4.0),
                  minimumSize: const Size(32, 32),
                ),
                child: const Text(
                  'X',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black.withOpacity(0.1)),
            ),
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

void showDetailsDialog(BuildContext context, GenericListItemModel item) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return DetailsDialog(item: item);
    },
  );
}
