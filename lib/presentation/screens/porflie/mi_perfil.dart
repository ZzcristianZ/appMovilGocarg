import 'package:flutter/material.dart';

class MiPerfil extends StatelessWidget {
  const MiPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).colorScheme;

    final avatarSize = size.width * 0.3; 

    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.06,
        vertical: size.height * 0.03,
      ),
      children: [
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: avatarSize / 2,
                backgroundColor: colors.primaryContainer,
                child: Icon(
                  Icons.person,
                  size: avatarSize * 0.6,
                  color: colors.primary,
                ),
              ),
              SizedBox(height: size.height * 0.015),
              const Text(
                'Cristian Areniz',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.005),
              Text(
                'cristian@email.com',
                style: TextStyle(color: colors.outline),
              ),
            ],
          ),
        ),

        SizedBox(height: size.height * 0.05),

        _ProfileOption(icon: Icons.person_outline, title: 'Editar perfil'),
        _ProfileOption(icon: Icons.lock_outline, title: 'Seguridad'),
        _ProfileOption(icon: Icons.notifications_none, title: 'Notificaciones'),
        _ProfileOption(icon: Icons.settings_outlined, title: 'Configuración'),

        SizedBox(height: size.height * 0.05),

        FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.logout),
          label: const Text('Cerrar sesión'),
          style: FilledButton.styleFrom(
            backgroundColor: colors.errorContainer,
            foregroundColor: colors.onErrorContainer,
            padding: EdgeInsets.symmetric(vertical: size.height * 0.018),
          ),
        ),
      ],
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;

  const _ProfileOption({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 0,
        color: colors.surfaceContainerHighest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          leading: Icon(icon, color: colors.primary),
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          onTap: () {},
        ),
      ),
    );
  }
}
