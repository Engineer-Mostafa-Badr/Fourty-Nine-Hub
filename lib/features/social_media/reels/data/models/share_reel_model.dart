class ReelShareResponse {
  final bool? status;
  final String? message;

  ReelShareResponse({
    this.status,
    this.message,
  });

  factory ReelShareResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return ReelShareResponse();
    }
    return ReelShareResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    }..removeWhere((key, value) => value == null);
  }

  @override
  String toString() {
    return 'ReelShareResponse(status: $status, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReelShareResponse &&
        other.status == status &&
        other.message == message;
  }

  @override
  int get hashCode => status.hashCode ^ message.hashCode;

  ReelShareResponse copyWith({
    bool? status,
    String? message,
  }) {
    return ReelShareResponse(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}