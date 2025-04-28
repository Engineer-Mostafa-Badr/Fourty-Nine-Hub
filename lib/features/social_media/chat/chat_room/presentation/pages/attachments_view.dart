import 'dart:developer';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/file_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/service/get_file_size_format.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_room_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/widgets/chat_room_widgets/message_card.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/widgets/widgets_contacts/recived_contacts.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../core/widget/custom_scaffold.dart';

class AttachementsView extends StatefulWidget {
  const AttachementsView({super.key, required this.chatRoomCubit});

  final ChatRoomCubit chatRoomCubit;

  @override
  AttachementsViewState createState() => AttachementsViewState();
}

class AttachementsViewState extends State<AttachementsView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: BlocProvider.value(
        value: widget.chatRoomCubit,
        child: Builder(builder: (context) {
          return CustomScaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: AppColors.PRIMARY_COLOR,
              title: Text(
                LocaleKeys.attachments.tr(),
                style: Styles.headerText(
                  fontWeight: FontWeight.bold,
                  color: AppColors.BACKGROUND_COLOR,
                ),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  size: 26,
                  color: AppColors.BACKGROUND_COLOR,
                ),
              ),
              bottom: TabBar(
                indicatorColor: AppColors.BACKGROUND_COLOR,
                indicatorWeight: 3,
                // indicatorPadding: const EdgeInsets.symmetric(horizontal: 2),
                unselectedLabelColor: AppColors.DIVIDER_GRAY_COLOR2,
                labelColor: AppColors.BACKGROUND_COLOR,
                tabs: [
                  Tab(
                    text: LocaleKeys.media.tr(),
                  ),
                  Tab(
                    text: LocaleKeys.docs.tr(),
                  ),
                  Tab(
                    text: LocaleKeys.links.tr(),
                  ),
                ],
              ),
            ),
            body: BlocBuilder<ChatRoomCubit, ChatRoomState>(
              builder: (context, state) {
                log("state.messages ${state.messages?.length}");

                return TabBarView(
                  children: [
                    state.messages == null
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : MediaAttachementsTab(
                            messages: state.messages ?? [],
                          ),
                    state.messages == null
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : DocumentsAttachementsTab(
                            messages: state.messages ?? [],
                          ),
                    state.messages == null
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : LinksAttachementsTab(
                            messages: state.messages ?? [],
                          ),
                  ],
                );
              },
            ),
          );
        }),
      ),
    );
  }
}

class DocumentsAttachementsTab extends StatefulWidget {
  const DocumentsAttachementsTab({
    super.key,
    required this.messages,
  });

  final List<MessageEntity> messages;

  @override
  State<DocumentsAttachementsTab> createState() =>
      _DocumentsAttachementsTabState();
}

class _DocumentsAttachementsTabState extends State<DocumentsAttachementsTab> {
  List<MessageEntity> documentMessages = [];

  @override
  initState() {
    super.initState();
    getDocumentMessages();
  }

  Future<void> getDocumentMessages() async {
    documentMessages = widget.messages
        .where((element) {
          if (element.media.isNotEmpty) {
            // Check if any media type is video, image, or audio
            if (element.media[0].type == FileTypeEnum.document) return true;
            return false;
          } else {
            return false;
          }
        })
        .toList()
        .reversed
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: documentMessages.isEmpty
          ? Center(child: Text(LocaleKeys.noDocs.tr()))
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: documentMessages.length,
              itemBuilder: (context, index) {
                return AttachmentsFileCard(
                  messageEntity: documentMessages[index],
                );
              },
            ),
    );
  }
}

class LinksAttachementsTab extends StatefulWidget {
  const LinksAttachementsTab({
    super.key,
    required this.messages,
  });

  final List<MessageEntity> messages;

  @override
  State<LinksAttachementsTab> createState() => _LinksAttachementsTabState();
}

class _LinksAttachementsTabState extends State<LinksAttachementsTab> {
  List<MessageEntity> linkMessages = [];

  @override
  void initState() {
    super.initState();
    getLinkMessages();
  }

  Future<void> getLinkMessages() async {
    linkMessages = widget.messages
        .where((element) {
          if (element.text.contains('https://') ||
              element.text.contains('http://')) {
            return true;
          }
          return false;
        })
        .toList()
        .reversed
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return linkMessages.isEmpty
        ? Center(child: Text(LocaleKeys.noLinks.tr()))
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ListView.builder(
              itemCount: linkMessages.length,
              itemBuilder: (context, index) {
                final linkUrl = extractLink(linkMessages[index].text);
                return LinkCard(
                  linkMessage: linkMessages[index].text,
                  linkUrl: linkUrl,
                );
              },
            ),
          );
  }

  // Function to extract URL from the message text using RegExp
  String? extractLink(String message) {
    final urlRegExp =
        RegExp(r'(https?:\/\/[^\s]+)', // Regular expression to match URLs
            caseSensitive: false);
    final match = urlRegExp.firstMatch(message);
    if (match != null) {
      return match.group(0); // Return the first matched URL
    }
    return null; // Return null if no URL found
  }
}

class LinkCard extends StatelessWidget {
  const LinkCard({
    super.key,
    required this.linkMessage,
    required this.linkUrl,
  });

  final String linkMessage;
  final String? linkUrl;

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (linkUrl != null) {
          _launchURL(linkUrl!); // Launch the URL on tap
        }
      },
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color:
              context.isDarkMode ? AppColors.QUANTITY_COLOR : Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: context.isDarkMode
                  ? AppColors.BACKGROUND_COLOR.withOpacity(0.05)
                  : Colors.black12,
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Icon(
                Icons.link,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (linkUrl != null)
                    Text(
                      linkUrl!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                    ),
                  Text(
                    linkMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MediaAttachementsTab extends StatefulWidget {
  const MediaAttachementsTab({
    super.key,
    required this.messages,
  });

  final List<MessageEntity> messages;

  @override
  State<MediaAttachementsTab> createState() => _MediaAttachementsTabState();
}

class _MediaAttachementsTabState extends State<MediaAttachementsTab> {
  List<MessageEntity> mediaMessages = [];
  List mediaMessagesLinks = [];

  @override
  initState() {
    super.initState();
    getMediaMessages();
  }

  Future<void> getMediaMessages() async {
    mediaMessages = widget.messages
        .where((element) {
          if (element.media.isNotEmpty) {
            // Check if any media type is video, image, or audio
            for (var media in element.media) {
              if (media.type == FileTypeEnum.video ||
                  media.type == FileTypeEnum.image ||
                  media.type == FileTypeEnum.audio) {
                return true;
              }
            }
            // If no matching media type is found
            return false;
          } else {
            return false;
          }
        })
        .toList()
        .reversed
        .toList();
    for (MessageEntity message in mediaMessages) {
      mediaMessagesLinks.addAll((message.media.map((e) => e.url).toList()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: mediaMessages.isEmpty
          ? Center(child: Text(LocaleKeys.noMedia.tr()))
          : GridView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 columns
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: mediaMessagesLinks.length,
              itemBuilder: (context, index) {
                for (MessageEntity message in mediaMessages) {
                  for (var media in message.media) {
                    if (media.url == mediaMessagesLinks[index]) {
                      // return AttachmentsImageCard();
                      return media.type == FileTypeEnum.image
                          ? CustomChachedNetworkImage(
                              mediaUrl: media.url,
                            )
                          : media.type == FileTypeEnum.audio
                              ? Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: AppColors.SECONDARY_COLOR,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.headphones,
                                      color: AppColors.BACKGROUND_COLOR,
                                      size: 36,
                                    ),
                                  ),
                                )
                              : CustomVideoCard(
                                  videoUrl: media.url,
                                );
                    }
                  }
                }
                return null;
              },
            ),
    );
  }
}

class CustomChachedNetworkImage extends StatefulWidget {
  const CustomChachedNetworkImage({
    super.key,
    required this.mediaUrl,
  });

  final String mediaUrl;

  @override
  State<CustomChachedNetworkImage> createState() =>
      _CustomChachedNetworkImageState();
}

class _CustomChachedNetworkImageState extends State<CustomChachedNetworkImage> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: widget.mediaUrl,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) {
          return const Icon(Icons.error);
        },
      ),
    );
  }
}

class CustomVideoCard extends StatelessWidget {
  const CustomVideoCard({
    super.key,
    required this.videoUrl,
  });

  final String videoUrl;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: generateThumbnaill(videoUrl: videoUrl),
        builder: (context, snapshot) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: snapshot.hasData
                ? Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Image.memory(
                          snapshot.data as Uint8List,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 23,
                          backgroundColor: Colors.black.withOpacity(0.5),
                          child: const Icon(
                            Icons.play_arrow,
                            size: 36,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.PRIMARY_COLOR,
                    ),
                  ),
          );
        });
  }
}

class AttachmentsFileCard extends StatefulWidget {
  const AttachmentsFileCard({
    super.key,
    required this.messageEntity,
  });

  final MessageEntity messageEntity;

  @override
  State<AttachmentsFileCard> createState() => _AttachmentsFileCardState();
}

class _AttachmentsFileCardState extends State<AttachmentsFileCard> {
  String? fileSize;
  String? fileExtension;

  @override
  void initState() {
    fileExtension =
        extension(widget.messageEntity.media[0].fileName ?? "Unknown")
            .toUpperCase();
    fileSize = formatFileSize(
        fileSizeInBytes: widget.messageEntity.media[0].fileSize ?? 100);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: context.isDarkMode ? AppColors.QUANTITY_COLOR : Colors.white,
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
            GestureDetector(
              onTap: () async {
                log("Downloading...");
                await downloadAndOpenFile(
                  fileUrl: widget.messageEntity.media[0].url,
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    // margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.insert_drive_file,
                          size: 40,
                          color: AppColors.GREY_DARK_COLOR,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(
                                widget.messageEntity.media[0].fileName ??
                                    "fileName",
                                overflow: TextOverflow.ellipsis,
                                style: Styles.mediumText(
                                    color: AppColors.GREY_DARK_COLOR),
                              ),
                            ),
                            Text(
                              '${fileSize ?? ''}'
                              ' - '
                              '$fileExtension',
                              style: Styles.smallText(
                                  color: AppColors.GREY_DARK_COLOR),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Label(
                    text: widget.messageEntity.time,
                    style: Styles.smallText(
                        color: context.isDarkMode
                            ? AppColors.BACKGROUND_COLOR
                            : AppColors.PRIMARY_COLOR),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
