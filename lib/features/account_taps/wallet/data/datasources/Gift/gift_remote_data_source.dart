import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/account_taps/wallet/data/models/Gift/gift_model.dart';
import '../../../../../../core/api/api_consumer.dart';
import '../../../../../../core/api/end_points.dart';
import '../../../../../../core/error/failure.dart';
import '../../../domain/entities/gift_entities.dart';

abstract class GiftRemoteDataSource{
  Future<Either<Failure,GiftModelModel>> fetchGiftWallet();
}

class GiftRemoteDataSourceImpl implements GiftRemoteDataSource{
  final ApiConsumer _apiConsumer;

  GiftRemoteDataSourceImpl(this._apiConsumer);


  @override
  Future<Either<Failure, GiftModelModel>> fetchGiftWallet() async{
    final response = await _apiConsumer.get(EndPoints.getGift);
    return response.fold(
            (failure) => Left(failure),
            (response) => Right(GiftModelModel.fromJson(response['data'])));
  }
}