class CriminalRecord {
  bool? open;

  CriminalRecord({this.open});

  factory CriminalRecord.fromJson(Map<String, dynamic> json) {
    return CriminalRecord(
      open: json['open'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        'open': open,
      };
}
