import 'package:flutter/material.dart';
import 'package:no_poverty/widgets/title1.dart';

class addJob extends StatefulWidget {
  const addJob({super.key});

  @override
  State<addJob> createState() => _addJobState();
}

class _addJobState extends State<addJob> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title1(title: "Tambah Pekerjaan"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TextField(
            
          )
        ],
      ),
    );
  }
}