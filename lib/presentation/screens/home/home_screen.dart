import 'package:flutter/material.dart';
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
    } else if (location == AppRoutes.motocars) {
      currentIndex = 2;
    } else if (location == AppRoutes.perfil) {
      currentIndex = 3;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appMenuItems[currentIndex].title),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go(AppRoutes.home);
              break;
            case 1:
              context.go(AppRoutes.cars);
              break;
            case 2:
              context.go(AppRoutes.motocars);
              break;
            case 3:
              context.go(AppRoutes.perfil);
              break;
          }
        },
        destinations: appMenuItems.map((menuItem) {
          return NavigationDestination(
            icon: menuItem.icon,
            label: menuItem.title,
          );
        }).toList(),
      ),
    );
  }
}
