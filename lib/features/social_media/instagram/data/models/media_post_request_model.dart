class MediaPostRequestModel {
  final String itemId;
  final String type;
  final int size;
  MediaPostRequestModel({required this.itemId, required this.size, required this.type});

  tojson(){
    return {
      "itemId": itemId,
      "type": type,
      "size": size
    };
  }
}