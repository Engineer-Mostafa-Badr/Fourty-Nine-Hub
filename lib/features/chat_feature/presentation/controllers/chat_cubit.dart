import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/models/chat_model.dart';
import '../../domain/models/story_model.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  void loadChats() async {
    emit(ChatLoading());
    try {
      // TODO: Implement repository call
      await Future.delayed(const Duration(seconds: 1));
      emit(ChatLoaded(
        chats: _getMockChats(),
        stories: _getMockStories(),
      ));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  List<ChatModel> _getMockChats() {
    return [
      ChatModel(
        id: '1',
        name: 'Ahmed Mohamed',
        lastMessage: '✓✓ Lorem ipsum dolor sit amet.........',
        profileImage: 'assets/images/profile1.jpg',
        time: '03:53 pm',
        unreadCount: 10,
        isMuted: true,
        isPinned: true,
        messageStatus: MessageStatus.read,
      ),
      ChatModel(
        id: '2',
        name: '49 Hup',
        lastMessage: '✓✓ Lorem ipsum dolor sit amet.........',
        profileImage: 'assets/images/49hup_logo.jpg',
        time: '2/7/25',
        isVerified: true,
        messageStatus: MessageStatus.read,
      ),
      ChatModel(
        id: '3',
        name: 'Ahmed Mohamed',
        lastMessage: '✓ Lorem ipsum dolor sit amet.........',
        profileImage: 'assets/images/profile2.jpg',
        time: 'yesterday',
        messageStatus: MessageStatus.delivered,
      ),
      ChatModel(
        id: '4',
        name: 'Ahmed Mohamed',
        lastMessage: '✓✓ Photo',
        profileImage: 'assets/images/profile3.jpg',
        time: '03:53 pm',
        messageStatus: MessageStatus.read,
        messageType: MessageType.photo,
      ),
      ChatModel(
        id: '5',
        name: 'Ahmed Mohamed',
        lastMessage: '✓✓ Voice',
        profileImage: 'assets/images/profile4.jpg',
        time: '03:53 pm',
        messageStatus: MessageStatus.read,
        messageType: MessageType.voice,
      ),
      ChatModel(
        id: '6',
        name: 'Ahmed Mohamed',
        lastMessage: '✓✓ Voice',
        profileImage: 'assets/images/profile5.jpg',
        time: '03:53 pm',
        messageStatus: MessageStatus.read,
        messageType: MessageType.voice,
      ),
      ChatModel(
        id: '7',
        name: 'Ahmed Mohamed',
        lastMessage: 'typing...',
        profileImage: 'assets/images/profile3.jpg',
        time: '03:53 pm',
        isTyping: true,
      ),
    ];
  }

  List<StoryModel> _getMockStories() {
    return [
      StoryModel(
        id: '1',
        name: 'My Story',
        profileImage: 'assets/images/my_story.jpg',
        isMyStory: true,
      ),
      StoryModel(
        id: '2',
        name: 'Taha',
        profileImage: 'assets/images/story1.jpg',
        hasNewStory: true,
      ),
      StoryModel(
        id: '3',
        name: 'Ahmed...',
        profileImage: 'assets/images/story2.jpg',
        hasNewStory: true,
      ),
      StoryModel(
        id: '4',
        name: 'Mohamed..',
        profileImage: 'assets/images/story3.jpg',
        hasNewStory: true,
      ),
      StoryModel(
        id: '5',
        name: 'Mido',
        profileImage: 'assets/images/story4.jpg',
        hasNewStory: true,
      ),
    ];
  }
}
