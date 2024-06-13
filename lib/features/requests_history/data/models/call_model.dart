class CallModel {
  int? id;
  String? name;
  String? profileImage;
  String? createdAt;

  CallModel({this.id, this.name, this.profileImage, this.createdAt});

  CallModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profileImage = json['profile_image'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['profile_image'] = profileImage;
    data['created_at'] = createdAt;
    return data;
  }
}
