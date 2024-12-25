import 'package:dartz/dartz.dart';

import 'package:fourtyninehub/core/error/failure.dart';

import 'package:fourtyninehub/features/ten_percent/domain/usecases/send_bill_request_use_case.dart';

import '../../domain/repositories/ten_percent_repo.dart';
import '../datasources/ten_percent_remote_data_source.dart';

class TenPercentRepoImpl implements TenPercentRepo {
  final TenPercentRemoteDataSource _remoteDataSource;
  TenPercentRepoImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, bool>> sendBillRequest({required SentBillRequestParams params}) async {
    return await _remoteDataSource.sendBillRequest(params: params);
  }

}
