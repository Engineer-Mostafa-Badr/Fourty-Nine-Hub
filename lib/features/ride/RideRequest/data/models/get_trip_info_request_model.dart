class GetTripInfoRequestModel {
  List? startLocation;
  List? targetLocation;
  bool? comfort;
  bool? autoAccept;
  String? subCateogryId;
  GetTripInfoRequestModel({
    this.autoAccept,
    this.comfort,
    this.startLocation,
    this.subCateogryId,
    this.targetLocation,
  });
  Map<String, dynamic> toJson() {
    return {
      "startLocation": startLocation,
      "targetLocation": targetLocation,
      "comfort": comfort,
    };
  }
}
