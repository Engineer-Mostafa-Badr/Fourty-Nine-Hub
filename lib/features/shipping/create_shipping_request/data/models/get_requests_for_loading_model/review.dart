class Review {
  double? averageRating;
  double? ratingDriver;
  double? ratingTrip;
  double? ratingService;
  List<dynamic>? comments;

  Review({
    this.averageRating,
    this.ratingDriver,
    this.ratingTrip,
    this.ratingService,
    this.comments,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        averageRating: (json['averageRating'] as num?)?.toDouble(),
        ratingDriver: double.tryParse(json['ratingDriver'].toString()),
        ratingTrip: double.tryParse(json['ratingTrip'].toString()),
        ratingService: double.tryParse(json['ratingService'].toString()),
        comments: json['comments'] as List<dynamic>?,
      );

  Map<String, dynamic> toJson() => {
        'averageRating': averageRating,
        'ratingDriver': ratingDriver,
        'ratingTrip': ratingTrip,
        'ratingService': ratingService,
        'comments': comments,
      };
}
