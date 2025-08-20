import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/tinder_repository.dart';

class SendGiftUseCase extends UseCase<SendGiftResponse, SendGiftParams> {
  final TinderRepository _repository;

  SendGiftUseCase(this._repository);

  @override
  Future<Either<Failure, SendGiftResponse>> call(SendGiftParams params) {
    return _repository.sendGift(params);
  }
}

class SendGiftParams {
  final String receiverId;
  final String giftId;

  SendGiftParams({
    required this.receiverId,
    required this.giftId,
  });

  //toJson
  Map<String, dynamic> toJson() => {
        'receiverId': receiverId,
        'giftId': giftId,
        // 'subCategory':'66af974f8bf69f9469944746',
      };
}

class SendGiftResponse{
  final bool status;
  final num httpCode;

  SendGiftResponse({required this.status, required this.httpCode});

  //fromJson
  factory SendGiftResponse.fromJson(Map<String, dynamic> json) => SendGiftResponse(
    status: json['status'] ?? (json['success'] ?? false),
    httpCode: json['httpCode']??200,
  );
}
