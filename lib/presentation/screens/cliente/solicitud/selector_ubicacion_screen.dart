import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/widgets.dart';

/// Selector de ubicación — se usa tanto para origen como para destino.
/// Recibe el título ('Origen' / 'Destino') por `extra` y devuelve la
/// dirección elegida hacia la pantalla que lo llamó vía `context.pop`.
class SelectorUbicacionScreen extends StatefulWidget {
  const SelectorUbicacionScreen({super.key});

  @override
  State<SelectorUbicacionScreen> createState() => _SelectorUbicacionScreenState();
}

class _SelectorUbicacionScreenState extends State<SelectorUbicacionScreen> {
  final _controller = TextEditingController();

  static const _sugerencias = [
    'Parque Agustina Ferro, Ocaña',
    'Terminal de Transporte, Ocaña',
    'UFPS Ocaña',
    'Centro histórico, Ocaña',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titulo = (GoRouterState.of(context).extra as String?) ?? 'ubicación';
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: MockMapBackground()),

          // Pin fijo al centro — el mapa se "mueve" detrás, no el pin.
          const Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: Icon(Icons.location_on_rounded, size: 44, color: Colors.black87),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Material(
                        color: colors.surface,
                        shape: const CircleBorder(),
                        child: IconButton(
                          onPressed: () => context.pop(),
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Material(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(14),
                          elevation: 1,
                          child: TextField(
                            controller: _controller,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              hintText: 'Buscar $titulo',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: colors.surface,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _sugerencias.map((s) {
                      return ActionChip(
                        backgroundColor: colors.surface,
                        label: Text(s, style: textTheme.labelSmall),
                        onPressed: () => setState(() => _controller.text = s),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(titulo, style: textTheme.labelSmall?.copyWith(color: colors.onSurfaceVariant)),
                  const SizedBox(height: 2),
                  Text(
                    _controller.text.isEmpty ? 'Mueve el mapa o busca una dirección' : _controller.text,
                    style: textTheme.bodyLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.pop(
                        _controller.text.isEmpty ? 'Ubicación seleccionada en el mapa' : _controller.text,
                      ),
                      child: Text('Confirmar $titulo'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
