class DoctorMeetingEntity {
  final String id;
  final String roomId;
  final String userId;
  final bool isFinish;
  final String startDate;
  final String endDate;
  final String title;
  final List<int>? members;
  final String createdAt;
  final String updatedAt;

  DoctorMeetingEntity(
      {required this.id,
      required this.roomId,
      required this.userId,
      required this.isFinish,
      required this.startDate,
      required this.endDate,
      required this.title,
      this.members,
      required this.createdAt,
      required this.updatedAt});

  //toJson
  Map<String, dynamic> toJson() => {
        'id': id,
        'roomId': roomId,
        'userId': userId,
        'isFinish': isFinish,
        'startDate': startDate,
        'endDate': endDate,
        'title': title,
        'members': members,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
