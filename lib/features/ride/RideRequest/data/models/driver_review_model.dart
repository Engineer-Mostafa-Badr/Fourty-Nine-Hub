import '../../domain/entity/driver_review_entity.dart';

class ReviewModel extends ReviewEntity {
  ReviewModel({required super.id, required super.name, required super.comment, required super.rate, required super.createdAt});
  
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      name: json['name'],
      comment: json['comment'],
      rate: json['rate'],
      createdAt: json['created_at'],
    );
  }
}
