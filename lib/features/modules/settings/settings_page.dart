import 'package:flutter/material.dart';
import 'package:inventory_platform/core/services/utils_service.dart';
import 'package:inventory_platform/features/common/widgets/base_scaffold.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UtilsService utilsService = UtilsService();

    return BaseScaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Configurações do Aplicativo',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Aqui você pode ajustar as configurações do aplicativo conforme suas preferências.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Alterar Idioma'),
                subtitle: const Text('Escolha o idioma do aplicativo'),
                onTap: () => utilsService.showUnderDevelopmentNotice(context),
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notificações'),
                subtitle: const Text('Gerenciar preferências de notificação'),
                onTap: () => utilsService.showUnderDevelopmentNotice(context),
              ),
              ListTile(
                leading: const Icon(Icons.security),
                title: const Text('Segurança'),
                subtitle:
                    const Text('Ajuste as configurações de segurança da conta'),
                onTap: () => utilsService.showUnderDevelopmentNotice(context),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
