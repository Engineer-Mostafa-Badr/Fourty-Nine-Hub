// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../repositories/meeting_repository.dart';

class SendLiveGiftUseCase extends UseCase<bool, SendLiveGiftParams> {
  final MeetingRepository repository;

  SendLiveGiftUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(SendLiveGiftParams params) {
    return repository.sendGift(params);
  }
}


class SendLiveGiftParams {
  final String streamId;
  final String giftId;
  final String memberId;

  SendLiveGiftParams({required this.streamId, required this.memberId, required this.giftId});

  //toJson
  Map<String, dynamic> toJson() => {
    'giftId': giftId,
    'memberId': memberId,
  };
}