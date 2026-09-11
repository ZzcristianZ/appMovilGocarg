import 'package:flutter/material.dart';

class CarsScreen extends StatefulWidget {
  const CarsScreen({super.key});

  static const String name = 'CarsScreen';

  @override
  State<CarsScreen> createState() => _CarsScreenState();
}

class _CarsScreenState extends State<CarsScreen> {
  int _selectedFilter = 0;

  static const _filters = ['Todos', 'Disponible', 'En ruta', 'Mantenimiento'];

  static const _cars = [
    _CarData('Camión Doble Troque', 'TRQ-001', 'Disponible', '5.000 kg', 'Diesel', 2022),
    _CarData('Camión Sencillo',     'SNC-002', 'En ruta',    '2.500 kg', 'Diesel', 2021),
    _CarData('Furgón Mediano',      'FRG-003', 'Disponible', '1.800 kg', 'Gas',    2023),
    _CarData('Camión Plataforma',   'PLT-004', 'Mantenimiento','8.000 kg','Diesel', 2020),
    _CarData('Furgón Express',      'FRG-005', 'Disponible', '900 kg',   'Eléctrico', 2024),
    _CarData('Camión Refrigerado',  'REF-006', 'En ruta',    '3.000 kg', 'Diesel', 2022),
  ];

  List<_CarData> get _filtered => _selectedFilter == 0
      ? _cars
      : _cars.where((c) => c.status == _filters[_selectedFilter]).toList();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final filtered = _filtered;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Buscador ─────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: SearchBar(
            hintText: 'Buscar por placa, tipo o estado...',
            leading: Icon(Icons.search_rounded, color: colors.primary),
            backgroundColor: WidgetStatePropertyAll(
                colors.surfaceContainerHighest),
            elevation: const WidgetStatePropertyAll(0),
            padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 16)),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),

        // ── Filtros ───────────────────────────────────────────────────
        SizedBox(
          height: 38,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _filters.length,
            itemBuilder: (context, i) {
              final selected = _selectedFilter == i;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Material(
                  color: selected
                      ? colors.primary
                      : colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => setState(() => _selectedFilter = i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text(
                        _filters[i],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: selected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: selected
                              ? colors.onPrimary
                              : colors.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // ── Contador ──────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
          child: Text(
            '${filtered.length} vehículo${filtered.length != 1 ? 's' : ''} encontrado${filtered.length != 1 ? 's' : ''}',
            style: TextStyle(
                fontSize: 12,
                color: colors.outline,
                fontWeight: FontWeight.w500),
          ),
        ),

        // ── Lista ─────────────────────────────────────────────────────
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            physics: const BouncingScrollPhysics(),
            itemCount: filtered.length,
            itemBuilder: (context, i) =>
                _CarCard(car: filtered[i], colors: colors),
          ),
        ),
      ],
    );
  }
}

// ── Data model ────────────────────────────────────────────────────────────────

class _CarData {
  final String name;
  final String plate;
  final String status;
  final String capacity;
  final String fuel;
  final int year;

  const _CarData(this.name, this.plate, this.status, this.capacity,
      this.fuel, this.year);
}

// ── Car Card ──────────────────────────────────────────────────────────────────

class _CarCard extends StatelessWidget {
  final _CarData car;
  final ColorScheme colors;

  const _CarCard({required this.car, required this.colors});

  Color get _statusColor => switch (car.status) {
        'Disponible'    => const Color(0xFF4ADE80),
        'En ruta'       => const Color(0xFFFBBF24),
        'Mantenimiento' => const Color(0xFFF87171),
        _               => colors.outline,
      };

  IconData get _fuelIcon => switch (car.fuel) {
        'Eléctrico' => Icons.electric_bolt_rounded,
        'Gas'       => Icons.gas_meter_outlined,
        _           => Icons.local_gas_station_rounded,
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: _statusColor.withValues(alpha: 0.25),
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    // Icono
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: colors.primaryContainer,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(Icons.airport_shuttle_rounded,
                          color: colors.onPrimaryContainer, size: 26),
                    ),
                    const SizedBox(width: 14),
                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(car.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                          const SizedBox(height: 3),
                          Text(
                            '${car.plate} · ${car.year}',
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.outline,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Status chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            car.status,
                            style: TextStyle(
                              color: _statusColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Detalles
                ColoredBox(
                  color: colors.surface,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    child: Row(
                      children: [
                        _DetailChip(
                          icon: Icons.scale_rounded,
                          label: car.capacity,
                          color: colors.primary,
                        ),
                        const SizedBox(width: 16),
                        _DetailChip(
                          icon: _fuelIcon,
                          label: car.fuel,
                          color: colors.secondary,
                        ),
                        const Spacer(),
                        Icon(Icons.arrow_forward_ios_rounded,
                            size: 13, color: colors.outline),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _DetailChip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 5),
        Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color)),
      ],
    );
  }
}