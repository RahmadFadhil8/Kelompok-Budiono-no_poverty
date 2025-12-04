import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JobModelFix {
  final String job_id;
  final String employer_id;
  final String title;
  final String description;
  final String category;
  final GeoPoint location;
  final String address;
  final double wage;
  final DateTime date_time;
  final Timestamp start_time;
  final Timestamp end_time;
  final List<String> requiredSkills;
  final String status;
  final List<String> worker_id_apply;
  final String? selected_worker_id;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  const JobModelFix({
    required this.job_id,
    required this.employer_id,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.address,
    required this.wage,
    required this.date_time,
    required this.start_time,
    required this.end_time,
    required this.requiredSkills,
    required this.status,
    required this.worker_id_apply,
    this.selected_worker_id,
    required this.createdAt,
    required this.updatedAt
  });

  factory JobModelFix.fromMap(String id, Map<String, dynamic> data) {
    return JobModelFix(
      job_id: id, 
      employer_id: data["employer_id"], 
      title: data["title"], 
      description: data["description"], 
      category: data["category"], 
      location: data["location"], 
      address: data["address"], 
      wage: (data["wage"] as num).toDouble(), 
      date_time: data["date_time"],
      start_time: data["start_time"], 
      end_time: data["end_time"], 
      requiredSkills: List<String>.from(data["required_skills"] ?? []), 
      status: data["open"], 
      worker_id_apply: List<String>.from(data["worker_id_apply"] ?? []), 
      selected_worker_id: data["selected_worker_id"],
      createdAt: data["createdAt"], 
      updatedAt: data["updatedAt"]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'employer_id': employer_id,
      'title': title,
      'description': description,
      'category': category,
      'location': location,
      'address': address,
      'wage': wage,
      'date_time': date_time,
      'start_time': start_time,
      'end_time': end_time,
      'required_skills': requiredSkills,
      'status': status,
      'worker_id_apply': worker_id_apply,
      'selected_worker_id': selected_worker_id,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}