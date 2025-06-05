class Exhibit {
  int id;
  String label;
  String exhibitImagePath;
  Exhibit({required this.id, required this.label, required this.exhibitImagePath});
  factory Exhibit.fromMap(Map<String, dynamic> json) {
    return Exhibit(
      id: json['id'],
      label: json['label'],
      exhibitImagePath: json['exhibitImagePath']
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'exhibitImagePath': exhibitImagePath
    };
  }
}