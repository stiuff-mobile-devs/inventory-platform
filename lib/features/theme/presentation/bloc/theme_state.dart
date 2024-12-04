part of 'theme_bloc.dart';

abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object> get props => [];
}

class ThemeInitial extends ThemeState {
  final bool isDarkTheme;

  const ThemeInitial(this.isDarkTheme);

  @override
  List<Object> get props => [isDarkTheme];
}

class ThemeChanged extends ThemeState {
  final bool isDarkTheme;

  const ThemeChanged(this.isDarkTheme);

  @override
  List<Object> get props => [isDarkTheme];
}
