class CompetitionModel {
  final bool? status;
  final String? message;
  final List<CompetitionData>? data;

  CompetitionModel({
    this.status,
    this.message,
    this.data,
  });

  factory CompetitionModel.fromJson(Map<String, dynamic> json) {
    return CompetitionModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CompetitionData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class CompetitionData {
  final CompetitionId? competitionId;
  final int? amount;

  CompetitionData({
    this.competitionId,
    this.amount,
  });

  factory CompetitionData.fromJson(Map<String, dynamic> json) {
    return CompetitionData(
      competitionId: json['competition_id'] == null
          ? null
          : CompetitionId.fromJson(json['competition_id'] as Map<String, dynamic>),
      amount: json['amount'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'competition_id': competitionId?.toJson(),
      'amount': amount,
    };
  }
}

class CompetitionId {
  final String? id;
  final String? name;
  final int? withdrawLimit;

  CompetitionId({
    this.id,
    this.name,
    this.withdrawLimit,
  });

  factory CompetitionId.fromJson(Map<String, dynamic> json) {
    return CompetitionId(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      withdrawLimit: json['withdrawLimit'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'withdrawLimit': withdrawLimit,
    };
  }
}