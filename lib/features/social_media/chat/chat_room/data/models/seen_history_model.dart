// class SeenHistoryModel {
//   List<LastSeen>? lastSeen;
//   int? lastSeenCount;
//
//   SeenHistoryModel({this.lastSeen, this.lastSeenCount});
//
//   SeenHistoryModel.fromJson(Map<String, dynamic> json) {
//     if (json['lastSeen'] != null) {
//       lastSeen = <LastSeen>[];
//       json['lastSeen'].forEach((v) {
//         lastSeen!.add(LastSeen.fromJson(v));
//       });
//     }
//     lastSeenCount = json['lastSeenCount'];
//   }
// }

class SeenHistoryModel {
  String? name;
  String? time;
  String? date;
  String? sId;

  SeenHistoryModel({this.name, this.time, this.date, this.sId});

  SeenHistoryModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    time = json['time'];
    date = json['date'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['time'] = time;
    data['date'] = date;
    data['_id'] = sId;
    return data;
  }
}
