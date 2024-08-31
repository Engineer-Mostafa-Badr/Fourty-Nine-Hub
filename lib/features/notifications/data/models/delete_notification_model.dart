class DeleteNotificationModel {
  final bool? status;
  final String? message;

  DeleteNotificationModel({
    this.status,
    this.message,
  });

  factory DeleteNotificationModel.fromJson(Map<String, dynamic> json) {
    return DeleteNotificationModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
    );
  }
}
