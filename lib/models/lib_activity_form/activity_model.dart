class ActivityModel {
  final int id;
  final String date;
  final String activityName;
  final String activityDescription;
  final String bookDetails;
  final String participantsGrades;
  final String participantsNumber;
  final String conductedBy;
  final String createdAt;
  final String school;
  final String createdBy;

  ActivityModel({
    required this.id,
    required this.date,
    required this.activityName,
    required this.activityDescription,
    required this.bookDetails,
    required this.participantsGrades,
    required this.participantsNumber,
    required this.conductedBy,
    required this.createdAt,
    required this.school,
    required this.createdBy,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: int.parse(json['id'].toString()),
      date: json['date'] ?? '',
      activityName: json['activity_name'] ?? '',
      activityDescription: json['activity_description'] ?? '',
      bookDetails: json['book_details'] ?? '',
      participantsGrades: json['participants_grades'] ?? '',
      participantsNumber: json['participants_number'] ?? '',
      conductedBy: json['conducted_by'] ?? '',
      createdAt: json['created_at'] ?? '',
      school: json['school'] ?? '',
      createdBy: json['created_by'] ?? '',
    );
  }
}