import 'package:fourtyninehub/core/api/api_client_helper.dart';
import 'package:fourtyninehub/core/api/end_points.dart';

class ShippingDataSource {
  ApiClientHelper api;
  ShippingDataSource({required this.api});
  Future getBannerData() {
    return api.get(url: EndPoints.bannerData, token: true);
  }
}
