class UserData {
  int? id;
  int userId;
  String name;
  int age;
  String birthDate;
  String userGroup;
  String profileImagePath = '';
  String favoriteExhibits = '';
  String settings = '';

  UserData({
    this.id,
    required this.userId,
    required this.name,
    required this.age,
    required this.birthDate,
    required this.userGroup,
    required this.profileImagePath,
    required this.favoriteExhibits,
    required this.settings,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'age': age,
      'birthDate': birthDate,
      'userGroup': userGroup,
      'profileImagePath': profileImagePath,
      'favoriteExhibits': favoriteExhibits,
      'settings': settings
    };
  }

  factory UserData.fromMap(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      age: json['age'],
      birthDate: json['birthDate'],
      userGroup: json['userGroup'],
      profileImagePath: json['profileImagePath'],
      favoriteExhibits: json['favoriteExhibits'],
      settings: json['settings']
    );
  }
}