import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/repositories/gift_repository.dart';

import '../../../../../../core/error/failure.dart';
import '../../entities/gift_entities.dart';

class GetGiftUseCases{
  final GiftRepository giftRepository;

  GetGiftUseCases({required this.giftRepository});

  Future<Either<Failure,GiftWallet>> call() async{
    return await giftRepository.fetchGiftWallet();
  }
}