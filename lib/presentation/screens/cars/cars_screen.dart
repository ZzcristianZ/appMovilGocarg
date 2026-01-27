import 'package:flutter/material.dart';


class CarsScreen extends StatelessWidget {
  const CarsScreen({super.key});
      static const String name = 'CarsScreen';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuestros Carros De Carga'),
      ),
      
    );
  }
}