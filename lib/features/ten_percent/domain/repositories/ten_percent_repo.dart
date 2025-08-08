import 'package:dartz/dartz.dart';
import '../entities/winners_ten_percent_entity.dart';
import '../usecases/get_winners_ten_percent_use_case.dart';
import '../usecases/send_bill_request_use_case.dart';

import '../../../../../core/error/failure.dart';

abstract class TenPercentRepo {
  Future<Either<Failure, bool>> sendBillRequest(
      {required SentBillRequestParams params});

  Future<Either<Failure, WinnersTenPercentEntity>> getWinnersTenPercent(
      {required GetWinnersTenPercentParams params});
}
