class EventMuseum {
  int id;
  String name;
  String description;
  DateTime dateTime;

  EventMuseum({
    required this.id,
    required this.name,
    required this.description,
    required this.dateTime,
  });

  factory EventMuseum.fromMap(Map<String, dynamic> json) {
    return EventMuseum(
      id: json['id'],
      name: json['nameEvent'],
      description: json['description'],
      dateTime: DateTime.parse(json['dateTimeEvent']),
    );
  }
}