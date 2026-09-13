import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/routing.dart';
import '../../../../config/theme/theme.dart';
import '../../../providers/providers.dart';
import '../cliente.dart';

/// Formulario para publicar una solicitud de flete: origen, destino, tipo
/// de vehículo, tipo de carga, peso aproximado y fecha/hora.
class NuevaSolicitudScreen extends ConsumerStatefulWidget {
  const NuevaSolicitudScreen({super.key});

  @override
  ConsumerState<NuevaSolicitudScreen> createState() => _NuevaSolicitudScreenState();
}

class _NuevaSolicitudScreenState extends ConsumerState<NuevaSolicitudScreen> {
  String? _origen;
  String? _destino;
  String _tipoVehiculo = 'Camión de carga';
  String _tipoCarga = 'General';
  DateTime? _fecha;
  TimeOfDay? _hora;
  final _pesoController = TextEditingController();

  // Categorías provisionales — pendientes de definición final del proyecto
  // (ver decisión pendiente sobre tipo de camión / tipo de carga).
  static const _tiposCarga = [
    'General',
    'Frágil',
    'Refrigerada',
    'Materiales de construcción',
    'Mudanza / muebles',
  ];

  bool get _puedeBuscar => _origen != null && _destino != null;

  @override
  void dispose() {
    _pesoController.dispose();
    super.dispose();
  }

  Future<void> _elegirUbicacion({required bool esOrigen}) async {
    final resultado = await context.push<String>(
      AppRoutes.clienteSelectorUbicacion,
      extra: esOrigen ? 'Origen' : 'Destino',
    );
    if (resultado != null) {
      setState(() => esOrigen ? _origen = resultado : _destino = resultado);
    }
  }

  Future<void> _elegirFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (fecha != null) setState(() => _fecha = fecha);
  }

  Future<void> _elegirHora() async {
    final hora = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (hora != null) setState(() => _hora = hora);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Nueva solicitud')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text('¿Qué vas a mover?', style: textTheme.titleLarge),
          const SizedBox(height: 16),

          _CampoUbicacion(
            icono: Icons.trip_origin,
            iconoColor: colors.primary,
            etiqueta: 'Origen',
            valor: _origen,
            onTap: () => _elegirUbicacion(esOrigen: true),
          ),
          const SizedBox(height: 10),
          _CampoUbicacion(
            icono: Icons.location_on_rounded,
            iconoColor: colors.tertiary,
            etiqueta: 'Destino',
            valor: _destino,
            onTap: () => _elegirUbicacion(esOrigen: false),
          ),

          const SizedBox(height: 24),
          Text('Tipo de vehículo', style: textTheme.titleMedium),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _TipoVehiculoCard(
                  icono: Icons.airport_shuttle_rounded,
                  titulo: 'Camión\nde carga',
                  seleccionado: _tipoVehiculo == 'Camión de carga',
                  onTap: () => setState(() => _tipoVehiculo = 'Camión de carga'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _TipoVehiculoCard(
                  icono: Icons.motorcycle_rounded,
                  titulo: 'Moto\ncarga',
                  seleccionado: _tipoVehiculo == 'Moto carga',
                  onTap: () => setState(() => _tipoVehiculo = 'Moto carga'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          Text('Tipo de carga', style: textTheme.titleMedium),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _tiposCarga.map((tipo) {
              final seleccionado = _tipoCarga == tipo;
              return ChoiceChip(
                label: Text(tipo),
                selected: seleccionado,
                onSelected: (_) => setState(() => _tipoCarga = tipo),
                selectedColor: AppColors.cargaSuave,
                labelStyle: TextStyle(
                  color: seleccionado ? AppColors.rutaOscuro : colors.onSurfaceVariant,
                  fontWeight: seleccionado ? FontWeight.w600 : FontWeight.normal,
                ),
                side: BorderSide(color: seleccionado ? AppColors.carga : colors.outline),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),
          Text('Peso aproximado', style: textTheme.titleMedium),
          const SizedBox(height: 10),
          TextField(
            controller: _pesoController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Peso en kg',
              prefixIcon: Icon(Icons.scale_outlined),
            ),
          ),

          const SizedBox(height: 24),
          Text('¿Cuándo?', style: textTheme.titleMedium),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _CampoFechaHora(
                  icono: Icons.calendar_today_outlined,
                  texto: _fecha == null
                      ? 'Fecha'
                      : '${_fecha!.day}/${_fecha!.month}/${_fecha!.year}',
                  onTap: _elegirFecha,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CampoFechaHora(
                  icono: Icons.schedule_rounded,
                  texto: _hora == null ? 'Hora' : _hora!.format(context),
                  onTap: _elegirHora,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _puedeBuscar
                  ? () {
                      ref.read(solicitudEnProgresoProvider.notifier).guardar(
                            SolicitudFlete(
                              origen: _origen!,
                              destino: _destino!,
                              tipoVehiculo: _tipoVehiculo,
                              tipoCarga: _tipoCarga,
                              peso: _pesoController.text,
                              fecha: _fecha,
                              hora: _hora,
                            ),
                          );
                      context.push(AppRoutes.clienteResultados);
                    }
                  : null,
              child: const Text('Buscar conductores disponibles'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CampoUbicacion extends StatelessWidget {
  final IconData icono;
  final Color iconoColor;
  final String etiqueta;
  final String? valor;
  final VoidCallback onTap;

  const _CampoUbicacion({
    required this.icono,
    required this.iconoColor,
    required this.etiqueta,
    required this.valor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: colors.outline),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(icono, color: iconoColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(etiqueta, style: textTheme.labelSmall?.copyWith(color: colors.onSurfaceVariant)),
                    Text(
                      valor ?? 'Toca para seleccionar',
                      style: textTheme.bodyMedium?.copyWith(
                        color: valor == null ? colors.onSurfaceVariant : colors.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: colors.outline),
            ],
          ),
        ),
      ),
    );
  }
}

class _TipoVehiculoCard extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final bool seleccionado;
  final VoidCallback onTap;

  const _TipoVehiculoCard({
    required this.icono,
    required this.titulo,
    required this.seleccionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: seleccionado ? AppColors.cargaSuave : colors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: seleccionado ? AppColors.carga : colors.outline),
          ),
          child: Column(
            children: [
              Icon(icono, color: seleccionado ? AppColors.rutaOscuro : colors.onSurfaceVariant),
              const SizedBox(height: 6),
              Text(
                titulo,
                textAlign: TextAlign.center,
                style: textTheme.labelLarge?.copyWith(
                  color: seleccionado ? AppColors.rutaOscuro : colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CampoFechaHora extends StatelessWidget {
  final IconData icono;
  final String texto;
  final VoidCallback onTap;

  const _CampoFechaHora({required this.icono, required this.texto, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: colors.outline),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icono, size: 18, color: colors.onSurfaceVariant),
              const SizedBox(width: 8),
              Text(texto, style: AppTypography.dato(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
