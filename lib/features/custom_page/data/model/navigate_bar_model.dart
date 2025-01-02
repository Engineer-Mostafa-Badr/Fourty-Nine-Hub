import 'package:fourtyninehub/features/custom_page/domain/entity/navigate_bar_entity.dart';

class NavigateBarModel extends NavigateBarEntity {
  NavigateBarModel({
    required super.id,
    required super.userId,
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
  });

  factory NavigateBarModel.fromJson(Map<String, dynamic> json) {
    NavigateBarFeature parseFeature(Map<String, dynamic> featureJson) {
      return NavigateBarFeature(
        nameEn: featureJson['nameEn'],
        nameAr: featureJson['nameAr'],
        enabled: featureJson['enabled'],
      );
    }

    return NavigateBarModel(
      id: json['_id'],
      userId: json['userId'],
      find: parseFeature(json['Find']),
      health: parseFeature(json['Health']),
      live: parseFeature(json['Live']),
      loading: parseFeature(json['Loading']),
      meal: parseFeature(json['Meal']),
      meet: parseFeature(json['Meet']),
      reel: parseFeature(json['Reel']),
      ride: parseFeature(json['Ride']),
      snap: parseFeature(json['Snap']),
      spotlight: parseFeature(json['Spotlight']),
    );
  }
}
