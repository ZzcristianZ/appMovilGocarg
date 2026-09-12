// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:gocarg/config/menu/menu_items.dart';
import 'package:gocarg/config/router/app_routes.dart';

class HomeScreen extends StatelessWidget {
  final Widget child;

  const HomeScreen({
    super.key,
    required this.child,
  });

  static const String name = 'home_screen';

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final location = GoRouterState.of(context).uri.path;

    int currentIndex = 0;
    if (location == AppRoutes.cars) {
      currentIndex = 1;
    } else if (location == AppRoutes.motocars) currentIndex = 2;
    else if (location == AppRoutes.perfil) currentIndex = 3;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: colors.surface,
      ),
      child: Scaffold(
        backgroundColor: colors.surface,
        appBar: _GocargAppBar(
          title: appMenuItems[currentIndex].title,
          colors: colors,
        ),
        body: child,
        bottomNavigationBar: _GocargBottomNav(
          currentIndex: currentIndex,
          colors: colors,
          onTap: (index) {
            switch (index) {
              case 0: context.go(AppRoutes.home); break;
              case 1: context.go(AppRoutes.cars); break;
              case 2: context.go(AppRoutes.motocars); break;
              case 3: context.go(AppRoutes.perfil); break;
            }
          },
        ),
      ),
    );
  }
}

// ── AppBar personalizada ──────────────────────────────────────────────────────

class _GocargAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final ColorScheme colors;

  const _GocargAppBar({required this.title, required this.colors});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.primary, colors.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.local_shipping_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'GOCARG',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.65),
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 3,
                    ),
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              _AppBarIconButton(
                icon: Icons.notifications_none_rounded,
                onTap: () {},
                colors: colors,
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 17,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: const Text(
                  'CA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppBarIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final ColorScheme colors;

  const _AppBarIconButton({
    required this.icon,
    required this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: Colors.white, size: 19),
        ),
      ),
    );
  }
}

// ── Bottom Navigation ─────────────────────────────────────────────────────────

class _GocargBottomNav extends StatelessWidget {
  final int currentIndex;
  final ColorScheme colors;
  final ValueChanged<int> onTap;

  const _GocargBottomNav({
    required this.currentIndex,
    required this.colors,
    required this.onTap,
  });

  static const _items = [
    (Icons.home_rounded, Icons.home_outlined, 'Inicio'),
    (Icons.airport_shuttle_rounded, Icons.airport_shuttle_outlined, 'Carros'),
    (Icons.motorcycle_rounded, Icons.motorcycle_outlined, 'Motos'),
    (Icons.person_rounded, Icons.person_outline_rounded, 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: List.generate(_items.length, (i) {
              final isSelected = i == currentIndex;
              final (activeIcon, inactiveIcon, label) = _items[i];

              return Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onTap(i),
                    borderRadius: BorderRadius.circular(14),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colors.primary.withValues(alpha: 0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isSelected ? activeIcon : inactiveIcon,
                            color: isSelected ? colors.primary : colors.outline,
                            size: 22,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.normal,
                              color: isSelected
                                  ? colors.primary
                                  : colors.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}