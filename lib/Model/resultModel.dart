class Disease {
  List<String> precautions;
  String name;

  Disease({required this.precautions, required this.name});

  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      precautions: List<String>.from(json['precautions']),
      name: json['predicted_class'],
    );
  }
}
