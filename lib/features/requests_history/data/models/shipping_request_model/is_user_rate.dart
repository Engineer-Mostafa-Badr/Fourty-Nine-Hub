class IsUserRate {
  int? ratingDriver;
  int? ratingTrip;
  int? ratingService;
  String? comment;

  IsUserRate({
    this.ratingDriver,
    this.ratingTrip,
    this.ratingService,
    this.comment,
  });

  factory IsUserRate.fromJson(Map<String, dynamic> json) => IsUserRate(
        ratingDriver: json['ratingDriver'] as int?,
        ratingTrip: json['ratingTrip'] as int?,
        ratingService: json['ratingService'] as int?,
        comment: json['comment'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'ratingDriver': ratingDriver,
        'ratingTrip': ratingTrip,
        'ratingService': ratingService,
        'comment': comment,
      };
}
