import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/data/models/message_model.dart';
import 'package:fourtyninehub/res/assets/jsons.dart';

abstract class ChatRemoteDataSource {
  Future<Either<Failure, List<MessageModel>>> getChatMessages({
    required String chatId,
  });
}

class ChatRemoteDataSourceImplementation implements ChatRemoteDataSource {
  final ApiConsumer _apiConsumer;

  ChatRemoteDataSourceImplementation(this._apiConsumer);

  @override
  Future<Either<Failure, List<MessageModel>>> getChatMessages(
      {required String chatId}) async {
    final response = await _apiConsumer.get(Jsons.foodCategoriesList);
    return response.fold(
        (failure) => Left(failure),
        (data) => Right((data['data']['messages'] as List)
            .map((e) => MessageModel.fromJson(e))
            .toList()));
  }
}
