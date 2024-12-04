import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_platform/features/theme/presentation/bloc/theme_bloc.dart';
import 'package:inventory_platform/features/theme/domain/usecases/toggle_theme_usecase.dart';

void main() {
  late ThemeBloc themeBloc;

  setUp(() {
    themeBloc = ThemeBloc(toggleThemeUseCase: ToggleThemeUseCase());
  });

  test('should emit ThemeChanged with new theme', () async {
    themeBloc.add(ToggleThemeEvent());
    await expectLater(
      themeBloc.stream,
      emitsInOrder([isA<ThemeChanged>()]),
    );
  });
}
