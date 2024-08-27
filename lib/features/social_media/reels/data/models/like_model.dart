class ReelLikeResponse {
  final bool status;
  final String message;

  ReelLikeResponse({
    required this.status,
    required this.message,
  });

  // Factory constructor to create a ReelUnlikeResponse from JSON
  factory ReelLikeResponse.fromJson(Map<String, dynamic> json) {
    return ReelLikeResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
    );
  }

  // Method to convert ReelUnlikeResponse to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}
