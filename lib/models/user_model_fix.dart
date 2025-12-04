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
  final String selfieUrl;
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
    required this.selfieUrl,
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
      selfieUrl: data['selfie_url'] ?? '',
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

  // -------------------------
  // TO MAP (Model → Firestore)
  // -------------------------
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'bio': bio,
      'role': role,
      'verified': verified,
      'ktp_url': ktpUrl,
      'selfie_url': selfieUrl,
      'skck_url': skckUrl,
      'location': location,
      'skills': skills,
      'total_jobs_completed': totalJobsCompleted,
      'total_rating': totalRating,
      'rating_count': ratingCount,
      'reliability_score': reliabilityScore,
      'certifications': certifications,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // -------------------------
  // COPY WITH
  // -------------------------
  UserModelFix copyWith({
    String? name,
    String? email,
    String? phone,
    String? bio,
    String? role,
    bool? verified,
    String? ktpUrl,
    String? selfieUrl,
    String? skckUrl,
    GeoPoint? location,
    List<String>? skills,
    int? totalJobsCompleted,
    int? totalRating,
    int? ratingCount,
    double? reliabilityScore,
    List<String>? certifications,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return UserModelFix(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      role: role ?? this.role,
      verified: verified ?? this.verified,
      ktpUrl: ktpUrl ?? this.ktpUrl,
      selfieUrl: selfieUrl ?? this.selfieUrl,
      skckUrl: skckUrl ?? this.skckUrl,
      location: location ?? this.location,
      skills: skills ?? this.skills,
      totalJobsCompleted: totalJobsCompleted ?? this.totalJobsCompleted,
      totalRating: totalRating ?? this.totalRating,
      ratingCount: ratingCount ?? this.ratingCount,
      reliabilityScore: reliabilityScore ?? this.reliabilityScore,
      certifications: certifications ?? this.certifications,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
