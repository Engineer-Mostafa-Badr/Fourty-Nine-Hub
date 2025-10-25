import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/widget/custom_circular_progress_indicator.dart';

class MessagesListView extends StatelessWidget {
  const MessagesListView({super.key});

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Scrollbar(
        interactive: true,
        thumbVisibility: true,
        thickness: 4,
        radius: const Radius.circular(16),
        child: ListView.builder(
          itemCount: 20, // Add one for the loading indicator
          controller: ScrollController(),
          itemBuilder: (context, index) {
            return Center(child: Container(
              height: 50,
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  )
                ]
              ),
              child: Text("Message ${index + 1}"),
            ));

            // if (index == state.messages!.length) {
            //   // Show a loading indicator at the end
            //   return const Center(child: CustomCircularProgressIndicator());
            // }

            // final message = state.messages![index];
            // final messageDate = message
            //     .createdAt; // Assuming message has a timestamp field

            bool shouldShowDate = true;

            // if (index > 0) {
            //   final previousMessageDate =
            //       state.messages![index - 1].createdAt;
            //   shouldShowDate = previousMessageDate.day !=
            //       messageDate.day ||
            //       previousMessageDate.month != messageDate.month ||
            //       previousMessageDate.year != messageDate.year;
            // }

            // return Column(
            //   crossAxisAlignment: CrossAxisAlignment.stretch,
            //   children: [
            //     if (shouldShowDate) DateWidget(date: messageDate),
            //     // Insert date widget when date changes
            //     MessageCard(
            //       messageEntity: message,
            //       anotherUserName: 'Anonymous',
            //     ),
            //   ],
            // );
          },
        ),
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
