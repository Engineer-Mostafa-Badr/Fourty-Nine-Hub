import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../domain/usecases/create_auction_usecase.dart';

abstract class CreateAuctionRepo {
  Future<Either<Failure, bool>> createAuction(
      {required CreateAuctionParams params});
}
