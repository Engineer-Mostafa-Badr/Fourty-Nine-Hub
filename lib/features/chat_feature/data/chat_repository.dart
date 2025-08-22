import '../domain/models/chat_model.dart';
import '../domain/models/story_model.dart';

abstract class ChatRepository {
  Future<List<ChatModel>> getChats();
  Future<List<StoryModel>> getStories();
}

class ChatRepositoryImpl implements ChatRepository {
  @override
  Future<List<ChatModel>> getChats() async {
    // TODO: Implement API call
    return [];
  }

  @override
  Future<List<StoryModel>> getStories() async {
    // TODO: Implement API call
    return [];
  }
}
