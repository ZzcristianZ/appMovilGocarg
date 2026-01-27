import 'package:flutter/material.dart';
import 'package:gocarg/config/menu/menu_items.dart';
import 'package:gocarg/presentation/screens/View/home_view.dart';
import 'package:gocarg/presentation/screens/cars/cars_screen.dart';
import 'package:gocarg/presentation/screens/motoCars/moto_cars_screen.dart';
import 'package:gocarg/presentation/screens/porflie/mi_perfil.dart';
import 'package:gocarg/presentation/widgets/side.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String name = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  late final List<Side> tabs;

  @override
  void initState() {
    super.initState();

    tabs = [
      Side(
        title: 'Gocarg',
        body: const HomeView(),
        
      ),
      Side(
        title: 'Cars',
        body: const CarsScreen(),
      ),
      Side(
        title: 'Moto Cargas',
        body: const MotoCarsScreen(),
      ),
      Side(
        title: 'Perfil',
        body: const MiPerfil(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(tabs[currentIndex].title),
        centerTitle: true,
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        actions: tabs[currentIndex].actions,
      ),

      body: IndexedStack(
        index: currentIndex,
        children: tabs.map((t) => t.body).toList(),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        backgroundColor: colors.surface,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
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
