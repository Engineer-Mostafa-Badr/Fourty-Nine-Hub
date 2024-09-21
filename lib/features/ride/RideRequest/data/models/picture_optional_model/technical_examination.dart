class TechnicalExamination {
  bool? open;
  dynamic phone;
  dynamic address;

  TechnicalExamination({this.open, this.phone, this.address});

  factory TechnicalExamination.fromJson(Map<String, dynamic> json) {
    return TechnicalExamination(
      open: json['open'] as bool?,
      phone: json['phone'] as dynamic,
      address: json['address'] as dynamic,
    );
  }

  Map<String, dynamic> toJson() => {
        'open': open,
        'phone': phone,
        'address': address,
      };
}
