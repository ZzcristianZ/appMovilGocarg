import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:gocarg/config/router/app_routes.dart';
import 'package:gocarg/config/theme/app_colors.dart';
import 'package:gocarg/config/theme/app_typography.dart';
import 'package:gocarg/presentation/providers/solicitud_provider.dart';
import 'package:gocarg/presentation/screens/cliente/solicitud/conductor_disponible.dart';
import 'package:gocarg/presentation/screens/cliente/solicitud/solicitud_flete.dart';

/// Formulario para crear la solicitud: el conductor ya viene elegido
/// desde Disponibilidad (llega por `extra`). Aquí solo se define origen,
/// destino, tipo de carga, peso aproximado y fecha/hora.
class NuevaSolicitudScreen extends ConsumerStatefulWidget {
  const NuevaSolicitudScreen({super.key});

  @override
  ConsumerState<NuevaSolicitudScreen> createState() => _NuevaSolicitudScreenState();
}

class _NuevaSolicitudScreenState extends ConsumerState<NuevaSolicitudScreen> {
  String? _origen;
  String? _destino;
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

  bool get _puedeContinuar => _origen != null && _destino != null;

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
    if (fecha != null) {
      setState(() => _fecha = fecha);
    }
  }

  Future<void> _elegirHora() async {
    final hora = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (hora != null) {
      setState(() => _hora = hora);
    }
  }

  @override
  Widget build(BuildContext context) {
    final conductor = GoRouterState.of(context).extra as ConductorDisponible?;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (conductor == null) {
      return const Scaffold(body: Center(child: Text('Elige un conductor primero')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Nueva solicitud')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.cargaSuave,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: colors.surface,
                  child: Text(
                    conductor.iniciales,
                    style: const TextStyle(color: AppColors.rutaOscuro, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(conductor.nombre, style: textTheme.titleMedium),
                      Text(
                        '${conductor.tipo.nombre} · ${conductor.placa}',
                        style: textTheme.bodyMedium?.copyWith(color: AppColors.rutaOscuro),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('Cambiar'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
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
              onPressed: _puedeContinuar
                  ? () {
                      ref.read(solicitudEnProgresoProvider.notifier).guardar(
                            SolicitudFlete(
                              conductor: conductor,
                              origen: _origen!,
                              destino: _destino!,
                              tipoCarga: _tipoCarga,
                              peso: _pesoController.text,
                              fecha: _fecha,
                              hora: _hora,
                            ),
                          );
                      context.push(AppRoutes.clienteConfirmacion);
                    }
                  : null,
              child: const Text('Continuar'),
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
