import 'package:flutter/material.dart';
import 'package:gocarg/config/router/router.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {


    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Gocarg',
      routerConfig: appRouter,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color.fromARGB(255, 29, 66, 107)
      ),

    );
  }
}



