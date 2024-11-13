import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';


abstract class EditFoodRemoteDataSource {
  // Future<Either<Failure, RestaurantOrdersModel>> getRestaurantOrders();
}

class EditFoodRemoteDataSourceImpl
    implements EditFoodRemoteDataSource {
  final ApiConsumer _apiConsumer;
  EditFoodRemoteDataSourceImpl(this._apiConsumer,);

  // @override
  // Future<Either<Failure, bool>> updateRestaurant(params) async {
  //   final response = await _apiConsumer.put(EndPoints.updateRestaurant,data: params.toJson());
  //   return response.fold((l) {
  //     return Left(l);
  //   }, (data) {
  //     return Right(data['status']);
  //   });
  // }
}
