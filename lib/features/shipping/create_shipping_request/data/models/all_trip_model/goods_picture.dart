class GoodsPicture {
  String? mediaKey;

  GoodsPicture({this.mediaKey});

  factory GoodsPicture.fromJson(Map<String, dynamic> json) => GoodsPicture(
        mediaKey: json['mediaKey'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'mediaKey': mediaKey,
      };
}
