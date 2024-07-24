import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/models/chat_item_model.dart';

abstract class ChatsRemoteDataSource {
  Future<Either<Failure, List<ChatItemModel>>> getChats({
    required String privacy,
    required String categoryId,
  });
}

class ChatsRemoteDataSourceImplementation implements ChatsRemoteDataSource {
  final ApiConsumer _apiConsumer;

  ChatsRemoteDataSourceImplementation(this._apiConsumer);

  @override
  Future<Either<Failure, List<ChatItemModel>>> getChats(
      {required String privacy, required String categoryId}) async {
    final response = await _apiConsumer.get(EndPoints.getChats);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data'] as List)
            .map((e) => ChatItemModel.fromJson(e))
            .toList()));
  }
}
