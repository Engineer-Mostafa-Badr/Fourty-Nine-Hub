class RatingEntity {
  final String? id;
  final num? rating;
  final String? comment;

  RatingEntity({this.id,this.rating, this.comment});
}

class DriverRatingEntity {
  num? count;
  num? average;

  DriverRatingEntity({ this.count, this.average});
}
class RatingEntityy {
  final String? id;
  final num? average;
  final int? count;

  RatingEntityy({this.id,this.average, this.count});
}
