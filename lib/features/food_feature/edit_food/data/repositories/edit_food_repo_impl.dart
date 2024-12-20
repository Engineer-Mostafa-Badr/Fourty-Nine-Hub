import '../../domain/repositories/edit_food_repo.dart';
import '../datasources/edit_food_remote_datasource.dart';

class EditFoodRepoImpl implements EditFoodRepo {
  final EditFoodRemoteDataSource _remoteDataSource;
  EditFoodRepoImpl(this._remoteDataSource);
  // @override
  // Future<Either<Failure, bool>> approveOrder({required int id}) async {
  //   return await _remoteDataSource.approveOrder(id: id);
  // }
}
