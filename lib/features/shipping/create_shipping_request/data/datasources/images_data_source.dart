import 'package:fourtyninehub/core/api/api_client_helper.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';

class ImagesDataSource {
  ApiConsumer api;
  ImagesDataSource({required this.api});
  Future getS3({required Map<String, dynamic> json, required String endpoint}) {
    return api.put(endpoint, data: json);
  }
  // Future uploadImage({required })
}
