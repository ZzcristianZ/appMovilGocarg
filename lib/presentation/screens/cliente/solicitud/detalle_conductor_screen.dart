import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/routing.dart';
import '../../../../config/theme/theme.dart';
import '../../../providers/providers.dart';
import '../../../widgets/widgets.dart';
import '../cliente.dart';



/// Detalle del conductor/vehículo elegido en Resultados. El conductor
/// llega por `extra`; la ruta se lee del provider de la solicitud en
/// progreso.
class DetalleConductorScreen extends ConsumerWidget {
  const DetalleConductorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conductor = GoRouterState.of(context).extra as ConductorDisponible?;
    final solicitud = ref.watch(solicitudEnProgresoProvider);
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (conductor == null) {
      return const Scaffold(body: Center(child: Text('No se encontró el conductor')));
    }

    final distanciaTarifa = (conductor.tarifa * 0.7).round();
    final servicioTarifa = conductor.tarifa - distanciaTarifa;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del conductor')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: AppColors.cargaSuave,
                child: Text(
                  conductor.iniciales,
                  style: const TextStyle(color: AppColors.rutaOscuro, fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(conductor.nombre, style: textTheme.titleLarge),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 16, color: AppColors.carga),
                        const SizedBox(width: 2),
                        Text('${conductor.calificacion}', style: AppTypography.dato(fontSize: 13)),
                        const SizedBox(width: 6),
                        Text(
                          '· ${conductor.viajesRealizados} viajes',
                          style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Text('Vehículo', style: textTheme.titleMedium),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              border: Border.all(color: colors.outline),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(
                  conductor.vehiculo == 'Moto carga' ? Icons.motorcycle_rounded : Icons.airport_shuttle_rounded,
                  color: colors.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(conductor.vehiculo, style: textTheme.bodyLarge)),
                Text(conductor.placa, style: AppTypography.dato(fontSize: 14)),
              ],
            ),
          ),

          if (solicitud != null) ...[
            const SizedBox(height: 24),
            Text('Tu ruta', style: textTheme.titleMedium),
            const SizedBox(height: 10),
            RouteTicketCard(
              origen: solicitud.origen,
              destino: solicitud.destino,
              chips: [
                Chip(label: Text(solicitud.tipoVehiculo), side: BorderSide(color: colors.outline)),
                Chip(label: Text(solicitud.tipoCarga), side: BorderSide(color: colors.outline)),
              ],
            ),
          ],

          const SizedBox(height: 24),
          Text('Tarifa estimada', style: textTheme.titleMedium),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: colors.outline),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                _FilaTarifa(etiqueta: 'Servicio base', valor: servicioTarifa),
                const SizedBox(height: 8),
                _FilaTarifa(etiqueta: 'Distancia (${conductor.distanciaKm} km)', valor: distanciaTarifa),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(height: 1),
                ),
                _FilaTarifa(etiqueta: 'Total', valor: conductor.tarifa, destacado: true),
              ],
            ),
          ),

          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.push(AppRoutes.clienteConfirmacion, extra: conductor),
              child: const Text('Solicitar a este conductor'),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilaTarifa extends StatelessWidget {
  final String etiqueta;
  final int valor;
  final bool destacado;

  const _FilaTarifa({required this.etiqueta, required this.valor, this.destacado = false});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            etiqueta,
            style: destacado ? textTheme.titleMedium : textTheme.bodyMedium,
          ),
        ),
        Text(
          '\$$valor',
          style: AppTypography.dato(fontSize: destacado ? 18 : 14),
        ),
      ],
    );
  }
}
