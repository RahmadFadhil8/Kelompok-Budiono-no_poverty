class JobModel {
  JobModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.salary,
    required this.location,
    required this.date,
    required this.isDone,
  });

  final int id;
  final int userId;
  final String title;
  final String description;
  final String salary;
  final String location;
  final DateTime? date;
  final bool isDone;

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json["id"] ?? 0,
      userId: json["userId"] ?? 0,
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      salary: json["salary"] ?? "",
      location: json["location"] ?? "",
      date: json["date"] != null ? DateTime.tryParse(json["date"]) : null,
      isDone: json["isDone"] is int
          ? json["isDone"] == 1 
          : json["isDone"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "title": title,
        "description": description,
        "salary": salary,
        "location": location,
        "date": date != null
            ? "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}"
            : null,
        "isDone": isDone ? 1 : 0, 
      };
}
