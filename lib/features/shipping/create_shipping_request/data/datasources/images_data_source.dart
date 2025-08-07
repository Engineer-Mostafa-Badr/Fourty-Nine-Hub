import '../../../../../core/data/datasources/remote/api/api_consumer.dart';

class ImagesDataSource {
  ApiConsumer api;
  ImagesDataSource({required this.api});
  Future getS3({required Map<String, dynamic> json, required String endpoint}) {
    return api.put(endpoint, data: json);
  }
  // Future uploadImage({required })
}
