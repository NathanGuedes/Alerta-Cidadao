class AlertModel {
  final String id;
  final String description;
  final String problemType;
  final String street;
  final String neighborhood;
  final String referencePoint;
  final List<String> imageUrls;
  final DateTime dateTime;

  AlertModel({
    required this.id,
    required this.description,
    required this.problemType,
    required this.street,
    required this.neighborhood,
    required this.referencePoint,
    required this.imageUrls,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'problem_type': problemType,
      'street': street,
      'neighborhood': neighborhood,
      'reference_point': referencePoint,
      'image_urls': imageUrls.join('|'),
      'date_time': dateTime.toIso8601String(),
    };
  }
}