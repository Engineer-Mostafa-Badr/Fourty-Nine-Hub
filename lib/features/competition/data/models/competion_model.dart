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
  final int? countOfRequest;

  CompetitionData({
    this.competitionId,
    this.countOfRequest,
  });

  factory CompetitionData.fromJson(Map<String, dynamic> json) {
    return CompetitionData(
      competitionId: json['competition_id'] == null
          ? null
          : CompetitionId.fromJson(json['competition_id'] as Map<String, dynamic>),
      countOfRequest: json['countOfRequest'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'competition_id': competitionId?.toJson(),
      'countOfRequest': countOfRequest,
    };
  }
}

class CompetitionId {
  final String? id;
  final String? nameAr;
  final String? nameEn;
  final String? descriptionEn;
  final String? descriptionAr;
  final int? maxRequests;

  CompetitionId({
    this.id,
    this.nameAr,
    this.nameEn,
    this.descriptionAr,
    this.descriptionEn,
    this.maxRequests,
  });

  factory CompetitionId.fromJson(Map<String, dynamic> json) {
    return CompetitionId(
      id: json['_id'] as String?,
      nameAr: json['nameAr'] as String?,
      nameEn: json['nameEn'] as String?,
      descriptionAr: json['descriptionAr'] as String?,
      descriptionEn: json['descriptionEn'] as String?,
      maxRequests: json['maxRequests'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'descriptionAr': descriptionAr,
      'descriptionEn': descriptionEn,
      'maxRequests': maxRequests,
    };
  }
}