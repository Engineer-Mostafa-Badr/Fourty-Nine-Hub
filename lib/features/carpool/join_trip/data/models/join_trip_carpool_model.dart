class JoinTripCarpoolModel {
  final bool status;
  final String message;

  JoinTripCarpoolModel({
    required this.status,
    required this.message,
  });

  // Factory constructor to create an instance from JSON
  factory JoinTripCarpoolModel.fromJson(Map<String, dynamic> json) {
    return JoinTripCarpoolModel(
      status: json['status'],
      message: json['message'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}
