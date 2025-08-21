import 'package:get_it/get_it.dart';
import '../features/chat_feature/presentation/controllers/chat_cubit.dart';

class ChatServiceLocator {
  static void execute({required GetIt serviceLocator}) {
    // Register ChatCubit
    serviceLocator.registerLazySingleton<ChatCubit>(
      () => ChatCubit(),
    );
  }
}
