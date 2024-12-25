import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/usecases/get_ad_requests_usecase.dart';
import 'package:fourtyninehub/features/ten_percent/domain/usecases/send_bill_request_use_case.dart';

import '../../../../../core/error/failure.dart';

abstract class TenPercentRepo {
  Future<Either<Failure, bool>> sendBillRequest({required SentBillRequestParams params});


}
