class GetPriceCarpoolParam {
  bool? womenOnly;
  bool? womenDriverOnly;
  bool? comfort;
  List<double>? startLocation;
  List<double>? targetLocation;
  GetPriceCarpoolParam({
    this.womenOnly,
    this.womenDriverOnly,
    this.comfort,
    this.startLocation,
    this.targetLocation,
  });

  @override
  String toString() {
    return 'GetPriceCarpoolParam(womenOnly: $womenOnly, womenDriverOnly: $womenDriverOnly, comfort: $comfort, startLocation: $startLocation, targetLocation: $targetLocation)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'womenOnly': womenOnly,
      'womenDriverOnly': womenDriverOnly,
      'comfort': comfort,
      'startLocation': startLocation,
      'targetLocation': targetLocation,
    };
  }
}
