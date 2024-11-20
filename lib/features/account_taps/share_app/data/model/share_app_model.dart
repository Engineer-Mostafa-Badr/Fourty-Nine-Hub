import 'package:fourtyninehub/features/account_taps/share_app/domain/entity/share_app_entity.dart';

class ShareAppModel extends ShareAppEntity {
  ShareAppModel(
      {required super.referralId,
      required super.shareBalance,
      required super.userCount,
      required super.referralGift,
      });

  factory ShareAppModel.fromJson(Map<String, dynamic> json) {
    return ShareAppModel(
      referralId: json['referralId'] ?? '',
      shareBalance: json['shareBalance'] ?? 0,
      userCount: json['userCount'] ?? 0,
      referralGift: json['referralGift'] ?? 0,
    );
  }
}
