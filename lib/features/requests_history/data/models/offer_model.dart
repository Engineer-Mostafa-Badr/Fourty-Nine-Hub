class OfferModel {
  int? id;
  String? name;
  String? phone;
  int? price;
  String? distance;
  String? time;
  double? rate;
  String? profileImage;
  int? numberOfReviews;

  OfferModel(
      {this.id,
      this.name,
      this.phone,
      this.price,
      this.distance,
      this.time,
      this.rate,
      this.profileImage,
      this.numberOfReviews});

  OfferModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    price = json['price'];
    distance = json['distance'];
    time = json['time'];
    rate = json['rate'];
    profileImage = json['profile_image'];
    numberOfReviews = json['number_of_reviews'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['price'] = price;
    data['distance'] = distance;
    data['time'] = time;
    data['rate'] = rate;
    data['profile_image'] = profileImage;
    data['number_of_reviews'] = numberOfReviews;
    return data;
  }
}
