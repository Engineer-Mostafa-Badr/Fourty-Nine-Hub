// ignore_for_file: public_member_api_docs, sort_constructors_first

class PickMeCardEntity {
  String? id;
  String? userId;
  String? firstName;
  String? categoryId;
  num? journeyPrice;
  String? status;
  int? seatNumber;
  bool? isRepeated;
  String? startingAddressAr;
  String? destinationAddressAr;
  String? startingAddressEn;
  String? destinationAddressEn;
  bool? isApproved;
  int? publishDate;
  String? phone;
  String? gender;
  String? paymentMethod;
  bool? subscribedPremium;
  bool? hasNextPage;
  num? nextPage;
  PickMeCardEntity({
    this.id,
    this.userId,
    this.firstName,
    this.categoryId,
    this.journeyPrice,
    this.status,
    this.seatNumber,
    this.isRepeated,
    this.startingAddressAr,
    this.destinationAddressAr,
    this.startingAddressEn,
    this.destinationAddressEn,
    this.isApproved,
    this.publishDate,
    this.phone,
    this.gender,
    this.paymentMethod,
    this.subscribedPremium,
    this.hasNextPage,
    this.nextPage,
  });

  @override
  String toString() {
    return 'PickMeCardEntity(id: $id, userId: $userId, firstName: $firstName, categoryId: $categoryId, journeyPrice: $journeyPrice, status: $status, seatNumber: $seatNumber, isRepeated: $isRepeated, startingAddressAr: $startingAddressAr, destinationAddressAr: $destinationAddressAr, startingAddressEn: $startingAddressEn, destinationAddressEn: $destinationAddressEn, isApproved: $isApproved, publishDate: $publishDate, phone: $phone, gender: $gender, paymentMethod: $paymentMethod, subscribedPremium: $subscribedPremium, hasNextPage: $hasNextPage, nextPage: $nextPage)';
  }
}

Map _allPickmeResponse = {
  "status": true,
  "message": "Come with me trips fetched successfully",
  "data": {
    "subscribedPremium": false,
    "updatedTrips": [
      {
        "trip": {
          "_id": "66f301a31aba1aa1b73f3e01",
          "userId": {
            "_id": "66b76065ab3b6f5a3d2273ed",
            "firstName": "khaled",
            "email": "mohamedshehab0001@gmail.com",
            "gender": "female",
            "id": "66b76065ab3b6f5a3d2273ed"
          },
          "categoryId": {
            "_id": "62ea008d69ea29c91dfc3908",
            "nameAr": "وصلنى معاك",
            "nameEn": "Pick me",
            "paymentMethods": "mainWallet"
          },
          "fromEn": "ASDAS",
          "toEn": "ASDAS",
          "fromAr": "ASDAS",
          "toAr": "ASDAS",
          "distance": 5554,
          "duration": 5555,
          "price": 311321,
          "phone": 54645646,
          "time": 1716987600,
          "isRepeat": false
        },
        "allowStatus": "disable",
        "paymentMethods": "mainWallet"
      }
    ],
    "pagination": {
      "totalDocs": 1,
      "limit": 10,
      "totalPages": 1,
      "page": 1,
      "pagingCounter": 1,
      "hasPrevPage": false,
      "hasNextPage": false,
      "prevPage": null,
      "nextPage": null
    }
  }
};
