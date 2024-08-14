class IdBehindData {
  String? signedUrl;
  String? mediaId;

  IdBehindData({this.signedUrl, this.mediaId});

  factory IdBehindData.fromJson(Map<String, dynamic> json) => IdBehindData(
        signedUrl: json['signedUrl'] as String?,
        mediaId: json['mediaId'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'signedUrl': signedUrl,
        'mediaId': mediaId,
      };
}
