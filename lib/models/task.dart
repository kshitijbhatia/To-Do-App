class Task {
  int _id;
  String _title;
  String _description;
  String _createdAt;
  String? _updatedAt;

  Task(
      {required int id,
        required String title,
      required String description,
      required String createdAt})
      : _id = id,
        _title = title,
        _description = description,
        _createdAt = createdAt;

  int get getId => _id;

  String get getTitle => _title;

  String get getDescription => _description;

  String get getCreatedAt => _createdAt;

  factory Task.fromJson(Map<String, Object> json) {
    return Task(
      id : int.parse(json['id'].toString()),
      title: json['title']!.toString(),
      description: json['description']!.toString(),
      createdAt: json['createdAt']!.toString(),
    );
  }
}
