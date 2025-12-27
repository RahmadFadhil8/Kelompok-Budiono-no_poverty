import 'package:cloud_firestore/cloud_firestore.dart';

class UserModelFix {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String bio;
  final String role; // "worker" | "employer" | "both"
  final bool verified;

  final String ktpUrl;
  final String imageUrl;
  final String? skckUrl;

  final GeoPoint location;
  final List<String> skills;

  final int totalJobsCompleted;
  final int totalRating;
  final int ratingCount;
  final double reliabilityScore;

  final List<String> certifications;

  final Timestamp createdAt;
  final Timestamp updatedAt;

  const UserModelFix({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.bio,
    required this.role,
    required this.verified,
    required this.ktpUrl,
    required this.imageUrl,
    this.skckUrl,
    required this.location,
    required this.skills,
    required this.totalJobsCompleted,
    required this.totalRating,
    required this.ratingCount,
    required this.reliabilityScore,
    required this.certifications,
    required this.createdAt,
    required this.updatedAt,
  });

  // -------------------------
  // FROM MAP (Firestore → Model)
  // -------------------------
  factory UserModelFix.fromMap(String id, Map<String, dynamic> data) {
    return UserModelFix(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      bio: data['bio'] ?? '',
      role: data['role'] ?? 'worker',
      verified: data['verified'] ?? false,
      ktpUrl: data['ktp_url'] ?? '',
      imageUrl: data['image_url'] ?? '',
      skckUrl: data['skck_url'],
      location: data['location'] ?? const GeoPoint(0, 0),
      skills: List<String>.from(data['skills'] ?? []),
      totalJobsCompleted: data['total_jobs_completed'] ?? 0,
      totalRating: data['total_rating'] ?? 0,
      ratingCount: data['rating_count'] ?? 0,
      reliabilityScore:
          (data['reliability_score'] ?? 0).toDouble(), // convert to double
      certifications: List<String>.from(data['certifications'] ?? []),
      createdAt: data['created_at'] ?? Timestamp.now(),
      updatedAt: data['updated_at'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toUpdateMap() {
  final data = <String, dynamic>{};

  if (name.isNotEmpty) data['name'] = name;
  if (email.isNotEmpty) data['email'] = email;
  if (phone.isNotEmpty) data['phone'] = phone;
  if (bio.isNotEmpty) data['bio'] = bio;

  data['role'] = role; 
  data['verified'] = verified;

  if (ktpUrl.isNotEmpty) data['ktp_url'] = ktpUrl;
  if (imageUrl.isNotEmpty) data['image_url'] = imageUrl;
  if (skckUrl != null) data['skck_url'] = skckUrl;

  data['location'] = location;
  if (skills.isNotEmpty) data['skills'] = skills;

  data['total_jobs_completed'] = totalJobsCompleted;
  data['total_rating'] = totalRating;
  data['rating_count'] = ratingCount;
  data['reliability_score'] = reliabilityScore;

  if (certifications.isNotEmpty) {
    data['certifications'] = certifications;
  }

  data['updated_at'] = Timestamp.now();

  return data;
}


  factory UserModelFix.empty(String id) {
    return UserModelFix(
      id: id,
      name: "",
      email: "",
      phone: "",
      bio: "",
      role: "worker",
      verified: false,
      ktpUrl: "",
      imageUrl: "",
      skckUrl: null,
      location: const GeoPoint(0, 0),
      skills: const [],
      totalJobsCompleted: 0,
      totalRating: 0,
      ratingCount: 0,
      reliabilityScore: 0.0,
      certifications: const [],
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
    );
  }

  
}
