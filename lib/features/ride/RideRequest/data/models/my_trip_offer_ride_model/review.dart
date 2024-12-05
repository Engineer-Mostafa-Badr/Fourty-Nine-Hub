class Review {
  int? averageRating;
  int? numberOfReviewers;
  int? ratingDriver;
  int? ratingTrip;
  int? ratingService;
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
        averageRating: json['averageRating'] as int?,
        numberOfReviewers: json['numberOfReviewers'] as int?,
        ratingDriver: json['ratingDriver'] as int?,
        ratingTrip: json['ratingTrip'] as int?,
        ratingService: json['ratingService'] as int?,
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
