import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:gocarg/config/router/app_routes.dart';
import 'package:gocarg/config/theme/theme.dart';

/// Datos mínimos del conductor para mostrar en la pantalla de calificación.
typedef _ConductorInfo = ({String nombre, String iniciales});

/// Calificar el servicio recién finalizado. Solo local — sin backend
/// todavía, la calificación no se persiste más allá de esta sesión.
class CalificarServicioScreen extends StatefulWidget {
  const CalificarServicioScreen({super.key});

  @override
  State<CalificarServicioScreen> createState() => _CalificarServicioScreenState();
}

class _CalificarServicioScreenState extends State<CalificarServicioScreen> {
  int _estrellas = 0;
  final _comentarioController = TextEditingController();

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  void _enviar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('¡Gracias por tu calificación!')),
    );
    context.go(AppRoutes.clienteHome);
  }

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra;
    final conductor = extra is _ConductorInfo ? extra : null;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Calificar servicio'), automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.cargaSuave,
                  child: Text(
                    conductor?.iniciales ?? '?',
                    style: const TextStyle(color: AppColors.rutaOscuro, fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                const SizedBox(height: 12),
                Text('¿Cómo estuvo tu viaje con\n${conductor?.nombre ?? "tu conductor"}?',
                    style: textTheme.titleLarge, textAlign: TextAlign.center),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final valor = i + 1;
              return IconButton(
                iconSize: 40,
                onPressed: () => setState(() => _estrellas = valor),
                icon: Icon(
                  valor <= _estrellas ? Icons.star_rounded : Icons.star_border_rounded,
                  color: AppColors.carga,
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          Text('Cuéntanos más (opcional)', style: textTheme.titleMedium),
          const SizedBox(height: 10),
          TextField(
            controller: _comentarioController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Puntualidad, cuidado con la carga, trato...',
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _estrellas > 0 ? _enviar : null,
              child: const Text('Enviar calificación'),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => context.go(AppRoutes.clienteHome),
              child: Text('Omitir', style: TextStyle(color: colors.onSurfaceVariant)),
            ),
          ),
        ],
      ),
    );
  }
}
