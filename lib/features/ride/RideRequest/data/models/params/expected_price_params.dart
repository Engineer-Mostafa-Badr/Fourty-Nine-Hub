class ExpectedPriceParams {
  final double fromLat;
  final double fromLng;
  final double toLat;
  final double toLng;
  final String subCategoryId;
  ExpectedPriceParams({
    required this.fromLat,
    required this.fromLng,
    required this.toLat,
    required this.toLng,
    required this.subCategoryId,
  });

  Map<String, dynamic> toJson() => {
        "startLocation": ["$fromLat", "$fromLng"],
        "targetLocation": ["$toLat", "$toLng"],
      };
}
