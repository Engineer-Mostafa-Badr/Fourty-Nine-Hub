import '../../../domain/entities/cache_out_entity/list_bank_entity.dart';

class ListBankModel extends ListBankEntity {
  ListBankModel(
      {required super.id,
      required super.nameEn,
      required super.nameAr,
      required super.createdAt});

  factory ListBankModel.fromJson(Map<String, dynamic> json) {
    return ListBankModel(
      id: json['_id'],
      nameEn: json['nameEn'],
      nameAr: json['nameAr'],
      createdAt: json['createdAt'],
    );
  }
}
