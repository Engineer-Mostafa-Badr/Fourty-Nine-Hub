import 'package:fourtyninehub/features/payment/domain/entities/payment_provider_entity.dart';

class PaymentProviderModel extends PaymentProviderEntity {
  PaymentProviderModel({
    required super.id,
    required super.nameEn,
    required super.nameAr,
    required super.tax,
    required super.vat,
    required super.portion,
    required super.cut,
    required super.providerTax,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
    super.metadata,
  });

  factory PaymentProviderModel.fromJson(Map<String, dynamic> json) {
    return PaymentProviderModel(
      id: json['_id'],
      nameEn: json['nameEn'],
      nameAr: json['nameAr'],
      tax: json['tax'],
      vat: json['vat'],
      portion: json['portion'],
      cut: json['cut'],
      providerTax: json['providerTax'],
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      metadata: json['metadata'] != null
          ? MetaDataModel.fromJson(json["metadata"])
          : null,
    );
  }
}

class MetaDataModel extends PaymentProviderMetadata {
  MetaDataModel({required super.phone1, required super.phone2});

  factory MetaDataModel.fromJson(Map<String, dynamic> json) {
    return MetaDataModel(phone1: json['phone1'], phone2: json['phone2']);
  }
}
