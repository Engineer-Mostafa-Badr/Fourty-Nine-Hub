class NavigateBarFeature {
  final String nameEn;
  final String nameAr;
  final bool enabled;

  NavigateBarFeature({
    required this.nameEn,
    required this.nameAr,
    required this.enabled,
  });
}

class NavigateBarEntity {
  final String id;
  final String userId;
  final NavigateBarFeature find;
  final NavigateBarFeature health;
  final NavigateBarFeature live;
  final NavigateBarFeature loading;
  final NavigateBarFeature meal;
  final NavigateBarFeature meet;
  final NavigateBarFeature reel;
  final NavigateBarFeature ride;
  final NavigateBarFeature snap;
  final NavigateBarFeature spotlight;

  NavigateBarEntity({
    required this.id,
    required this.userId,
    required this.find,
    required this.health,
    required this.live,
    required this.loading,
    required this.meal,
    required this.meet,
    required this.reel,
    required this.ride,
    required this.snap,
    required this.spotlight,
  });
}
