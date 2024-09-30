import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class AttachementsView extends StatefulWidget {
  const AttachementsView({super.key});

  @override
  AttachementsViewState createState() => AttachementsViewState();
}

class AttachementsViewState extends State<AttachementsView> {
  static final List<Map<String, String>> links = [
    {
      "title": "DotNet G2 - Google Drive",
      "url": "drive.google.com",
    },
    {
      "title": "SharePoint Link",
      "url": "elengmenofiaedu-my.sharepoint.com",
    },
    {
      "title": "Google Drive Folder",
      "url": "drive.google.com",
    },
    {
      "title": "Mega Folder",
      "url": "mega.nz",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
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
                text: LocaleKeys.links.tr(),
              ),
              Tab(
                text: LocaleKeys.docs.tr(),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, monthIndex) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Show month header
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${LocaleKeys.june.tr()} 2023",
                          style: Styles.mediumText(
                            fontWeight: FontWeight.w500,
                            // fontSize: 16,
                            color: AppColors.PRIMARY_COLOR,
                          ),
                        ),
                      ),
                      // Show media messages for the month in GridView
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // 3 columns
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0,
                        ),
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return const AttachmentsImageCard();
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ListView.builder(
                itemCount: links.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // Last week header
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${LocaleKeys.june.tr()} 2023",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }

                  final link = links[index - 1];
                  return InkWell(
                    onTap: () {
                      // Handle link click (e.g., navigate or open the URL)
                    },
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
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
                                Text(
                                  link["title"]!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(link["url"]!),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: 10,
                itemBuilder: (context, monthIndex) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Show month header
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${LocaleKeys.june.tr()} 2023",
                          style: Styles.mediumText(
                            fontWeight: FontWeight.w500,
                            // fontSize: 16,
                            color: AppColors.PRIMARY_COLOR,
                          ),
                        ),
                      ),
                      // Show file messages for the month in ListView
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return const AttachmentsFileCard();
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AttachmentsImageCard extends StatelessWidget {
  const AttachmentsImageCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl:
          'https://cdn.pixabay.com/photo/2023/11/09/19/36/zoo-8378189_1280.jpg',
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
        color: AppColors.SECONDARY_COLOR,
      ),
    );
  }
}

class AttachmentsFileCard extends StatefulWidget {
  const AttachmentsFileCard({
    super.key,
  });

  @override
  State<AttachmentsFileCard> createState() => _AttachmentsFileCardState();
}

class _AttachmentsFileCardState extends State<AttachmentsFileCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle file card click
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.grey[200], // Set the background color to gray
          borderRadius: BorderRadius.circular(8.0), // Rounded corners
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.08,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.insert_drive_file,
                      size: 60,
                      color: AppColors.UNSELECTED_GRAY_COLOR,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            "file name",
                            overflow: TextOverflow.ellipsis,
                            style: Styles.mediumText(
                              color: AppColors.PRIMARY_COLOR,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          '200 MB - PDF',
                          style: Styles.mediumText(
                            color: AppColors.DARK_GRAY_COLOR,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      "11:10 am",
                      style: Styles.smallText(
                        color: AppColors.DARK_GRAY_COLOR,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
