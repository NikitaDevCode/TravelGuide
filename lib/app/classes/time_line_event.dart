class TimeLineEvent {
  String year;
  String description;
  bool isFirst;

  TimeLineEvent({
    required this.year,
    required this.description,
    this.isFirst = false,
  });
}