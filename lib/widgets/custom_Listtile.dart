import 'package:flutter/material.dart';

class CustomListile extends StatelessWidget {
  final String title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Color? tileColor;
  final VoidCallback? onTap;

  const CustomListile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.tileColor,
    this.onTap,
  });
  


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: tileColor ?? Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            if(leading != null) ...[
              leading!,
              SizedBox(width: 12,),
            ],

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    subtitle!,
                  ],
                ],
              )
            ),

            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}