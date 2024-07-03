import '../../../../ads_feature/ads/data/models/publisher_model.dart';
import '../../domain/entities/users_list_entity.dart';

class UsersListModel extends UsersListEntity {
  UsersListModel({required super.id, required super.user});
  factory UsersListModel.fromJson(Map<String, dynamic> json) {
    return UsersListModel(
      id: json['id'],
      user: PublisherModel.fromJson(json['user'])
    );
  }
}
