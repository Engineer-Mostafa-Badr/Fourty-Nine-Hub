class AddNewPickMeModel {
  final bool status;
  final String message;

  AddNewPickMeModel({
    required this.status,
    required this.message,
  });

  factory AddNewPickMeModel.fromJson(Map<String, dynamic> json) {
    return AddNewPickMeModel(
      status: json['status'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}
