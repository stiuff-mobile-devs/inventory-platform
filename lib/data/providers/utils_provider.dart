import 'package:inventory_platform/core/enums/tab_type_enum.dart';

class UtilsProvider {
  Future<void> retryWithExponentialBackoff(
      Future<void> Function() action) async {
    const int maxRetries = 5;
    int retryCount = 0;
    int delay = 1000;

    while (retryCount < maxRetries) {
      try {
        await action();
        return;
      } catch (e) {
        retryCount++;
        if (retryCount >= maxRetries) rethrow;
        await Future.delayed(Duration(milliseconds: delay));
        delay *= 2;
      }
    }
  }

  String tabName(TabType tab) {
    switch (tab) {
      case TabType.inventories:
        return 'Inventários';
      case TabType.domains:
        return 'Domínios';
      case TabType.tags:
        return 'Tags';
      case TabType.readers:
        return 'Leitores';
      case TabType.members:
        return 'Membros';
      default:
        return tab.toString();
    }
  }

  String tabNameToSingular(TabType tab) {
    switch (tab) {
      case TabType.inventories:
        return 'Inventário';
      case TabType.domains:
        return 'Domínio';
      case TabType.tags:
        return 'Tag';
      case TabType.readers:
        return 'Leitor';
      case TabType.members:
        return 'Membro';
      default:
        return tab.toString();
    }
  }
}
