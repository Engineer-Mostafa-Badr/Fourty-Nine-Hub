class CreateCarPoolModel {
  final bool status;
  final String message;
  final String data; // This holds the trip ID or some reference data

  CreateCarPoolModel({
    required this.status,
    required this.message,
    required this.data,
  });

  // Factory constructor to create an instance from JSON
  factory CreateCarPoolModel.fromJson(Map<String, dynamic> json) {
    return CreateCarPoolModel(
      status: json['status'],
      message: json['message'],
      data: json['data'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data,
    };
  }
}
