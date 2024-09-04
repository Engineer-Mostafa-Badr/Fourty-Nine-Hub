import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../entities/gift_entities.dart';

abstract class GiftRepository{
 Future<Either<Failure,GiftWallet>> fetchGiftWallet();
 Future<Either<Failure,List<CompetitionWallet>>> fetchCompetitionsWallet();
}