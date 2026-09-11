import 'package:flutter/material.dart';

class MiPerfil extends StatelessWidget {
  const MiPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _ProfileHeader(colors: colors),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _UserStats(colors: colors),
                const SizedBox(height: 28),

                _SectionLabel(label: 'MI CUENTA'),
                const SizedBox(height: 10),
                _OptionsGroup(
                  colors: colors,
                  options: [
                    _OptionItem(
                      icon: Icons.person_outline_rounded,
                      title: 'Editar perfil',
                      subtitle: 'Nombre, foto, contacto',
                      color: colors.primary,
                    ),
                    _OptionItem(
                      icon: Icons.lock_outline_rounded,
                      title: 'Seguridad',
                      subtitle: 'Contraseña y verificación',
                      color: colors.secondary,
                    ),
                    _OptionItem(
                      icon: Icons.notifications_none_rounded,
                      title: 'Notificaciones',
                      subtitle: 'Alertas y avisos',
                      color: colors.tertiary,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                _SectionLabel(label: 'PREFERENCIAS'),
                const SizedBox(height: 10),
                _OptionsGroup(
                  colors: colors,
                  options: [
                    _OptionItem(
                      icon: Icons.palette_outlined,
                      title: 'Apariencia',
                      subtitle: 'Tema y colores',
                      color: const Color(0xFFA78BFA),
                    ),
                    _OptionItem(
                      icon: Icons.language_rounded,
                      title: 'Idioma',
                      subtitle: 'Español',
                      color: const Color(0xFF34D399),
                      trailing: _Badge(label: 'ES', colors: colors),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                _SectionLabel(label: 'SOPORTE'),
                const SizedBox(height: 10),
                _OptionsGroup(
                  colors: colors,
                  options: [
                    _OptionItem(
                      icon: Icons.help_outline_rounded,
                      title: 'Centro de ayuda',
                      subtitle: 'Preguntas frecuentes',
                      color: const Color(0xFFFBBF24),
                    ),
                    _OptionItem(
                      icon: Icons.info_outline_rounded,
                      title: 'Acerca de Gocarg',
                      subtitle: 'Versión 1.0.0',
                      color: colors.outline,
                    ),
                  ],
                ),

                const SizedBox(height: 28),
                _LogoutButton(colors: colors),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Profile Header ────────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  final ColorScheme colors;
  const _ProfileHeader({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.primary, colors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.6),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 44,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFF4ADE80),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded,
                      color: Colors.white, size: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Cristian Areniz',
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'cristian@email.com',
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.75), fontSize: 14),
          ),
          const SizedBox(height: 10),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Operador · Plan Estándar',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

// ── User Stats ────────────────────────────────────────────────────────────────

class _UserStats extends StatelessWidget {
  final ColorScheme colors;
  const _UserStats({required this.colors});

  @override
  Widget build(BuildContext context) {
    const stats = [('24', 'Servicios'), ('4.9 ★', 'Calificación'), ('3', 'Meses')];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: stats.asMap().entries.map((e) {
          final (val, label) = e.value;
          final isLast = e.key == stats.length - 1;
          return Expanded(
            child: Container(
              decoration: isLast
                  ? null
                  : BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: colors.outlineVariant.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
              child: Column(
                children: [
                  Text(val,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: colors.primary)),
                  const SizedBox(height: 3),
                  Text(label,
                      style: TextStyle(
                          fontSize: 11, color: colors.outline)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Section Label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Text(
      label,
      style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: colors.outline,
          letterSpacing: 1.5),
    );
  }
}

// ── Options Group ─────────────────────────────────────────────────────────────

class _OptionItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Widget? trailing;

  const _OptionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.trailing,
  });
}

class _Badge extends StatelessWidget {
  final String label;
  final ColorScheme colors;
  const _Badge({required this.label, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: colors.onPrimaryContainer)),
    );
  }
}

class _OptionsGroup extends StatelessWidget {
  final ColorScheme colors;
  final List<_OptionItem> options;

  const _OptionsGroup({required this.colors, required this.options});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Material(
        color: colors.surfaceContainerHighest,
        child: Column(
          children: options.asMap().entries.map((entry) {
            final i = entry.key;
            final opt = entry.value;
            final isLast = i == options.length - 1;

            return Column(
              children: [
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: opt.color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(opt.icon, color: opt.color, size: 18),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(opt.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14)),
                              Text(opt.subtitle,
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: colors.outline)),
                            ],
                          ),
                        ),
                        opt.trailing ??
                            Icon(Icons.arrow_forward_ios_rounded,
                                size: 14, color: colors.outline),
                      ],
                    ),
                  ),
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    indent: 54,
                    color: colors.outlineVariant.withValues(alpha: 0.4),
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ── Logout Button ─────────────────────────────────────────────────────────────

class _LogoutButton extends StatelessWidget {
  final ColorScheme colors;
  const _LogoutButton({required this.colors});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(Icons.logout_rounded, color: colors.error),
        label: Text('Cerrar sesión',
            style: TextStyle(
                color: colors.error, fontWeight: FontWeight.bold)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: BorderSide(color: colors.error.withValues(alpha: 0.4)),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}