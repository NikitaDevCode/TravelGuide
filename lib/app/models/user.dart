class User {
  int id;
  String email;
  String login;
  User({required this.id, required this.email, required this.login});
  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      login: json['login']
    ); 
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'login': login
    };
  }
}