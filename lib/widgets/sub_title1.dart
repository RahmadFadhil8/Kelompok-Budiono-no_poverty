import 'package:flutter/material.dart';

class SubTitle1 extends StatelessWidget {
  final String title;
  final Color? color;
  final double? size;
  final TextAlign? textAlign;
  const SubTitle1({
    super.key,
    required this.title,
    this.color = Colors.grey,
    this.size = 18,
    this.textAlign
  });

  @override
  Widget build(BuildContext context) {
    return Text(title, style: TextStyle(fontSize: size, color: color),textAlign: textAlign,);
  }
}
