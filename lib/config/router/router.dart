import 'package:go_router/go_router.dart';
import 'package:gocarg/presentation/screens/home/home_screen.dart';
import 'package:gocarg/presentation/screens/cars/cars_screen.dart';
import 'package:gocarg/presentation/screens/motoCars/moto_cars_screen.dart';



final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/MotoCars',
      builder: (context, state) => const MotoCarsScreen(),
    ),
    GoRoute(
      path: '/Cars',
      builder: (context, state) => const CarsScreen(),
    ),
    GoRoute(
      path: '/Cars',
      builder: (context, state) => const CarsScreen(),
    ),
  ]
);


