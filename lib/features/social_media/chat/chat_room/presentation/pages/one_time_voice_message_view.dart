import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:voice_message_package/voice_message_package.dart';

import '../../../../../../core/widget/custom_scaffold.dart';

class OneTimeVoiceMessageView extends StatefulWidget {
  const OneTimeVoiceMessageView({super.key, required this.messageEntity});
  final MessageEntity messageEntity;

  @override
  State<OneTimeVoiceMessageView> createState() =>
      _OneTimeVoiceMessageViewState();
}

class _OneTimeVoiceMessageViewState extends State<OneTimeVoiceMessageView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            right: 8,
            // bottom: 6,
            // top: 6,
            left: 8,
          ),
          child: Container(
            width: double.infinity,
            height: 110,
            decoration: BoxDecoration(
              color: context.isDarkMode
                  ? AppColors.QUANTITY_COLOR
                  : AppColors.BACKGROUND_COLOR,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              boxShadow: [
                BoxShadow(
                  color: context.isDarkMode
                      ? AppColors.BACKGROUND_COLOR.withOpacity(0.05)
                      : Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  // width: MediaQuery.of(context).size.width * 0.9,
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: VoiceMessageView(
                              activeSliderColor: context.isDarkMode
                                  ? AppColors.BACKGROUND_COLOR.withOpacity(0.5)
                                  : AppColors.LIGHT_GRAY_COLOR2,
                              circlesColor:
                                  // AppColors.PRIMARY_COLOR,
                                  widget.messageEntity.isListened
                                      ? AppColors.PRIMARY_COLOR
                                      : AppColors.PRIMARY_COLOR_DARK,
                              notActiveSliderColor: context.isDarkMode
                                  ? AppColors.QUANTITY_COLOR
                                  : AppColors.BACKGROUND_COLOR,
                              backgroundColor: context.isDarkMode
                                  ? AppColors.QUANTITY_COLOR
                                  : AppColors.BACKGROUND_COLOR,
                              innerPadding: 12,
                              cornerRadius: 12,
                              controller: VoiceController(
                                audioSrc: widget.messageEntity.media[0].url,
                                maxDuration: const Duration(minutes: 1000),
                                isFile: false,
                                onComplete: () async {
                                  context.pop();
                                },
                                onPause: () async {},
                                onPlaying: () async {},
                                onError: (p0) {},
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        color: AppColors.LIGHT_GRAY_COLOR2,
                        height: 70,
                        indent: 70,
                        endIndent: 90,
                        // thickness: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Label(
                        text: widget.messageEntity.time,
                        style: Styles.smallText(
                          color: context.isDarkMode
                              ? AppColors.BACKGROUND_COLOR.withOpacity(0.5)
                              : AppColors.LIGHT_GRAY_COLOR2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
