class ActivityEntity {
  final String id;
  final String name;
  final String nameEn;
  final String image;
  final String? mainId;
  final ActivityEntity? mainActivity;
  ActivityEntity({required this.id, required this.name,required this.nameEn, required this.image,this.mainId,this.mainActivity});
}
