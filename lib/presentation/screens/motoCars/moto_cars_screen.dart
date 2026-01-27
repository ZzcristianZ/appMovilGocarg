import 'package:flutter/material.dart';


class MotoCarsScreen extends StatelessWidget {
  const MotoCarsScreen({super.key});

    static const String name = 'MotoCarsScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuestros Motocargas'),
      ),
      
    );
  }
}