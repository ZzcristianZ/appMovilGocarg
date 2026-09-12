import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gocarg/config/theme/app_colors.dart';

/// Rol elegido en la pantalla de selección de rol. Se lee en Login para
/// saber a qué dashboard entrar y qué acento de color usar.
class SelectedRoleNotifier extends Notifier<GoCargRole?> {
  @override
  GoCargRole? build() => null;

  void seleccionar(GoCargRole rol) => state = rol;
}

final selectedRoleProvider =
    NotifierProvider<SelectedRoleNotifier, GoCargRole?>(SelectedRoleNotifier.new);