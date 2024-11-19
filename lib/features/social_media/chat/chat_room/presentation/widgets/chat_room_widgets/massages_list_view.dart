import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_room_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chats_cubit.dart';
import 'package:intl/intl.dart';

import 'message_card.dart';

// class MessagesListView extends StatelessWidget {
//   const MessagesListView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final chatRoomCubit = context.read<ChatRoomCubit>();

//     return BlocListener<ChatsCubit, ChatsState>(
//       listener: (context, state) {
//         if (state.isNewMessage && state.newMessage != null) {
//           chatRoomCubit.addMessage(state.newMessage!);
//         }
//       },
//       child: BlocBuilder<ChatRoomCubit, ChatRoomState>(
//         builder: (context, state) {
//           if (state.messages != null) {
//             return Expanded(
//               child: Scrollbar(
//                 interactive: true,
//                 thumbVisibility: true,
//                 thickness: 4,
//                 radius: const Radius.circular(16),
//                 child: ListView.separated(
//                     addAutomaticKeepAlives: true,
//                     itemCount: state.messages?.length ?? 0,
//                     controller: chatRoomCubit.scrollController,
//                     itemBuilder: (context, index) => MessageCard(
//                           messageEntity: state.messages![index],
//                           anotherUserName: 'Anonymous',
//                         ),
//                     separatorBuilder: (context, index) => const Sizer(
//                           height: 3,
//                         )),
//               ),
//             );
//           } else {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

class MessagesListView extends StatelessWidget {
  const MessagesListView({super.key});

  @override
  Widget build(BuildContext context) {
    final chatRoomCubit = context.read<ChatRoomCubit>();

    return BlocListener<ChatsCubit, ChatsState>(
      listener: (context, state) {
        if (state.isNewMessage && state.newMessage != null) {
          chatRoomCubit.addMessage(state.newMessage!);
        }
      },
      child: BlocBuilder<ChatRoomCubit, ChatRoomState>(
        builder: (context, state) {
          if (state.messages != null && state.messages!.isNotEmpty) {
            return Expanded(
              child: Scrollbar(
                interactive: true,
                thumbVisibility: true,
                thickness: 4,
                radius: const Radius.circular(16),
                child: ListView.builder(
                  itemCount: state.messages!.length,
                  controller: chatRoomCubit.scrollController,
                  itemBuilder: (context, index) {
                    final message = state.messages![index];
                    final messageDate = message
                        .createdAt; // Assuming message has a timestamp field

                    bool shouldShowDate = true;

                    if (index > 0) {
                      final previousMessageDate =
                          state.messages![index - 1].createdAt;
                      shouldShowDate =
                          previousMessageDate.day != messageDate.day ||
                              previousMessageDate.month != messageDate.month ||
                              previousMessageDate.year != messageDate.year;
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (shouldShowDate)
                          DateWidget(
                              date:
                                  messageDate), // Insert date widget when date changes
                        MessageCard(
                          messageEntity: message,
                          anotherUserName: 'Anonymous',
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          } else {
            return const Center(
              child: SizedBox(),
            );
          }
        },
      ),
    );
  }
}

class DateWidget extends StatelessWidget {
  final DateTime date;

  const DateWidget({super.key, required this.date});

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final localDate = date.toLocal(); // Convert the date to local time

    // Get the current day's midnight (12:00 AM)
    final todayMidnight = DateTime(now.year, now.month, now.day);

    // Get yesterday's midnight (12:00 AM)
    final yesterdayMidnight = todayMidnight.subtract(const Duration(days: 1));

    if (localDate.isAfter(todayMidnight)) {
      return 'Today'; // Messages after midnight
    } else if (localDate.isAfter(yesterdayMidnight) &&
        localDate.isBefore(todayMidnight)) {
      return 'Yesterday'; // Messages between yesterday and today's midnight
    } else if (localDate
        .isBefore(todayMidnight.subtract(const Duration(days: 7)))) {
      return DateFormat('d MMMM yyyy')
          .format(localDate); // Messages older than a week
    } else {
      return DateFormat('EEEE')
          .format(localDate); // Messages within the current week (day name)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            _formatDate(date),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }
}
