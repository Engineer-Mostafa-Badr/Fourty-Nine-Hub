class AzkarDetailsEntity {
  final String id;
  final String category;
  final String zekr;
  final String? description;
  final int? count;
  final String? reference;
  final String search;

  AzkarDetailsEntity(
      {required this.id,
      required this.category,
      required this.zekr,
      required this.description,
      required this.count,
      required this.reference,
      required this.search});
}
