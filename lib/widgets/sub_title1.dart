import 'package:flutter/material.dart';

class SubTitle1 extends StatelessWidget {
  final String title;
  final Color? color;
  final double? size;
  const SubTitle1({
    super.key,
    required this.title,
    this.color = Colors.grey,
    this.size = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Text(title, style: TextStyle(fontSize: size, color: color));
  }
}
