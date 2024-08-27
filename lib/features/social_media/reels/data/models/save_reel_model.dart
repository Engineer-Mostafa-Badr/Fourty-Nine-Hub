class ReelSaveResponse {
  final bool? status;
  final bool? data;

  ReelSaveResponse({
    this.status,
    this.data,
  });

  factory ReelSaveResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return ReelSaveResponse();
    }
    return ReelSaveResponse(
      status: json['status'] as bool?,
      data: json['data'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data,
    }..removeWhere((key, value) => value == null);
  }

  @override
  String toString() {
    return 'GenericResponse(status: $status, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReelSaveResponse &&
        other.status == status &&
        other.data == data;
  }

  @override
  int get hashCode => status.hashCode ^ data.hashCode;

  ReelSaveResponse copyWith({
    bool? status,
    bool? data,
  }) {
    return ReelSaveResponse(
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }
}