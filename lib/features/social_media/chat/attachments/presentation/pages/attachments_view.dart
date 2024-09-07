import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:intl/intl.dart';

class AttachementsView extends StatefulWidget {
  const AttachementsView({super.key});

  @override
  AttachementsViewState createState() => AttachementsViewState();
}

class AttachementsViewState extends State<AttachementsView> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.PRIMARY_COLOR,
        title: Text(
          'Attachments',
          style: Styles.headerText(
            fontWeight: FontWeight.bold,
            color: AppColors.BACKGROUND_COLOR,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            size: 40.zW,
            color: AppColors.BACKGROUND_COLOR,
          ),
        ),
        bottom: const TabBar(
              indicatorColor:AppColors.BACKGROUND_COLOR,
              indicatorWeight: 3,
              // indicatorPadding: const EdgeInsets.symmetric(horizontal: 2),
              unselectedLabelColor: AppColors.UNSELECTED_GRAY_COLOR,
              labelColor:
                  AppColors.BACKGROUND_COLOR,
              tabs: [
                Tab(
                  text: 'Media',
                ),
                Tab(
                  text: 'Links',
                ),
                Tab(
                  text: 'Docs',
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
                                DateFormat.yMMMM() as String,
                                style: Styles.smallText(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: AppColors.BACKGROUND_COLOR,
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
                              itemCount:
                                  10,
                              itemBuilder: (context, index) {
                                return AttachmentsImageCard();
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  )
                // : Center(
                //     child: Text(
                //       'No Media',
                //       style: TextStyle(
                //         fontWeight: FontWeight.w500,
                //         fontSize: 16,
                //         color:
                //             BlocProvider.of<UserCubit>(context).systemTheme ==
                //                     'Dark'
                //                 ? Constants.whiteColor
                //                 : Constants.blackColor,
                //       ),
                //     ),
                //   ),
            ,

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
                              child: Text( DateFormat.yMMMM() as String,
                                style:  Styles.smallText(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: AppColors.BACKGROUND_COLOR,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                // : Center(
                //     child: Text(
                //       'No Links',
                //       style: TextStyle(
                //         fontWeight: FontWeight.w500,
                //         fontSize: 16,
                //         color:
                //             BlocProvider.of<UserCubit>(context).systemTheme ==
                //                     'Dark'
                //                 ? Constants.whiteColor
                //                 : Constants.blackColor,
                //       ),
                //     ),
                //   ),
,
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
                                DateFormat.yMMMM() as String,
                                style: Styles.smallText(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: AppColors.BACKGROUND_COLOR,
                                ),
                              ),
                            ),
                            // Show file messages for the month in ListView
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount:10,
                              itemBuilder: (context, index) {
                                return AttachmentsFileCard(
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  )
                // : Center(
                //     child: Text(
                //       'No Files',
                //       style: TextStyle(
                //         fontWeight: FontWeight.w500,
                //         fontSize: 16,
                //         color:
                //             BlocProvider.of<UserCubit>(context).systemTheme ==
                //                     'Dark'
                //                 ? Constants.whiteColor
                //                 : Constants.blackColor,
                //       ),
                //     ),
                //   ),
                ,

            
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 10),
            //   child: GridView.builder(
            //     physics: const BouncingScrollPhysics(),
            //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //       crossAxisCount: 3, // 3 columns
            //       crossAxisSpacing: 4.0,
            //       mainAxisSpacing: 4.0,
            //     ),
            //     itemCount: mediaMessages.length,
            //     itemBuilder: (context, index) {
            //       if (mediaMessages[index].contentType == 'Image') {
            //         return AttachmentsImageCard(
            //             messageModel: mediaMessages[index]);
            //       } else {
            //         return AttachmentsVideoCard(
            //           messageModel: mediaMessages[index],
            //         );
            //       }
            //     },
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 16.0),
            //   child: ListView.builder(
            //     physics: const BouncingScrollPhysics(),
            //     scrollDirection: Axis.vertical,
            //     itemCount: filesMessages.length,
            //     itemBuilder: (context, index) {
            //       return AttachmentsFileCard(
            //         messageModel: filesMessages[index],
            //       );
            //     },
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 16.0),
            //   child: ListView.builder(
            //     physics: const BouncingScrollPhysics(),
            //     scrollDirection: Axis.vertical,
            //     itemCount: voiceMessages.length,
            //     itemBuilder: (context, index) {
            //       return AttachmentsVoiceCard(
            //         messageModel: voiceMessages[index],
            //       );
            //     },
            //   ),
            // ),
            // const Center(
            //   child: Text('No Links'),
            // ),
          ],
        ),
      ),
    );
  }
}

class AttachmentsImageCard extends StatelessWidget {
  const AttachmentsImageCard({
    super.key,
    required this.messageModel,
  });

  final MessageModel messageModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
          context,
          settings: const RouteSettings(
            name: ImageView.routeName,
          ),
          screen: ImageView(messageModel: messageModel),
          withNavBar: false,
          pageTransitionAnimation: PageTransitionAnimation.fade,
        );
      },
      child: CachedNetworkImage(
        imageUrl: '${ApiService.imagesBaseUrl}'
            '${messageModel.content}',
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
          color: Constants.redColor,
        ),
      ),
    );
  }
}

// class AttachmentsVideoCard extends StatefulWidget {
//   const AttachmentsVideoCard({
//     Key? key,
//     required this.messageModel,
//   }) : super(key: key);
//   final MessageModel messageModel;

//   @override
//   State<AttachmentsVideoCard> createState() => _AttachmentsVideoCardState();
// }

// class _AttachmentsVideoCardState extends State<AttachmentsVideoCard> {
//   String videoDuration = '';
//   // late CachedVideoPlayerController _videoPlayerController;

//   @override
//   void initState() {
//     super.initState();
//     _videoPlayerController = CachedVideoPlayerController.network(
//         'https://video-lhr8-2.xx.fbcdn.net/v/t42.1790-2/416523957_1332442717441367_8750097845660065143_n.mp4?_nc_cat=106&ccb=1-7&_nc_sid=55d0d3&efg=eyJybHIiOjY0MiwicmxhIjo1MTIsInZlbmNvZGVfdGFnIjoic3ZlX3NkIn0%3D&_nc_ohc=EYI_famUFFkAX_LOKpB&rl=642&vabr=357&_nc_ht=video-lhr8-2.xx&edm=AGo2L-IEAAAA&oh=00_AfD0C8e_KdoZv8DHaOEmwUIQXA_Jm54igTNCCzKC2rKwxg&oe=65C8F046')
//       ..initialize().then((value) {
//         // _videoPlayerController.play();
//         setState(() {
//           videoDuration = formatDuration(_videoPlayerController.value.duration);
//         });
//       });
//   }

//   String formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return '$twoDigitMinutes:$twoDigitSeconds';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _videoPlayerController.value.isInitialized
//         ? GestureDetector(
//             onTap: () {
//               PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
//                 context,
//                 settings: const RouteSettings(
//                   name: VideoPlayerWidget.routeName,
//                 ),
//                 screen: const VideoPlayerWidget(
//                   videoData:
//                       'https://video-lhr8-2.xx.fbcdn.net/v/t42.1790-2/416523957_1332442717441367_8750097845660065143_n.mp4?_nc_cat=106&ccb=1-7&_nc_sid=55d0d3&efg=eyJybHIiOjY0MiwicmxhIjo1MTIsInZlbmNvZGVfdGFnIjoic3ZlX3NkIn0%3D&_nc_ohc=EYI_famUFFkAX_LOKpB&rl=642&vabr=357&_nc_ht=video-lhr8-2.xx&edm=AGo2L-IEAAAA&oh=00_AfD0C8e_KdoZv8DHaOEmwUIQXA_Jm54igTNCCzKC2rKwxg&oe=65C8F046',
//                   // videoData: '${ApiService.imagesBaseUrl}'
//                   //     '${widget.messageModel.content}',
//                 ),
//                 withNavBar: false,
//                 pageTransitionAnimation: PageTransitionAnimation.fade,
//               );
//             },
//             child: AspectRatio(
//               aspectRatio: _videoPlayerController.value.aspectRatio,
//               child: Stack(
//                 children: [
//                   CachedVideoPlayer(_videoPlayerController),
//                   Positioned(
//                     bottom: 4,
//                     left: 4,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: Constants.blackColor.withOpacity(0.5),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(2),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             const Icon(
//                               Icons.play_arrow,
//                               color: Constants.whiteColor,
//                               size: 18,
//                             ),
//                             Text(
//                               videoDuration,
//                               style: const TextStyle(
//                                 color: Constants.whiteColor,
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           )
//         : const Center(child: CircularProgressIndicator());
//   }

//   @override
//   void dispose() {
//     _videoPlayerController.dispose();
//     super.dispose();
//   }
// }

class AttachmentsFileCard extends StatefulWidget {
  const AttachmentsFileCard({
    Key? key,
    required this.messageModel,
  }) : super(key: key);
  final MessageModel messageModel;
  @override
  State<AttachmentsFileCard> createState() => _AttachmentsFileCardState();
}

class _AttachmentsFileCardState extends State<AttachmentsFileCard> {
  String? fileName;
  String? fileSize;
  String? fileExtension;
  @override
  void initState() {
    super.initState();

    fileName = getFileName();
    fileExtension = extension(fileName!).substring(1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 8, bottom: 6, top: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                downloadAndOpenFile(
                  fileUrl:
                      ApiService.imagesBaseUrl + widget.messageModel.content!,
                  contentType: widget.messageModel.contentType!,
                );
              },
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.08,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.insert_drive_file,
                        size: 60,
                        color: Constants.primaryColor,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(
                              fileName!,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.openSans(
                                color: Constants.blackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          FutureBuilder(
                            future: getFileSizeAsync(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return Text(
                                  '${fileSize ?? ''}'
                                  ' - '
                                  '$fileExtension',
                                  style: GoogleFonts.openSans(
                                      color: Constants.greyColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          )
                        ],
                      ),
                      const Spacer(),
                      Text(
                        DateFormat('h:mm a')
                            .format(widget.messageModel.createdAt!),
                        style: GoogleFonts.openSans(
                            color: Constants.greyColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getFileName() {
    String fileUrl = ApiService.imagesBaseUrl + widget.messageModel.content!;

    String fileName = extractFileName(fileUrl);
    String cleanedFileName = cleanFileName(fileName);
    // print('file name : $cleanedFileName'); // Output: pdf-test.pdf
    return cleanedFileName;
  }

  String extractFileName(String url) {
    Uri uri = Uri.parse(url);
    String path = uri.path;
    List<String> segments = path.split('/');
    return segments.last;
  }

  String cleanFileName(String fileName) {
    // Assuming the format is UUID-fileName.pdf
    return fileName.substring(37);
  }

  Future<void> getFileSizeAsync() async {
    fileSize = await getFileSize(
      fileUrl: ApiService.imagesBaseUrl + widget.messageModel.content!,
    );
  }

  Future<String?> getFileSize({required String fileUrl}) async {
    try {
      final response = await http.head(Uri.parse(fileUrl));

      if (response.statusCode == 200) {
        // Content-Length header contains the file size in bytes
        String? contentLengthHeader = response.headers['content-length'];
        if (contentLengthHeader != null) {
          int fileSizeInBytes = int.parse(contentLengthHeader);

          // Convert the file size to a formatted string
          // print(formatFileSize(fileSizeInBytes: fileSizeInBytes));
          return formatFileSize(fileSizeInBytes: fileSizeInBytes);
        } else {
          // print('Content-Length header not found in the response.');
        }
      } else {
        // print('Failed to fetch file size. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // print('Error: $e');
    }
    return null;
  }

  String formatFileSize({required int fileSizeInBytes}) {
    const int kb = 1024;
    const int mb = kb * 1024;
    const int gb = mb * 1024;

    if (fileSizeInBytes < kb) {
      return '$fileSizeInBytes B';
    } else if (fileSizeInBytes < mb) {
      double sizeInKB = fileSizeInBytes / kb;
      return '${sizeInKB.toStringAsFixed(2)} KB';
    } else if (fileSizeInBytes < gb) {
      double sizeInMB = fileSizeInBytes / mb;
      return '${sizeInMB.toStringAsFixed(2)} MB';
    } else {
      double sizeInGB = fileSizeInBytes / gb;
      return '${sizeInGB.toStringAsFixed(2)} GB';
    }
  }
}

class AttachmentsVoiceCard extends StatefulWidget {
  const AttachmentsVoiceCard({
    Key? key,
    required this.messageModel,
  }) : super(key: key);
  final MessageModel messageModel;
  @override
  State<AttachmentsVoiceCard> createState() => _AttachmentsVoiceCardState();
}

class _AttachmentsVoiceCardState extends State<AttachmentsVoiceCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: VoiceMessageView(
        activeSliderColor: Constants.primaryColor,
        circlesColor: Constants.primaryColor,
        backgroundColor: Constants.whiteColor,
        controller: VoiceController(
          audioSrc: "https://server12.mp3quran.net/maher/001.mp3",
          maxDuration: const Duration(minutes: 1000),
          isFile: false,
          onComplete: () {},
          onPause: () {},
          onPlaying: () {},
          onError: (p0) {},
        ),
      ),
    );
  }
}
