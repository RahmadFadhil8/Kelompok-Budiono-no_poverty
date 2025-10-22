class JobModel {
  final int id;
  final String title;
  final String description;
  final int salary;
  final String location;
  final String date;
  final int userId;
  final String username;

  JobModel({
    required this.id,
    required this.title,
    required this.description,
    required this.salary,
    required this.location,
    required this.date,
    required this.userId,
    required this.username,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      salary: json['salary'] ?? 0,
      location: json['location'] ?? '',
      date: json['date'] ?? '',
      userId: json['userId'] ?? 0,
      username: json['username'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'salary': salary,
        'location': location,
        'date': date,
        'userId': userId,
        'username': username,
      };
}
