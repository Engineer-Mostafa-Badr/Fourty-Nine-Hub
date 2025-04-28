import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_room_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:path/path.dart';

import '../../../../../../core/widget/custom_scaffold.dart';

// class OneTimeDocumentMessageViewParams {
//   final MessageEntity messageEntity;
//   final ChatRoomCubit chatRoomCubit;
//   OneTimeDocumentMessageViewParams(
//       {required this.messageEntity, required this.chatRoomCubit});
// }

// class OneTimeDocumentMessageView extends StatefulWidget {
//   const OneTimeDocumentMessageView(
//       {super.key, required this.oneTimeDocumentMessageViewParams});
//   final OneTimeDocumentMessageViewParams oneTimeDocumentMessageViewParams;

//   @override
//   State<OneTimeDocumentMessageView> createState() =>
//       _OneTimeDocumentMessageViewState();
// }

// class _OneTimeDocumentMessageViewState
//     extends State<OneTimeDocumentMessageView> {
//   int _selectedIndex = 0;
//   late PageController _pageController;
//   String? fileSize;
//   String? fileExtension;
//   bool isLoading = false;
//   @override
//   void initState() {
//     fileExtension = extension(widget.oneTimeDocumentMessageViewParams
//                 .messageEntity.media[0].fileName ??
//             "Unknown")
//         .toUpperCase();
//     fileSize = formatFileSize(
//         fileSizeInBytes: widget.oneTimeDocumentMessageViewParams.messageEntity
//                 .media[0].fileSize ??
//             100);

//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomScaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leadingWidth: 26,
//         leading: IconButton(
//           onPressed: () {
//             context.pop();
//           },
//           icon: const Icon(
//             Icons.arrow_back,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: context.read<ChatRoomCubit>().media.isNotEmpty
//             ? () async {
//                 setState(() {
//                   isLoading = true;
//                 });
// if (widget.oneTimeDocumentMessageViewParams.chatRoomCubit.media
//     .isNotEmpty) {
//   List<File> tempMedia = [
//     ...widget
//         .oneTimeDocumentMessageViewParams.chatRoomCubit.media
//   ]; // spread operator
//   widget.oneTimeDocumentMessageViewParams.chatRoomCubit.media
//       .clear();
//   for (var media in tempMedia) {
//     widget.oneTimeDocumentMessageViewParams.chatRoomCubit.media
//         .add(media);
//     await widget.oneTimeDocumentMessageViewParams.chatRoomCubit
//         .sendMessage();
//     widget.oneTimeDocumentMessageViewParams.chatRoomCubit.media
//         .clear();
//   }
// }
//                 setState(() {
//                   isLoading = false;
//                 });
//                 context.pop();
//                 context.pop();
//               }
//             : null,
//         backgroundColor: context.read<ChatRoomCubit>().media.isNotEmpty
//             ? AppColors.BACKGROUND_COLOR
//             : Colors.grey,
//         child: isLoading
//             ? const CircularProgressIndicator(color: AppColors.PRIMARY_COLOR)
//             : const Icon(Icons.send, color: AppColors.PRIMARY_COLOR),
//       ),
//       body: BlocProvider.value(
//         value: widget.oneTimeDocumentMessageViewParams.chatRoomCubit,
//         child: Builder(builder: (context) {
//           final isArabic = LocaleKeys.more.tr() == "More";

//           return Stack(
//             children: [
//               Positioned.fill(
//                 child: PageView.builder(
//                   controller: _pageController,
//                   itemCount: context.read<ChatRoomCubit>().media.length,
//                   onPageChanged: (index) {},
//                   itemBuilder: (context, index) {
//                     return Container(
//                       color: Colors.transparent,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Container(
//                             decoration: BoxDecoration(
//                               color: context.isDarkMode
//                                   ? AppColors.QUANTITY_COLOR
//                                   : Colors.white,
//                               borderRadius: BorderRadius.only(
//                                 topLeft: const Radius.circular(12),
//                                 topRight: const Radius.circular(12),
//                                 bottomLeft: isArabic
//                                     ? const Radius.circular(0)
//                                     : const Radius.circular(12),
//                                 bottomRight: isArabic
//                                     ? const Radius.circular(12)
//                                     : const Radius.circular(0),
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: context.isDarkMode
//                                       ? AppColors.BACKGROUND_COLOR
//                                           .withOpacity(0.05)
//                                       : Colors.black12,
//                                   blurRadius: 8,
//                                   offset: const Offset(0, 4),
//                                 ),
//                               ],
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 SizedBox(
//                                   width: double.infinity,
//                                   // height:widget.messageEntity.hasReply? MediaQuery.of(context).size.height * 0.15:MediaQuery.of(context).size.height * 0.08,
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(8),
//                                       child: Container(
//                                         padding: const EdgeInsets.all(8),
//                                         // margin: const EdgeInsets.all(8),
//                                         decoration: BoxDecoration(
//                                           color: Colors.black.withOpacity(0.1),
//                                         ),
//                                         child: Row(
//                                           children: [
//                                             const Icon(
//                                               Icons.insert_drive_file,
//                                               size: 40,
//                                               color: AppColors.GREY_DARK_COLOR,
//                                             ),
//                                             Column(
//                                               mainAxisSize: MainAxisSize.min,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 SizedBox(
//                                                   width: MediaQuery.of(context)
//                                                           .size
//                                                           .width *
//                                                       0.5,
//                                                   child: Text(
//                                                     widget
//                                                             .oneTimeDocumentMessageViewParams
//                                                             .messageEntity
//                                                             .media[0]
//                                                             .fileName ??
//                                                         "fileName",
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                     style: Styles.mediumText(
//                                                         color: AppColors
//                                                             .GREY_DARK_COLOR),
//                                                   ),
//                                                 ),
//                                                 Text(
//                                                   '${fileSize ?? ''}'
//                                                   ' - '
//                                                   '$fileExtension',
//                                                   style: Styles.smallText(
//                                                       color: AppColors
//                                                           .GREY_DARK_COLOR),
//                                                 )
//                                               ],
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(
//                     context.read<ChatRoomCubit>().isOneTimeView
//                         ? Icons.looks_one
//                         : Icons.looks_one_outlined,
//                     color: Colors.grey),
//                 onPressed: () async {
//                   setState(() {
//                     context.read<ChatRoomCubit>().isOneTimeView =
//                         !context.read<ChatRoomCubit>().isOneTimeView;
//                   });
//                 },
//               )
//             ],
//           );
//         }),
//       ),
//     );
//   }
// }

class OneTimeDocumentMessageViewParams {
  // final MessageEntity messageEntity;
  final ChatRoomCubit chatRoomCubit;

  OneTimeDocumentMessageViewParams({
    // required this.messageEntity,
    required this.chatRoomCubit,
  });
}

class OneTimeDocumentMessageView extends StatefulWidget {
  const OneTimeDocumentMessageView(
      {super.key, required this.oneTimeDocumentMessageViewParams});

  final OneTimeDocumentMessageViewParams oneTimeDocumentMessageViewParams;

  @override
  State<OneTimeDocumentMessageView> createState() =>
      _OneTimeDocumentMessageViewState();
}

class _OneTimeDocumentMessageViewState
    extends State<OneTimeDocumentMessageView> {
  int _selectedIndex = 0;
  late PageController _pageController;

  // String? fileSize;
  String? fileExtension;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(); // Initialize PageController
    fileExtension = extension(widget
            .oneTimeDocumentMessageViewParams.chatRoomCubit.media[0].path
            .split('.')
            .last)
        .toUpperCase();
    // fileSize = formatFileSize(
    //     fileSizeInBytes: widget.oneTimeDocumentMessageViewParams.chatRoomCubit
    //             .media[0].readAsBytes().length ??
    //         100);
  }

  @override
  void dispose() {
    _pageController.dispose();
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
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget
                .oneTimeDocumentMessageViewParams.chatRoomCubit.media.isNotEmpty
            ? () async {
                setState(() {
                  isLoading = true;
                });
                if (widget.oneTimeDocumentMessageViewParams.chatRoomCubit.media
                    .isNotEmpty) {
                  List<File> tempMedia = [
                    ...widget
                        .oneTimeDocumentMessageViewParams.chatRoomCubit.media
                  ]; // spread operator
                  widget.oneTimeDocumentMessageViewParams.chatRoomCubit.media
                      .clear();
                  for (var media in tempMedia) {
                    widget.oneTimeDocumentMessageViewParams.chatRoomCubit.media
                        .add(media);
                    // widget.oneTimeDocumentMessageViewParams.chatRoomCubit
                    //     .isOneTimeView = true;
                    await widget.oneTimeDocumentMessageViewParams.chatRoomCubit
                        .sendMessage();
                    widget.oneTimeDocumentMessageViewParams.chatRoomCubit.media
                        .clear();
                  }
                }
                setState(() {
                  isLoading = false;
                });
                Navigator.pop(context);
                Navigator.pop(context);
              }
            : null,
        backgroundColor: widget
                .oneTimeDocumentMessageViewParams.chatRoomCubit.media.isNotEmpty
            ? AppColors.BACKGROUND_COLOR
            : Colors.grey,
        child: isLoading
            ? const CircularProgressIndicator(color: AppColors.PRIMARY_COLOR)
            : const Icon(Icons.send, color: AppColors.PRIMARY_COLOR),
      ),
      body: BlocProvider.value(
        value: widget.oneTimeDocumentMessageViewParams.chatRoomCubit,
        child: Builder(builder: (context) {
          return Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: widget.oneTimeDocumentMessageViewParams.chatRoomCubit
                    .media.length,
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index; // Update current page index
                    fileExtension = extension(widget
                            .oneTimeDocumentMessageViewParams
                            .chatRoomCubit
                            .media[_selectedIndex]
                            .path
                            .split('.')
                            .last)
                        .toUpperCase();
                    // fileSize = formatFileSize(
                    //     fileSizeInBytes: widget.oneTimeDocumentMessageViewParams
                    //             .messageEntity.media[_selectedIndex].fileSize ??
                    //         100);
                  });
                },
                itemBuilder: (context, index) {
                  return Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 56,
                      color: Colors.transparent,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Content of each page
                          Container(
                            decoration: const BoxDecoration(
                              color: AppColors.QUANTITY_COLOR,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.insert_drive_file,
                                    size: 40,
                                    color: AppColors.GREY_DARK_COLOR,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: Text(
                                          widget
                                              .oneTimeDocumentMessageViewParams
                                              .chatRoomCubit
                                              .media[_selectedIndex]
                                              .path
                                              .split('.')
                                              .last,
                                          overflow: TextOverflow.ellipsis,
                                          style: Styles.mediumText(
                                              color: AppColors.GREY_DARK_COLOR),
                                        ),
                                      ),
                                      // Text(
                                      //   '${fileSize ?? ''} - $fileExtension',
                                      //   style: Styles.smallText(
                                      //       color: AppColors.GREY_DARK_COLOR),
                                      // ),
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
                },
              ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.oneTimeDocumentMessageViewParams.chatRoomCubit
                          .media.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        width: _selectedIndex == index ? 12.0 : 8.0,
                        height: _selectedIndex == index ? 12.0 : 8.0,
                        decoration: BoxDecoration(
                          color: _selectedIndex == index
                              ? AppColors.PRIMARY_COLOR_DARK
                              : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 28,
                left: 8,
                child: IconButton(
                  icon: Icon(
                    widget.oneTimeDocumentMessageViewParams.chatRoomCubit
                            .isOneTimeView
                        ? Icons.looks_one
                        : Icons.looks_one_outlined,
                    color: Colors.grey,
                    size: 30,
                  ),
                  onPressed: () async {
                    setState(() {
                      widget.oneTimeDocumentMessageViewParams.chatRoomCubit
                              .isOneTimeView =
                          !widget.oneTimeDocumentMessageViewParams.chatRoomCubit
                              .isOneTimeView;
                    });
                  },
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
