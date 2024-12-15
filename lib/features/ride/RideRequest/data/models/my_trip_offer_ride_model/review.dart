class Review {
  double? averageRating;
  int? numberOfReviewers;
  double? ratingDriver;
  double? ratingTrip;
  double? ratingService;
  List<dynamic>? comments;

  Review({
    this.averageRating,
    this.numberOfReviewers,
    this.ratingDriver,
    this.ratingTrip,
    this.ratingService,
    this.comments,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        averageRating: double.parse(json['averageRating'].toString()),
        numberOfReviewers: json['numberOfReviewers'] as int?,
        ratingDriver: double.parse(json['ratingDriver'].toString()),
        ratingTrip: double.parse(json['ratingTrip'].toString()),
        ratingService:  double.parse(json['ratingService'].toString()),
        comments: json['comments'] as List<dynamic>?,
      );

  Map<String, dynamic> toJson() => {
        'averageRating': averageRating,
        'numberOfReviewers': numberOfReviewers,
        'ratingDriver': ratingDriver,
        'ratingTrip': ratingTrip,
        'ratingService': ratingService,
        'comments': comments,
      };
}
