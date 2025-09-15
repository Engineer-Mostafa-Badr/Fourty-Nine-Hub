import 'package:fourtyninehub/features/auction/domain/entities/add_favorite_auction_entity.dart';

class AddFavoriteAuctionModel extends AddFavoriteAuctionEntity {
  const AddFavoriteAuctionModel({
    bool? status,
    String? message,
  }) : super(
    status: status,
    message: message,
  );

  factory AddFavoriteAuctionModel.fromJson(Map<String, dynamic> json) {
    return AddFavoriteAuctionModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }
}
// MODEL
class CreateAuctionModel extends CreateAuctionEntity {
  const CreateAuctionModel({
    bool? status,
    String? message,
    AuctionSubscriptionData? data,
  }) : super(
    status: status,
    message: message,
    data: data,
  );

  factory CreateAuctionModel.fromJson(Map<String, dynamic> json) {
    return CreateAuctionModel(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? AuctionSubscriptionDataModel.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': (data as AuctionSubscriptionDataModel?)?.toJson(),
    };
  }
}

class AuctionSubscriptionDataModel extends AuctionSubscriptionData {
  const AuctionSubscriptionDataModel({
    bool? endPointSubscription,
    bool? userSubscription,
    String? subCategoryId,
    List<String>? paymentMethod,
  }) : super(
    endPointSubscription: endPointSubscription,
    userSubscription: userSubscription,
    subCategoryId: subCategoryId,
    paymentMethod: paymentMethod,
  );

  factory AuctionSubscriptionDataModel.fromJson(Map<String, dynamic> json) {
    return AuctionSubscriptionDataModel(
      endPointSubscription: json['endPointSubscription'] as bool?,
      userSubscription: json['userSubscription'] as bool?,
      subCategoryId: json['subCategoryId'] as String?,
      paymentMethod: (json['paymentMethod'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'endPointSubscription': endPointSubscription,
      'userSubscription': userSubscription,
      'subCategoryId': subCategoryId,
      'paymentMethod': paymentMethod,
    };
  }
}
