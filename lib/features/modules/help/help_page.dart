import 'package:flutter/material.dart';
import 'package:inventory_platform/features/common/widgets/base_scaffold.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:inventory_platform/core/debug/logger.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    const String wikiUrl =
        'https://github.com/stiuff-mobile-devs/inventory-platform/wiki/';

    Future<void> openWiki() async {
      final Uri uri = Uri.parse(wikiUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Logger.error('Não foi possível abrir a URL: $wikiUrl');
      }
    }

    return BaseScaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bem-vindo à Central de Ajuda!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Aqui você pode encontrar respostas para as perguntas mais frequentes e informações sobre como usar o aplicativo.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              const Text(
                'Dúvidas Frequentes:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const ListTile(
                leading: Icon(Icons.help_outline),
                title: Text('Como faço para criar uma conta?'),
                subtitle: Text(
                    'Você pode criar uma conta clicando no botão "Registrar-se" na tela inicial.'),
              ),
              const ListTile(
                leading: Icon(Icons.help_outline),
                title: Text('Esqueci minha senha, e agora?'),
                subtitle: Text(
                    'Clique no botão "Esqueci minha senha" na tela de login para redefinir sua senha.'),
              ),
              const ListTile(
                leading: Icon(Icons.help_outline),
                title: Text('Como entro em contato com o suporte?'),
                subtitle: Text(
                    'Você pode entrar em contato com o suporte enviando um e-mail para suporte@app.com.'),
              ),
              const SizedBox(height: 16),
              const Text(
                'Links Externos:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListTile(
                trailing: const Icon(Icons.open_in_new),
                title: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber),
                      SizedBox(width: 4.0),
                      Text(
                        'Manual do Usuário',
                      ),
                    ],
                  ),
                ),
                subtitle: const Text(
                    'Acesse a nossa Wiki no GitHub e obtenha mais instruções de uso.'),
                onTap: openWiki,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
