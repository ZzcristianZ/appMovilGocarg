import 'package:flutter/material.dart';

class CarsScreen extends StatelessWidget {
  const CarsScreen({super.key});

  static const String name = 'CarsScreen';

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Lista de ejemplo para la fase de diseño
    final cars = List.generate(
      6,
      (i) => _CarItem(
        name: 'Camión de Carga ${i + 1}',
        plate: 'ABC-${100 + i}',
        status: i % 3 == 0 ? 'Disponible' : i % 3 == 1 ? 'En ruta' : 'Mantenimiento',
        capacity: '${(i + 1) * 500} kg',
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barra de búsqueda (diseño)
          SearchBar(
            hintText: 'Buscar vehículo...',
            leading: const Icon(Icons.search),
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 16),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Flota disponible',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          // Lista de carros
          Expanded(
            child: ListView.separated(
              itemCount: cars.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final car = cars[index];
                final statusColor = car.status == 'Disponible'
                    ? Colors.green
                    : car.status == 'En ruta'
                        ? colors.primary
                        : colors.error;

                return Card(
                  elevation: 0,
                  color: colors.surfaceContainerHighest,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: colors.primaryContainer,
                      child: Icon(Icons.airport_shuttle_outlined,
                          color: colors.primary),
                    ),
                    title: Text(car.name,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('Placa: ${car.plate} · Cap: ${car.capacity}'),
                    trailing: Chip(
                      label: Text(car.status,
                          style: TextStyle(
                              color: statusColor, fontSize: 11)),
                      backgroundColor: statusColor,
                      side: BorderSide.none,
                      padding: EdgeInsets.zero,
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

class _CarItem {
  final String name;
  final String plate;
  final String status;
  final String capacity;

  const _CarItem({
    required this.name,
    required this.plate,
    required this.status,
    required this.capacity,
  });
}