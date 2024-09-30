import 'package:fourtyninehub/common/models/public/pagination_params.dart';

class FetchPostCompanyAdvertiseParams {
  final String filter;
  final PaginationParams paginationParams;

  FetchPostCompanyAdvertiseParams(
      {required this.filter, required this.paginationParams});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};

    data['filter'] = filter;
    data.addAll(paginationParams.toJson());

    return data;
  }
}
