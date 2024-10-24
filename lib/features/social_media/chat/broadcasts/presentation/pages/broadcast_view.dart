import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/read_more_label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

class BroadcastView extends StatefulWidget {
  const BroadcastView({super.key});

  @override
  State<BroadcastView> createState() => _BroadcastViewState();
}

class _BroadcastViewState extends State<BroadcastView> {
  bool isFollowing = false;

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Scroll to the end when the screen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToEnd();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.PRIMARY_COLOR, // Background color
        elevation: 0,
        leadingWidth: 26,

        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(
                  "https://seeklogo.com/images/B/bbc-news-logo-8648ABD044-seeklogo.com.png"),
            ),
            const SizedBox(width: 12), // Spacing between avatar and text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.44),
                  child: Text(
                    'BBC News',
                    overflow: TextOverflow.ellipsis,
                    style: Styles.headerText(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Text(
                  '5K Followers',
                  overflow: TextOverflow.ellipsis,
                  style: Styles.smallText(
                    color: AppColors.GREY_NORMAL_COLOR,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ],
        ),
        actions: [
          isFollowing
              ? PopupMenuButton(
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                  color: context.isDarkMode
                      ? AppColors.PRIMARY_COLOR
                      : AppColors.BACKGROUND_COLOR,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  ),
                  offset: const Offset(0, 50),
                  onSelected: (int value) async {
                    if (value == 1) {
                      setState(() {
                        isFollowing = false;
                      });
                    }
                  },
                  itemBuilder: (context) {
                    return _mainMenuBuilder();
                  },
                )
              : InkWell(
                  onTap: () {
                    setState(() {
                      isFollowing = true;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.only(left: 16, right: 16),
                    decoration: BoxDecoration(
                      color: AppColors.BACKGROUND_COLOR,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      LocaleKeys.follow.tr(),
                      style: Styles.mediumText(
                        color: AppColors.PRIMARY_COLOR_DARK,
                        fontWeight: FontWeight.w600,
                        fontSize: 26,
                      ),
                    ),
                  ),
                )
        ],
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              Assets.chatRoomBackground,
              scale: 7,
              // fit: BoxFit.cover,
              repeat: ImageRepeat.repeat,
              opacity: context.isDarkMode
                  ? const AlwaysStoppedAnimation(0.1)
                  : const AlwaysStoppedAnimation(0.7),
            ),
          ),
          // Chat content
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              controller: _scrollController,
              children: [
                _buildBroadcastMessage(
                  context,
                  "قد جاءكم من الله نور",
                  "2:35 pm",
                ),
                _buildBroadcastMessage(
                  context,
                  "وأحسن منك لم تر قط عيني",
                  "3:24 pm",
                ),
                const BroadcastImage(
                  imagesUrl:
                      'https://www.arabnet5.com/media/638/news_%D8%B5%D9%84%D8%A7%D8%A9-%D8%A7%D9%84%D8%B9%D8%B5%D8%B1_20220725311439.jpg',
                  time: "5:00 pm",
                ),
                _buildBroadcastMessage(
                  context,
                  "قد جاءكم من الله نور",
                  "2:35 pm",
                ),
                _buildBroadcastMessage(
                  context,
                  "وأحسن منك لم تر قط عيني",
                  "3:24 pm",
                ),
                const BroadcastImage(
                  imagesUrl:
                      'https://www.arabnet5.com/media/638/news_%D8%B5%D9%84%D8%A7%D8%A9-%D8%A7%D9%84%D8%B9%D8%B5%D8%B1_20220725311439.jpg',
                  time: "5:00 pm",
                ),
                _buildBroadcastMessage(
                  context,
                  "قد جاءكم من الله نور",
                  "2:35 pm",
                ),
                _buildBroadcastMessage(
                  context,
                  "وأحسن منك لم تر قط عيني",
                  "3:24 pm",
                ),
                const BroadcastImage(
                  imagesUrl:
                      'https://www.arabnet5.com/media/638/news_%D8%B5%D9%84%D8%A7%D8%A9-%D8%A7%D9%84%D8%B9%D8%B5%D8%B1_20220725311439.jpg',
                  time: "5:00 pm",
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PopupMenuEntry<int>> _mainMenuBuilder() {
    return [
      PopupMenuItem<int>(
        value: 0,
        child: Text(
          LocaleKeys.channelInfo.tr(),
          style: Styles.mediumText(
              color:
                  context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR),
        ),
      ),
      PopupMenuItem<int>(
        value: 1,
        child: Text(
          LocaleKeys.unfollow.tr(),
          style: Styles.mediumText(
              color:
                  context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR),
        ),
      ),
      PopupMenuItem<int>(
        value: 2,
        child: Text(
          LocaleKeys.share.tr(),
          style: Styles.mediumText(
              color:
                  context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR),
        ),
      ),
      PopupMenuItem<int>(
        value: 3,
        child: Text(
          LocaleKeys.report.tr(),
          style: Styles.mediumText(
              color:
                  context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR),
        ),
      ),
    ];
  }

  Widget _buildBroadcastMessage(
    BuildContext context,
    String message,
    String time,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IntrinsicWidth(
            child: Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: context.isDarkMode
                    ? AppColors.QUANTITY_COLOR
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: context.isDarkMode
                        ? Colors.white.withOpacity(0.05)
                        : Colors.black12,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 48),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: ReadMoreLabel(
                        // trimLines: 6,
                        text: message,
                        style: Styles.mediumText(
                          color: context.isDarkMode
                              ? Colors.white
                              : AppColors.PRIMARY_COLOR,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Label(
                      text: time,
                      style: Styles.smallText(
                          color: context.isDarkMode
                              ? Colors.white
                              : AppColors.PRIMARY_COLOR),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BroadcastImage extends StatelessWidget {
  final String imagesUrl;
  final String time;

  const BroadcastImage(
      {super.key, required this.imagesUrl, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 6, bottom: 6),
      child: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: context.isDarkMode
                    ? AppColors.QUANTITY_COLOR
                    : AppColors.BACKGROUND_COLOR,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: context.isDarkMode
                        ? Colors.white.withOpacity(0.05)
                        : Colors.black.withOpacity(0.1),
                    spreadRadius: 0.1,
                    blurRadius: 5,
                    offset: const Offset(0, 0), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: imagesUrl,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => const SizedBox(),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.error,
                            color: AppColors.PRIMARY_COLOR_DARK,
                          ),
                        ),
                        // child: Image.network(
                        // '${ApiService.imagesBaseUrl}'
                        // '${messageModel.content}',
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          time,
                          style: Styles.smallText(
                              color: AppColors.GREY_DARK_COLOR),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
