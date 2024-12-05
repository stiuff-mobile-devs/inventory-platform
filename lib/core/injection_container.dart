import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Registrar serviços compartilhados ou globais aqui
  // Por exemplo, shared_preferences ou serviços de rede
  // sl.registerLazySingleton<YourService>(() => YourServiceImplementation());
}
