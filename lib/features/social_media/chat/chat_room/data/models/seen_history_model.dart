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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['time'] = this.time;
    data['date'] = this.date;
    data['_id'] = this.sId;
    return data;
  }
}
