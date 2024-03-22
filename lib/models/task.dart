class Task {
  String _id;
  String _email;
  String _title;
  String _description;
  String _createdAt;
  String? _updatedAt;

  Task({
      required String id,
      required String email,
      required String title,
      required String description,
      required String createdAt})
      : _id = id,
        _email = email,
        _title = title,
        _description = description,
        _createdAt = createdAt;

  String get getId => _id;

  String get getEmail => _email;

  String get getTitle => _title;

  String get getDescription => _description;

  String get getCreatedAt => _createdAt;

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      email: json['email'],
      title: json['title'],
      description: json['description'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "id" : _id,
      "email" : _email,
      "title" : _title,
      "description" : _description,
      "createdAt" : _createdAt,
    };
  }
}
