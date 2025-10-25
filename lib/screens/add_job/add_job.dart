import 'package:flutter/material.dart';
import 'package:no_poverty/screens/add_job/form_addjob.dart';
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 12),
        child: FormaddJob()
      ),
    );
  }
}