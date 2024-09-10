
class PaymentProviderEntity {
  final String id;
  final String nameEn;
  final String nameAr;
  final int tax;
  final int vat;
  final int portion;
  final int cut;
  final int providerTax;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final PaymentProviderMetadata? metadata;

  PaymentProviderEntity({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.tax,
    required this.vat,
    required this.portion,
    required this.cut,
    required this.providerTax,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });
}

class PaymentProviderMetadata {
  final String phone1;
  final String phone2;

  PaymentProviderMetadata({
    required this.phone1,
    required this.phone2,
  });
}

