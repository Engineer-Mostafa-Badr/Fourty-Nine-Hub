class DragAnalytics {
  bool? open;
  dynamic phone;
  dynamic address;

  DragAnalytics({this.open, this.phone, this.address});

  factory DragAnalytics.fromJson(Map<String, dynamic> json) => DragAnalytics(
        open: json['open'] as bool?,
        phone: json['phone'] as dynamic,
        address: json['address'] as dynamic,
      );

  Map<String, dynamic> toJson() => {
        'open': open,
        'phone': phone,
        'address': address,
      };
}
