import '../../domain/entities/instapay_cache_out_entity.dart';

class InstapayCacheOutModel extends InstapayCacheOutEntity {
  InstapayCacheOutModel(
      {required super.status,
      required super.message,
      required super.id,
      required super.userId,
      required super.defaultCard,
      required super.autoCharge,
      required super.createdAt,
      required super.updatedAt,
      required super.instaPay});

  factory InstapayCacheOutModel.fromJson(Map<String, dynamic> json) {
    return InstapayCacheOutModel(
      status: json['status'],
      message: json['message'],
      id: json['data']['_id'],
      userId: json['data']['userId'],
      defaultCard: json['data']['defaultCard'],
      autoCharge: json['data']['autoCharge'],
      createdAt: json['data']['createdAt'],
      updatedAt: json['data']['updatedAt'],
      instaPay: json['data']['instaPay'],
    );
  }
}
