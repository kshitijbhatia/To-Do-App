class User {
  final String _username;
  final String _email;
  final String _password;
  final String _createdAt;
  final String? _updatedAt;

  User(
      {required String username,
      required String email,
      required String password,
      required String createdAt,
      String? updatedAt})
      : _username = username,
        _email = email,
        _password = password,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  String get getEmail => _email;

  String get getUserName => _username;

  String get getCreatedAt => _createdAt;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        email: json['email'],
        username: json['username'],
        password: json['password'],
        createdAt: json['createdAt']
    );
  }

  Map<String, String> toJson(){
    return {
      "email" : _email,
      "username" : _username,
      "password" : _password,
      "createdAt" : _createdAt
    };
  }
}
