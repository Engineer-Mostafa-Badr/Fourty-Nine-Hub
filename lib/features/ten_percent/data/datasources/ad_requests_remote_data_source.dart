import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';

abstract class TenPercentRemoteDataSource {
}

class TenPercentRemoteDataSourceImpl extends TenPercentRemoteDataSource {
  final ApiConsumer _apiConsumer;
  TenPercentRemoteDataSourceImpl(this._apiConsumer);


}
