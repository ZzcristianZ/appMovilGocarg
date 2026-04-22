import 'package:flutter/material.dart';

class MotoCarsScreen extends StatelessWidget {
  const MotoCarsScreen({super.key});

  static const String name = 'MotoCarsScreen';

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Lista de ejemplo para la fase de diseño
    final motos = List.generate(
      5,
      (i) => _MotoItem(
        name: 'Motocarga ${i + 1}',
        plate: 'MTO-${200 + i}',
        status: i % 2 == 0 ? 'Disponible' : 'En ruta',
        capacity: '${(i + 1) * 80} kg',
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barra de búsqueda (diseño)
          SearchBar(
            hintText: 'Buscar motocarga...',
            leading: const Icon(Icons.search),
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 16),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Motocargas activas',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          // Lista de motos en grid
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              itemCount: motos.length,
              itemBuilder: (context, index) {
                final moto = motos[index];
                final isAvailable = moto.status == 'Disponible';
                final statusColor =
                    isAvailable ? Colors.green : colors.primary;

                return Card(
                  elevation: 0,
                  color: colors.surfaceContainerHighest,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: colors.primaryContainer,
                              child: Icon(Icons.motorcycle_sharp,
                                  color: colors.primary, size: 20),
                            ),
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(moto.name,
                            style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text(moto.plate,
                            style: textTheme.labelSmall
                                ?.copyWith(color: colors.outline)),
                        const SizedBox(height: 4),
                        Text('Cap: ${moto.capacity}',
                            style: textTheme.labelSmall
                                ?.copyWith(color: colors.outline)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MotoItem {
  final String name;
  final String plate;
  final String status;
  final String capacity;

  const _MotoItem({
    required this.name,
    required this.plate,
    required this.status,
    required this.capacity,
  });
}