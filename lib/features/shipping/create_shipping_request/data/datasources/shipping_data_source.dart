import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';

class ShippingDataSource {
  ApiConsumer api;
  ShippingDataSource({required this.api});
  Future getBannerData() {
    return api.get(
      EndPoints.bannerData,
    );
  }
}
