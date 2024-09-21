import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:go_router/go_router.dart';

import '../widgets/chat_room_widgets/message_card.dart';

class ShowImagesView extends StatelessWidget {
  const ShowImagesView({super.key, required this.messageEntity});
  final MessageEntity messageEntity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 26,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: messageEntity.media.length, // Number of images
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomChachedNetworkImage(
              messageEntity: messageEntity,
              index: index,
            ),
          );
        },
      ),
    );
  }
}
