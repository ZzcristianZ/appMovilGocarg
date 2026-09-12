import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gocarg/config/theme/app_theme.dart';

class ThemeNotifier extends Notifier<AppTheme> {
  @override
  AppTheme build() => const AppTheme();

  void toggleDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, AppTheme>(
  ThemeNotifier.new,
);
