import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/account_taps/share_app/data/model/share_app_model.dart';
import 'package:fourtyninehub/features/account_taps/share_app/domain/entity/share_app_entity.dart';

abstract class ShareAppRemoteDataSource {
  Future<Either<Failure, ShareAppEntity>> shareApp();
}

class ShareAppRemoteDataSourceImpl extends ShareAppRemoteDataSource {
  final ApiConsumer _apiConsumer;

  ShareAppRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, ShareAppEntity>> shareApp() async {
    final response = await _apiConsumer.get(EndPoints.shareApp);

    return response.fold(
      (failure) => Left(failure),
      (response) => Right(ShareAppModel.fromJson(response['data'])),
    );
  }
}
