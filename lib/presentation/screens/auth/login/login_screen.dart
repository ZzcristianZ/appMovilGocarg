import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:gocarg/config/router/app_routes.dart';
import 'package:gocarg/config/theme/app_colors.dart';
import 'package:gocarg/presentation/providers/role_provider.dart';

/// Login. El rol ya viene elegido desde la pantalla anterior — aquí solo
/// se refleja (chip + acento) y se decide a qué shell entrar al confirmar.
/// Sin backend todavía: "Iniciar sesión" navega directo, es solo para
/// poder probar el flujo visualmente.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _ocultarPassword = true;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final rol = ref.watch(selectedRoleProvider) ?? GoCargRole.cliente;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => context.go(AppRoutes.seleccionRol),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              const SizedBox(height: 4),
              Chip(
                avatar: Icon(Icons.check_circle_rounded, color: rol.acentoTexto, size: 16),
                label: Text(rol == GoCargRole.cliente ? 'Cliente' : 'Conductor'),
                backgroundColor: rol.acentoSuave,
                labelStyle: TextStyle(color: rol.acentoTexto, fontWeight: FontWeight.w600),
                side: BorderSide.none,
              ),
              const SizedBox(height: 20),
              Text('Bienvenido de nuevo', style: textTheme.displaySmall),
              const SizedBox(height: 6),
              Text(
                'Inicia sesión para continuar',
                style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
              ),
              const SizedBox(height: 28),
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  prefixIcon: Icon(Icons.mail_outline_rounded),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: _ocultarPassword,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _ocultarPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    ),
                    onPressed: () => setState(() => _ocultarPassword = !_ocultarPassword),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: rol.acento,
                    foregroundColor: rol.onAcento,
                  ),
                  onPressed: () => context.go(
                    rol == GoCargRole.cliente ? AppRoutes.clienteHome : AppRoutes.conductorHome,
                  ),
                  child: const Text('Iniciar sesión'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
