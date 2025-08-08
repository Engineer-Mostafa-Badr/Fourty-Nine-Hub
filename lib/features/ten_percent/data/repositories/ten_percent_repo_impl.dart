import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/winners_ten_percent_entity.dart';
import '../../domain/usecases/get_winners_ten_percent_use_case.dart';

import '../../domain/usecases/send_bill_request_use_case.dart';

import '../../domain/repositories/ten_percent_repo.dart';
import '../datasources/ten_percent_remote_data_source.dart';

class TenPercentRepoImpl implements TenPercentRepo {
  final TenPercentRemoteDataSource _remoteDataSource;
  TenPercentRepoImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, bool>> sendBillRequest(
      {required SentBillRequestParams params}) async {
    return await _remoteDataSource.sendBillRequest(params: params);
  }

  @override
  Future<Either<Failure, WinnersTenPercentEntity>> getWinnersTenPercent(
      {required GetWinnersTenPercentParams params}) {
    return _remoteDataSource.getWinnersTenPercent(params: params);
  }
}
