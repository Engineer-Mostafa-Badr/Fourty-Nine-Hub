class IdFrontData {
  String? signedUrl;
  String? mediaId;

  IdFrontData({this.signedUrl, this.mediaId});

  factory IdFrontData.fromJson(Map<String, dynamic> json) => IdFrontData(
        signedUrl: json['signedUrl'] as String?,
        mediaId: json['mediaId'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'signedUrl': signedUrl,
        'mediaId': mediaId,
      };
}
