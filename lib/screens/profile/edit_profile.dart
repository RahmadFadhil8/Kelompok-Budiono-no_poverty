import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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

  String readableLocation = "Tidak ada lokasi";

  List<String> skills = [];

  final userService = UserProfileServices();
  UserModelFix? userData;
  bool isLoading = true;

  String urlImgProfile = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final user = await userService.getUserProfileOnce();

      final lat = user.location.latitude;
      final lng = user.location.longitude;

      nameC.text = user.name;
      emailC.text = widget.user.email ?? "";
      phoneC.text = user.phone;
      locationC.text = "$lat,$lng";
      bioC.text = user.bio;
      skills = List<String>.from(user.skills);

      readableLocation = await _toReadableAddress(lat, lng);

      setState(() {
        userData = user;
        urlImgProfile = user.imageUrl;
        isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          userData = UserModelFix.empty(widget.user.uid);
          isLoading = false;
        });
      }
    }
  }

  Future<String> _toReadableAddress(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isEmpty) return "Lokasi tidak ditemukan";

      final p = placemarks.first;

      return "${p.street}, ${p.subLocality}, ${p.locality}, ${p.administrativeArea}, ${p.country}";
    } catch (e) {
      return "Tidak dapat membaca alamat";
    }
  }

  Future<void> updateReadableLocationField() async {
    final loc = locationC.text.trim();
    if (!loc.contains(",")) {
      setState(() => readableLocation = "Format lokasi salah");
      return;
    }

    try {
      final parts = loc.split(",");
      final lat = double.parse(parts[0].trim());
      final lng = double.parse(parts[1].trim());

      final address = await _toReadableAddress(lat, lng);

      setState(() => readableLocation = address);
    } catch (_) {
      setState(() => readableLocation = "Lokasi tidak valid");
    }
  }

  Future<void> imageSelect() async {
    try {
      bool granted = false;

      if (Platform.isAndroid) {
        final p = await Permission.photos.request();
        final s = await Permission.storage.request();
        granted = p.isGranted || s.isGranted;
      } else {
        final p = await Permission.photos.request();
        granted = p.isGranted;
      }

      if (!granted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Izin galeri ditolak")),
          );
        }
        return;
      }

      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked == null) return;

      setState(() => isLoading = true);

      final file = File(picked.path);

      final uploadedUrl =
          await userService.uploadUserImage(widget.user.uid, file);

      if (uploadedUrl != null && uploadedUrl.isNotEmpty) {
        urlImgProfile = uploadedUrl;

        await userService.editUserProfile(
          UserModelFix.fromMap(widget.user.uid, {"image_url": urlImgProfile}),
        );

        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Foto diperbarui")));
        }
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  /// GET GPS
  Future<void> _getCurrentLocation() async {
    setState(() => isLoading = true);

    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      locationC.text = "${pos.latitude},${pos.longitude}";

      readableLocation = await _toReadableAddress(
        pos.latitude,
        pos.longitude,
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    nameC.dispose();
    emailC.dispose();
    phoneC.dispose();
    locationC.dispose();
    bioC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading && userData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(
                       userData!.imageUrl == ""? urlImgProfile:"",
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: imageSelect,
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

              const Text(
                "Lokasi (lat,long)",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: locationC,
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                      onChanged: (_) => updateReadableLocationField(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _getCurrentLocation,
                    icon: const Icon(Icons.my_location, color: Colors.blue),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                "📍 $readableLocation",
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 16),

              _input("Bio", bioC, maxLines: 3),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _onSavePressed,
                  child: const Text("Simpan Perubahan"),
                ),
              ),
            ],
          ),

          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
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

  Future<void> _onSavePressed() async {
    double lat = 0, lng = 0;

    try {
      final parts = locationC.text.trim().split(",");
      lat = double.parse(parts[0].trim());
      lng = double.parse(parts[1].trim());
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Format lokasi salah")),
      );
      return;
    }

    final data = {
      "name": nameC.text.trim(),
      "email": emailC.text.trim(),
      "phone": phoneC.text.trim(),
      "location": GeoPoint(lat, lng),
      "bio": bioC.text.trim(),
      "skills": skills,
      "updated_at": Timestamp.now(),
    };

    final model = UserModelFix.fromMap(widget.user.uid, data);
    await onSave(model);
  }

  Future<void> onSave(UserModelFix data) async {
    setState(() => isLoading = true);

    try {
      await userService.editUserProfile(data);

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Perubahan disimpan")));
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
}
