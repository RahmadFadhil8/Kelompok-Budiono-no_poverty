import 'package:flutter/material.dart';

class Title1 extends StatelessWidget {
  final String title;
  final Color? color;
  final double? size;
  final FontWeight? fontWeight;
  const Title1({
    super.key,
    required this.title,
    this.color = Colors.black,
    this.size = 20,
    this.fontWeight =FontWeight.bold
  });

  @override
  Widget build(BuildContext context) {
    return Text(title, style: TextStyle(fontSize: size, color: color, fontWeight: fontWeight));
  }
}
