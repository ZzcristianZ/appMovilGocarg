import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:gocarg/config/theme/theme.dart';

import 'conductor_disponible.dart';

class _Mensaje {
  final String texto;
  final bool deMi;
  final DateTime hora;

  const _Mensaje({required this.texto, required this.deMi, required this.hora});
}

/// Chat con el conductor de la solicitud en curso. Solo local — sin
/// backend todavía, sirve para mostrar dónde y cómo se negocia la tarifa
/// una vez el conductor recibe la solicitud.
class ChatConductorScreen extends StatefulWidget {
  const ChatConductorScreen({super.key});

  @override
  State<ChatConductorScreen> createState() => _ChatConductorScreenState();
}

class _ChatConductorScreenState extends State<ChatConductorScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  late List<_Mensaje> _mensajes;

  @override
  void initState() {
    super.initState();
    final ahora = DateTime.now();
    _mensajes = [
      _Mensaje(
        texto: '¡Hola! Ya vi tu solicitud. Puedo hacer el viaje por \$85.000, ¿te sirve?',
        deMi: false,
        hora: ahora.subtract(const Duration(minutes: 3)),
      ),
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _enviar() {
    final texto = _controller.text.trim();
    if (texto.isEmpty) {
      return;
    }
    setState(() {
      _mensajes.add(_Mensaje(texto: texto, deMi: true, hora: DateTime.now()));
    });
    _controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final conductor = GoRouterState.of(context).extra as ConductorDisponible?;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.cargaSuave,
              child: Text(
                conductor?.iniciales ?? '?',
                style: const TextStyle(color: AppColors.rutaOscuro, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            const SizedBox(width: 10),
            Text(conductor?.nombre ?? 'Conductor'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _mensajes.length,
              itemBuilder: (context, index) => _BurbujaMensaje(mensaje: _mensajes[index]),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _enviar(),
                      decoration: const InputDecoration(hintText: 'Escribe un mensaje...'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: colors.secondary,
                    shape: const CircleBorder(),
                    child: IconButton(
                      onPressed: _enviar,
                      icon: Icon(Icons.send_rounded, color: colors.onSecondary),
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

class _BurbujaMensaje extends StatelessWidget {
  final _Mensaje mensaje;
  const _BurbujaMensaje({required this.mensaje});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final hora =
        '${mensaje.hora.hour.toString().padLeft(2, '0')}:${mensaje.hora.minute.toString().padLeft(2, '0')}';

    return Align(
      alignment: mensaje.deMi ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
        decoration: BoxDecoration(
          color: mensaje.deMi ? AppColors.cargaSuave : colors.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(mensaje.deMi ? 16 : 4),
            bottomRight: Radius.circular(mensaje.deMi ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              mensaje.texto,
              style: TextStyle(
                color: mensaje.deMi ? AppColors.rutaOscuro : colors.onSurface,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              hora,
              style: TextStyle(
                color: (mensaje.deMi ? AppColors.rutaOscuro : colors.onSurfaceVariant).withValues(alpha: 0.7),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
