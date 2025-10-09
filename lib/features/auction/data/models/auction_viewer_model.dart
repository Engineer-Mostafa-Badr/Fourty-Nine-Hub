import '../../domain/entities/auction_viewer_entity.dart';

class AuctionViewerModel extends AuctionViewerEntity {
  AuctionViewerModel({
    String? firstName,
    String? lastName,
    String? profilePictureKey,
    String? gender,
  }) : super(
    firstName: firstName,
    lastName: lastName,
    profilePictureKey: profilePictureKey,
    gender: gender,
  );

  factory AuctionViewerModel.fromJson(Map<String, dynamic> json) {
    return AuctionViewerModel(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      profilePictureKey: json['profilePictureKey'] as String?,
      gender: json['gender'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'profilePictureKey': profilePictureKey,
      'gender': gender,
    };
  }
}