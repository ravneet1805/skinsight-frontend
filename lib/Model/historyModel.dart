class HistoryItem {
  String disease;
  List<String> precautions;

  HistoryItem({
    required this.disease,
    required this.precautions,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      disease: json['disease'],
      precautions: List<String>.from(json['precautions']),
    );
  }
}
