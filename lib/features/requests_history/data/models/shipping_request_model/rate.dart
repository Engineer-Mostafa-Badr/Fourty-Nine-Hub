class Rate {
  int? ratingDriver;
  int? ratingTrip;
  int? ratingService;

  Rate({this.ratingDriver, this.ratingTrip, this.ratingService});

  factory Rate.fromJson(Map<String, dynamic> json) => Rate(
        ratingDriver: json['ratingDriver'] as int?,
        ratingTrip: json['ratingTrip'] as int?,
        ratingService: json['ratingService'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'ratingDriver': ratingDriver,
        'ratingTrip': ratingTrip,
        'ratingService': ratingService,
      };
}
