import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_platform/features/theme/domain/usecases/toggle_theme_usecase.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ToggleThemeUseCase toggleThemeUseCase;

  ThemeBloc({required this.toggleThemeUseCase})
      : super(const ThemeInitial(false)) {
    on<ToggleThemeEvent>((event, emit) {
      bool currentThemeIsDark;

      if (state is ThemeChanged) {
        currentThemeIsDark = (state as ThemeChanged).isDarkTheme;
      } else {
        currentThemeIsDark = false;
      }

      final newTheme = toggleThemeUseCase(currentThemeIsDark);
      emit(ThemeChanged(newTheme.isDarkTheme));
    });
  }
}
