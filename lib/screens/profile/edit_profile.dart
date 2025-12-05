import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:no_poverty/models/user_model_fix.dart';
import 'package:no_poverty/services/user_profile_services.dart';

class EditProfile extends StatefulWidget {
  final User user;
  const EditProfile({super.key, required this.user});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final phoneC = TextEditingController();
  final locationC = TextEditingController();
  final bioC = TextEditingController();

  var skills = [];

  final userService = UserProfileServices();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final user = await userService.getUserProfileOnce();
    final lat = user.location.latitude;
    final lng = user.location.longitude;

    nameC.text = user.name;
    emailC.text = widget.user.email!;
    phoneC.text = user.phone;
    locationC.text = "$lat,$lng";
    bioC.text = user.bio;
    skills = user.skills;

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile Template"), elevation: 0),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        "https://rxrdxiluiipvixhmaxms.supabase.co/storage/v1/object/sign/jobWaroengStorage/IMG_20240501_235806_448.jpg?token=eyJraWQiOiJzdG9yYWdlLXVybC1zaWduaW5nLWtleV9hNThmOTQxZi02ZTY2LTQxYzYtOTkyYS01NzFhM2U0YjRkN2YiLCJhbGciOiJIUzI1NiJ9.eyJ1cmwiOiJqb2JXYXJvZW5nU3RvcmFnZS9JTUdfMjAyNDA1MDFfMjM1ODA2XzQ0OC5qcGciLCJpYXQiOjE3NjQ5MjM4NDEsImV4cCI6MTc2NTUyODY0MX0.SxPISVa9Y5KJxgOiUoFi9c8re8CEruo65_BO5WQE1J8",
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Edit Foto button (dummy)
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.blue),
                      ),
                      onPressed: _onEditPhoto,
                      icon: const Icon(Icons.edit),
                      label: const Text("Edit Foto"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              _input("Nama", nameC),
              _input("Email", emailC),
              _input("Nomor Telpon", phoneC),
              _input("Lokasi (lat,long)", locationC),
              _input("Bio", bioC, maxLines: 3),

              const SizedBox(height: 16),
              const Text(
                "Kategori Skill",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Skill section: add button + chips
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: _showAddSkillDialog,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text("Tambah Skill"),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      "Ketik lalu tekan Tambah untuk membuat skill baru. Tap chip untuk menghapus.",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    skills
                        .map(
                          (e) => Chip(
                            side: BorderSide(color: Colors.blue),
                            deleteIconColor: Colors.red,
                            color: WidgetStatePropertyAll(Colors.white),
                            backgroundColor: Colors.blue,
                            label: Text(
                              e,
                              style: TextStyle(color: Colors.blue),
                            ),
                            onDeleted: () => _removeSkill(e),
                          ),
                        )
                        .toList(),
              ),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    final parts = locationC.text.split(',');
                    final lat = double.parse(parts[0].trim());
                    final lng = double.parse(parts[1].trim());
                    final data = {
                      "name": nameC.text.trim(),
                      "email": emailC.text.trim(),
                      "phone": phoneC.text.trim(),
                      "location": GeoPoint(lat, lng),
                      "bio": bioC.text.trim(),
                      "skills": skills,
                      "updated_at": Timestamp.now(),
                    };
                    onSave(UserModelFix.fromMap(widget.user.uid, data));
                  },
                  child: const Text("Simpan Perubahan"),
                ),
              ),
            ],
          ),

          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _input(String label, TextEditingController c, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          TextField(
            controller: c,
            maxLines: maxLines,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
        ],
      ),
    );
  }

  void onSave(UserModelFix data) {
    UserProfileServices().editUserProfile(data);

    setState(() => isLoading = true);

    Future.delayed(const Duration(seconds: 1), () {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Perubahan tersimpan")));
    });
  }

  void _onEditPhoto() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Edit Foto (dummy) - tambahkan image_picker di sini"),
      ),
    );
  }

  void _showAddSkillDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Tambah Skill"),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Misal: las, cat, plumbing",
              ),
              autofocus: true,
              onSubmitted: (_) => _addSkillFromDialog(controller, ctx),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () => _addSkillFromDialog(controller, ctx),
                child: const Text("Tambah"),
              ),
            ],
          ),
    );
  }

  void _addSkillFromDialog(TextEditingController controller, BuildContext ctx) {
    final val = controller.text.trim();
    if (val.isNotEmpty && !skills.contains(val)) {
      setState(() => skills.add(val));
    }
    Navigator.of(ctx).pop();
  }

  void _removeSkill(String skill) {
    setState(() => skills.remove(skill));
  }
}
