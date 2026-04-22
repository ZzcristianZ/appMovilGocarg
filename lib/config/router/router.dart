import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:gocarg/presentation/screens/home/home_screen.dart';
import 'package:gocarg/presentation/screens/View/home_view.dart';
import 'package:gocarg/presentation/screens/cars/cars_screen.dart';
import 'package:gocarg/presentation/screens/motoCars/moto_cars_screen.dart';
import 'package:gocarg/presentation/screens/porflie/mi_perfil.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return HomeScreen(
          key: state.pageKey,
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/',        
          pageBuilder: (context, state) => CustomTransitionPage(
            transitionsBuilder: (context, animation, secondaryAnimation, child){
              return FadeTransition(opacity: animation,child: child,);
            },
            child:const HomeView()),   
          
        ),
        GoRoute(
          path: '/cars',    
          pageBuilder: (context, state) => CustomTransitionPage(
            transitionsBuilder: (context, animation, secondaryAnimation, child){
              return FadeTransition(opacity: animation,child: child,);
            },
            child:const CarsScreen() ),   
            
        ),
        GoRoute(
          path: '/motocars',
          pageBuilder: (context, state) => CustomTransitionPage(
            transitionsBuilder: (context, animation, secondaryAnimation, child){
              return FadeTransition(opacity: animation,child: child,);
            },
            child:const MotoCarsScreen()),       
          
        ),
        GoRoute(
          path: '/perfil',  
          pageBuilder: (context, state) => CustomTransitionPage(
            transitionsBuilder: (context, animation, secondaryAnimation, child){
              return FadeTransition(opacity: animation,child: child,);
            },
            child:const MiPerfil()),     
          
        ),
      ],
    ),
  ],
);
