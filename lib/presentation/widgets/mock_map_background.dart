import 'package:flutter/material.dart';

import '../../config/theme/theme.dart';



/// Representación estilizada de un mapa — no es un mapa real (no hay SDK
/// de mapas ni API key en el proyecto todavía). Sirve para maquetar las
/// pantallas de ubicación/seguimiento; se reemplaza por google_maps_flutter
/// o flutter_map cuando entre la parte funcional del proyecto.
class MockMapBackground extends StatelessWidget {
  final List<Alignment> pines;

  const MockMapBackground({super.key, this.pines = const []});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE7ECE6),
      child: CustomPaint(
        painter: _MockMapPainter(),
        child: Stack(
          children: [
            for (final alineacion in pines)
              Align(
                alignment: alineacion,
                child: const Icon(
                  Icons.location_on_rounded,
                  color: AppColors.ruta,
                  size: 30,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MockMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final calles = Paint()
      ..color = Colors.white
      ..strokeWidth = 3;

    const espaciado = 46.0;
    for (double x = 0; x < size.width; x += espaciado) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), calles);
    }
    for (double y = 0; y < size.height; y += espaciado) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), calles);
    }

    final manzana = Paint()..color = const Color(0xFFDCE4D9);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.1, size.height * 0.15, size.width * 0.3, size.height * 0.22),
        const Radius.circular(6),
      ),
      manzana,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.55, size.height * 0.55, size.width * 0.35, size.height * 0.28),
        const Radius.circular(6),
      ),
      manzana,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
