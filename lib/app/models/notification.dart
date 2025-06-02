class Notification {
  int id;
  String title;
  DateTime dateTimeNotification;
  int notificationTypeId;
  Notification({required this.id, required this.title, required this.dateTimeNotification, required this.notificationTypeId});
  factory Notification.fromMap(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      title: json['title'],
      dateTimeNotification: DateTime.parse(json['dateTimeNotification']),
      notificationTypeId: json['notificationTypeId']
    );
  }
}