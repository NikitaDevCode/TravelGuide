import '/libraries/models.dart';

class Exposition {
  String label;
  String? label2;
  String expositionImagePath;
  List<Exhibit>? exhibits;
  Exposition({required this.label, required this.label2, required this.expositionImagePath, required this.exhibits});
  factory Exposition.fromMap(Map<String, dynamic> json) {
    return Exposition(
      label: json['label'],
      label2: json['label2'],
      expositionImagePath: json['expositionImagePath'],
      exhibits: (json['exhibits'] as List).map((e) => Exhibit.fromMap(e)).toList()
    );
  }
}