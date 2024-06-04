import '../../../../res/style/const.dart';

class SubCategoryEntity {
  final String sId;
  final String nameAr;
  final String nameEn;
  final String parent;
  final String picture;
  String get image => '${UIConst.imageBaseUrl}/$picture';
  String get name => nameEn;
  SubCategoryEntity(
      {required this.sId,
      required this.nameAr,
      required this.nameEn,
      required this.parent,
      required this.picture});
}
