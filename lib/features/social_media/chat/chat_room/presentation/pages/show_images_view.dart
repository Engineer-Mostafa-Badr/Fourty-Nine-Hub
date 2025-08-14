import 'package:flutter/material.dart';
import '../../../../../../core/extensions/file_extension.dart';
import '../../domain/entities/message_entity.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/widget/custom_scaffold.dart';
import '../widgets/chat_room_widgets/message_card.dart';
import '../../../../../../helpers/manage_vibration.dart';

class ShowImagesView extends StatelessWidget {
  const ShowImagesView({super.key, required this.messageEntity});

  final MessageEntity messageEntity;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 26,
        leading: IconButton(
          onPressed: () {
      ManageVibration.vibrate();
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
            child: messageEntity.media[index].type == FileTypeEnum.video
                ? CustomVideoCard(
                    index: index,
                    messageEntity: messageEntity,
                    videoUrl: messageEntity.media[index].url,
                    height: MediaQuery.of(context).size.height * 0.6,
                  )
                : CustomChachedNetworkImage(
                    messageEntity: messageEntity,
                    index: index,
                  ),
          );
        },
      ),
    );
  }
}