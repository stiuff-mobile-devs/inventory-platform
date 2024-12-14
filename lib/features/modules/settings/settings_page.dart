import 'package:flutter/material.dart';
import 'package:inventory_platform/widgets/base_scaffold.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Padding(
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
            const ListTile(
              leading: Icon(Icons.language),
              title: Text('Alterar Idioma'),
              subtitle: Text('Escolha o idioma do aplicativo'),
              onTap: null,
            ),
            const ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notificações'),
              subtitle: Text('Gerenciar preferências de notificação'),
              onTap: null,
            ),
            const ListTile(
              leading: Icon(Icons.security),
              title: Text('Segurança'),
              subtitle: Text('Ajuste as configurações de segurança da conta'),
              onTap: null,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
