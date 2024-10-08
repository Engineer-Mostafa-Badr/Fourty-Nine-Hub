import 'package:fourtyninehub/features/custom_page/domain/entity/navigate_bar_entity.dart';

class NavigateBarModel extends NavigateBarEntity {
  NavigateBarModel(
      {required super.id,
      required super.userId,
      required super.chat,
      required super.find,
      required super.health,
      required super.live,
      required super.loading,
      required super.meal,
      required super.meet,
      required super.reel,
      required super.ride,
      required super.snap,
      required super.spotlight,
      required super.tweet});

  factory NavigateBarModel.fromJson(Map<String, dynamic> json) {
    return NavigateBarModel(
      id: json['_id'],
      userId: json['userId'],
      chat: json['Chat'],
      find: json['Find'],
      health: json['Health'],
      live: json['Live'],
      loading: json['Loading'],
      meal: json['Meal'],
      meet: json['Meet'],
      reel: json['Reel'],
      ride: json['Ride'],
      snap: json['Snap'],
      spotlight: json['Spotlight'],
      tweet: json['Tweet'],
    );
  }
}
