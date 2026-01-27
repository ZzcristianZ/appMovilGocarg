import 'package:flutter/material.dart';


class Side {
  final String title;
  final Widget body;
  final List<Widget>? actions;

  Side({
    required this.title,
    required this.body,
    this.actions,
  });
}
