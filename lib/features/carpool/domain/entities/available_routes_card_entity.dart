// ignore_for_file: public_member_api_docs, sort_constructors_first
class PointLocationEntity {
  int? number;
  String? addressAr;
  String? addressEn;
  bool? booked;
  bool? isMale;
  PointLocationEntity({
    this.number,
    this.addressAr,
    this.addressEn,
    this.booked,
    this.isMale,
  });

  @override
  String toString() {
    return 'PointLocationEntity(number: $number, addressAr: $addressAr, addressEn: $addressEn, booked: $booked, isMale: $isMale)';
  }
}

class AvailableRoutesCardEntity {
  num? price;
  num? timeLeft;
  bool? onlyWomanAllowed;
  PointLocationEntity? pointOne;
  PointLocationEntity? pointTwo;
  PointLocationEntity? pointThree;
  PointLocationEntity? pointFour;
  AvailableRoutesCardEntity({
    this.price,
    this.timeLeft,
    this.onlyWomanAllowed,
    this.pointOne,
    this.pointTwo,
    this.pointThree,
    this.pointFour,
  });

  @override
  String toString() {
    return 'AvailableRoutesCardEntity(price: $price, timeLeft: $timeLeft, onlyWomanAllowed: $onlyWomanAllowed, pointOne: $pointOne, pointTwo: $pointTwo, pointThree: $pointThree, pointFour: $pointFour)';
  }
}
