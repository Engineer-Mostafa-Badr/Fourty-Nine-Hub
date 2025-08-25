import 'package:dartz/dartz.dart';

import '../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../../core/error/failure.dart';
import '../../Domain/Entities/conversation_entity.dart';
import '../../Domain/Entities/conversations_pagination.dart';
import '../Models/conversation_model.dart';

abstract class ConversationsRemoteDataSource {
  Future<Either<Failure, List<ConversationEntity>>> getSocialConversations({required ConversationPagination pagination});
}

class ConversationsRemoteDataSourceImpl implements ConversationsRemoteDataSource {

  final ApiConsumer _apiConsumer;

  ConversationsRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<ConversationEntity>>> getSocialConversations({required ConversationPagination pagination}) async {
    final response = await _apiConsumer.get(EndPoints.getSocialConversations(page: pagination.page, limit: pagination.limit));
    return response.fold((failure) => Left(failure), (data) => Right((data['data']['conversations'] as List).map((e) => ConversationModel.fromJson(e)).toList()));
  }
}