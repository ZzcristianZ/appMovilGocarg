import 'package:flutter/material.dart';




class MenuItems {
  final String title;
  final Icon icon;

  MenuItems({
    required this.title, 
    required this.icon
    });
}

final appMenuItems = <MenuItems>[
  MenuItems(
    title: 'Home',
    icon: Icon(Icons.house_rounded),
  ),
  MenuItems(
    title: 'Cars',
    icon: Icon(Icons.airport_shuttle_outlined),
  ),
  MenuItems(
    title: 'MotoCars',
    icon: Icon(Icons.motorcycle_sharp),
  ),
  MenuItems(
    title: 'Mi Perfil',
    icon: Icon(Icons.person),
  ),
  
];