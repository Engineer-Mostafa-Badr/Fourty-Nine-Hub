class ReelModel {
  late int id;
  late String userName;
  late String contentUrl;
  late bool isVideo;
  late String title;
  late String description;
  late int numberOfLikes;
  late int numberOfComments;
  late int numberOfSaves;
  late int numberOfExplores;

  ReelModel(
      {required this.id,
      required this.userName,
      required this.contentUrl,
      required this.isVideo,
      required this.title,
      required this.description,
      required this.numberOfLikes,
      required this.numberOfComments,
      required this.numberOfExplores,
      required this.numberOfSaves});

  ReelModel.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['user_name'];
    contentUrl = json['contentUrl'];
    isVideo = json['is_video'];
    title = json['title'];
    description = json['description'];
    numberOfLikes = json['number_of_likes'];
    numberOfComments = json['number_of_comments'];
    numberOfSaves = json['number_of_saves'];
    numberOfExplores = json['number_of_explores'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_name'] = this.userName;
    data['conent_url'] = this.contentUrl;
    data['is_video'] = this.isVideo;
    data['title'] = this.title;
    data['description'] = this.description;
    data['number_of_likes'] = this.numberOfLikes;
    data['number_of_comments'] = this.numberOfComments;
    return data;
  }
}
