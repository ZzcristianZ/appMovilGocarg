import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gocarg/config/theme/app_theme.dart';

class ThemeNotifier extends Notifier<AppTheme> {
  @override
  AppTheme build() => AppTheme();

  void toggleDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }

  void changeColor(int colorIndex) {
    state = state.copyWith(selectedColor: colorIndex);
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, AppTheme>(
  ThemeNotifier.new,
);