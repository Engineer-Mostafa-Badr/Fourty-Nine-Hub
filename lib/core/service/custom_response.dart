class CustomResponse<T> {
  final String message;
  final bool status;
  final T? data;

  CustomResponse(
      {required this.message, required this.status, required this.data});

  factory CustomResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic json) fromJsonT) {
    return CustomResponse<T>(
        message: json['message'] as String,
        status: json['status'] as bool,
        data: json['data'] != null ? fromJsonT(json['data']) : null);
  }
}
