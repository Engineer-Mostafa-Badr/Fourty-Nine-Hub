

class LastSeenModel {
  bool? status;
  Data? data;

  LastSeenModel({this.status, this.data});

  factory LastSeenModel.fromJson(Map<String, dynamic> json) {
    return LastSeenModel(
      status: json['status'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? user;
  String? lastSeen;
  String? status;
  String? createdAt;
  String? updatedAt;

  Data({
    this.id,
    this.user,
    this.lastSeen,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['_id'],
      user: json['user'],
      lastSeen: json['lastSeen'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['user'] = user;
    data['lastSeen'] = lastSeen;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
