class ReelSaveResponse {
  final bool? status;
  final String? message;

  ReelSaveResponse({this.status, this.message});

  factory ReelSaveResponse.fromJson(Map<String, dynamic> json) {
    return ReelSaveResponse(
      status: json['status'] ??
          false, // Handling null with a default value of `false`
      message:
          json['message'] ?? '', // Handling null with a default empty string
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}
