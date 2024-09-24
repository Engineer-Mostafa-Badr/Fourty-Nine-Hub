class CategoryId {
  String? id;
  String? nameAr;
  String? nameEn;
  String? paymentMethods;

  CategoryId({this.id, this.nameAr, this.nameEn, this.paymentMethods});

  @override
  String toString() {
    return 'CategoryId(id: $id, nameAr: $nameAr, nameEn: $nameEn, paymentMethods: $paymentMethods)';
  }

  factory CategoryId.fromJson(Map<String, dynamic> json) => CategoryId(
        id: json['_id'] as String?,
        nameAr: json['nameAr'] as String?,
        nameEn: json['nameEn'] as String?,
        paymentMethods: json['paymentMethods'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'nameAr': nameAr,
        'nameEn': nameEn,
        'paymentMethods': paymentMethods,
      };
}
