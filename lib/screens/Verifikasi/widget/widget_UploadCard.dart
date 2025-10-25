import 'dart:io';
import 'package:flutter/material.dart';

class UploadCard extends StatelessWidget {
  final String title;
  final File? file;
  final VoidCallback onTap;
  final String successText;
  final IconData iconData;
  final String hintText;

  const UploadCard({
    super.key,
    required this.title,
    required this.file,
    required this.onTap,
    required this.successText,
    required this.iconData,
    required this.hintText,

  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
          const SizedBox(height: 10,),
          InkWell(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue),
                color: Colors.grey[100],
              ),
              child: Column(
                children: [
                  if (file == null) ...[
                    Icon(iconData,
                    size: 36, color: Colors.blue,),
                    SizedBox(height: 6,),
                    Text(hintText, style: TextStyle(color: Colors.grey),),
                  ] else ...[
                    Text(file!.path.split("/").last,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13),)
                  ]
                ],
              ),
            ),
          ),
          if (file != null) ...[
            SizedBox(height: 8,),
            Row(children: [
              Icon(Icons.check_circle,
              color: Colors.green, size: 18,),
              const SizedBox(width: 6,),
              Text(successText, style: TextStyle(color: Colors.green),)
            ],)
          ]
        ],
      ),),
    );
  }
}
