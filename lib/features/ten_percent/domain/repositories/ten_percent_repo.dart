import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/ten_percent/domain/entities/winners_ten_percent_entity.dart';
import 'package:fourtyninehub/features/ten_percent/domain/usecases/get_winners_ten_percent_use_case.dart';
import 'package:fourtyninehub/features/ten_percent/domain/usecases/send_bill_request_use_case.dart';

import '../../../../../core/error/failure.dart';

abstract class TenPercentRepo {
  Future<Either<Failure, bool>> sendBillRequest(
      {required SentBillRequestParams params});

  Future<Either<Failure, WinnersTenPercentEntity>> getWinnersTenPercent(
      {required GetWinnersTenPercentParams params});
}
