import 'package:flutter/material.dart';
import 'package:no_poverty/models/job_model.dart';
import 'package:no_poverty/Database/job_database/job_database.dart';
import 'package:no_poverty/widgets/title1.dart';

class AddJob extends StatefulWidget {
  const AddJob({super.key});

  @override
  State<AddJob> createState() => _AddJobState();
}

class _AddJobState extends State<AddJob> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _salaryController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateController = TextEditingController();
  final JobDatabase jobDb = JobDatabase();

  Future<void> _submitJob() async {
    try {
      final job = JobModel(
        id: 0,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        salary: int.tryParse(_salaryController.text.trim()) ?? 0,
        location: _locationController.text.trim(),
        date: _dateController.text.trim(),
        userId: 1,
        username: 'Indra',
      );

      await jobDb.addJob(job);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Job berhasil ditambahkan!')),
      );

      // Kosongkan TextField
      _titleController.clear();
      _descriptionController.clear();
      _salaryController.clear();
      _locationController.clear();
      _dateController.clear();

      // Kembali ke halaman sebelumnya dan beri tahu ada update
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan job: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Title1(title: "Tambah Pekerjaan"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(hintText: 'Title')),
            const SizedBox(height: 10),
            TextField(controller: _descriptionController, decoration: const InputDecoration(hintText: 'Description')),
            const SizedBox(height: 10),
            TextField(controller: _salaryController, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'Salary')),
            const SizedBox(height: 10),
            TextField(controller: _locationController, decoration: const InputDecoration(hintText: 'Location')),
            const SizedBox(height: 10),
            TextField(controller: _dateController, decoration: const InputDecoration(hintText: 'Date (YYYY-MM-DD)')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _submitJob, child: const Text('Tambah Job')),
          ],
        ),
      ),
    );
  }
}
