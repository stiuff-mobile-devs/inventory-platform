import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:inventory_platform/core/enums/tab_type_enum.dart';
import 'package:inventory_platform/features/common/widgets/warning_message.dart';

class UtilsService {
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

  String formatDate(DateTime? date) {
    return date != null
        ? DateFormat.yMMMMd().format(date)
        : "Data Indisponível";
  }

  bool emailRegexMatch(String email) {
    final RegExp regex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    return regex.hasMatch(email);
  }

  String tabEnumToString(TabType tab) {
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
      case TabType.entities:
        return 'Entidades';
      default:
        return tab.toString();
    }
  }

  TabType tabIndexToEnum(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return TabType.dashboard;
      case 1:
        return TabType.inventories;
      case 2:
        return TabType.domains;
      case 3:
        return TabType.tags;
      case 4:
        return TabType.readers;
      case 5:
        return TabType.members;
      case 6:
        return TabType.entities;
      case 7:
        return TabType.admin;
      default:
        return TabType.unknown;
    }
  }

  String tabNameToSingular(TabType tab) {
    switch (tab) {
      case TabType.dashboard:
        return 'Dashboard';
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
      case TabType.entities:
        return 'Entidade';
      case TabType.admin:
        return 'Painel do Administrador';
      default:
        return tab.toString();
    }
  }

  void showUnderDevelopmentNotice(BuildContext context) {
    showWarningDialog(
      context: context,
      title: 'Aviso',
      message: 'Ops! Esta função ainda não está disponível.',
      onConfirm: () {
        Navigator.of(context).pop();
      },
      onCancel: () {
        Navigator.of(context).pop();
      },
    );
  }

  void showLogoutNotice(BuildContext context, void Function() action) {
    showWarningDialog(
      context: context,
      title: 'Logout',
      message: 'Você deseja mesmo sair desta conta?',
      hasOnConfirm: true,
      onConfirm: () => action(),
      onCancel: () {
        Navigator.of(context).pop();
      },
    );
  }
}
