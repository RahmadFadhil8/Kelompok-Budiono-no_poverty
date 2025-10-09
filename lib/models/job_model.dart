class JobModel {
  JobModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.title,
    required this.description,
    required this.salary,
    required this.location,
    required this.date,
    required this.isDone,
  });

  final int id;
  final int userId;
  final String username;
  final String title;
  final String description;
  final String salary;
  final String location;
  final String date;
  final bool isDone;

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json["id"] ?? 0,
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      salary: json["salary"] ?? "",
      location: json["location"] ?? "",
      date: json["date"]??"",
      isDone:
          json["isDone"] is int ? json["isDone"] == 1 : json["isDone"] ?? false,
      userId: json["userId"] ?? 0,
      username: json["username"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "title": title,
        "description": description,
        "salary": salary,
        "location": location,
        "date": date,
        "isDone": isDone ? 1 : 0,
      };
}
