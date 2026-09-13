import 'package:flutter/material.dart';

/// Tarjeta de ruta con forma de "ticket": origen y destino conectados por
/// una línea punteada, con espacio para chips (tipo de vehículo/carga) y
/// un pie opcional (precio, conductor, etc). Es el componente central del
/// flujo de solicitud — reemplaza la card de foto+texto genérica por algo
/// que refleja el contenido real (una ruta de un punto a otro).
class RouteTicketCard extends StatelessWidget {
  final String origen;
  final String destino;
  final List<Widget> chips;
  final Widget? pie;

  const RouteTicketCard({
    super.key,
    required this.origen,
    required this.destino,
    this.chips = const [],
    this.pie,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Icon(Icons.circle, size: 10, color: colors.primary),
                    SizedBox(
                      height: 28,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            3,
                            (_) => Container(
                              width: 2,
                              height: 4,
                              color: colors.outline,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Icon(Icons.location_on_rounded, size: 14, color: colors.tertiary),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        origen,
                        style: textTheme.bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 22),
                      Text(
                        destino,
                        style: textTheme.bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (chips.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Wrap(spacing: 8, runSpacing: 8, children: chips),
            ),
          if (pie != null) ...[
            _PerforatedDivider(color: colors.outlineVariant),
            Padding(
              padding: const EdgeInsets.all(16),
              child: pie!,
            ),
          ],
        ],
      ),
    );
  }
}

class _PerforatedDivider extends StatelessWidget {
  final Color color;
  const _PerforatedDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cantidad = (constraints.maxWidth / 10).floor();
          return Row(
            children: List.generate(
              cantidad,
              (_) => Expanded(
                child: Container(height: 1, color: color, margin: const EdgeInsets.symmetric(horizontal: 2)),
              ),
            ),
          );
        },
      ),
    );
  }
}
